# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Project Overview

PDFFigures 2.0 (Zig port) extracts figures, tables, captions, and section titles from scholarly PDFs. This is a mechanical line-by-line translation of the [Scala/PDFBox original](../pdffigures2) to Zig/MuPDF. Every heuristic, constant, and algorithm is preserved exactly. Output JSON must match (within f64 epsilon) for the same PDF.

## Build / Test / Run

```bash
zig build              # Build binary → zig-out/bin/pdffigures2
zig build test         # Run all 46 tests
zig build run -- paper.pdf  # Run on a PDF
```

Tests use `std.testing.allocator` which detects memory leaks. MuPDF objects use arena allocation and will show leak warnings from the debug allocator — this is expected.

## Architecture

### Module Dependency Layers

```
Layer 0 (no deps):  box.zig, paragraph.zig, figure.zig, logging.zig, mupdf.zig
Layer 1:             page.zig (tagged union of Page* types)
Layer 2:             extract/text.zig, layout.zig, extract/graphic.zig, extract/raster.zig
Layer 3:             extract/formatting.zig, extract/graphics.zig, extract/paragraph_rebuild.zig
Layer 4:             detect/caption.zig, detect/caption_builder.zig, extract/section_title.zig
Layer 5:             classify/region.zig, build/sectioned_text.zig
Layer 6:             detect/figure.zig, render/figure.zig, render/interruptible.zig
Layer 7:             extractor.zig (orchestrator), json.zig
Layer 8:             cli/batch.zig, cli/visualize.zig, main.zig
```

### Pipeline Flow

`extractor.zig:parseDocument()` orchestrates the full pipeline:

1. `TextExtractor` → `PageWithText` — Structured Word→Line→Paragraph hierarchy via `fz_stext_page`
2. `FormattingTextExtractor` → `PageWithClassifiedText` — Headers, page numbers, abstract detection
3. `DocumentLayout` → `DocumentLayout` — Weighted medians, two-column detection, font stats
4. `CaptionDetector` → `Seq[CaptionStart]` — Regex-based caption pattern matching
5. `GraphicsExtractor` → `PageWithGraphics` — `fz_device` callbacks for graphic bounding boxes
6. `CaptionBuilder` → `PageWithCaptions` — Expand caption-start lines into full caption paragraphs
7. `RegionClassifier` → `PageWithBodyText` — Seven-classifier chain for body vs. figure text
8. `FigureDetector` → `PageWithFigures` — Proposals in 4 directions + Cartesian product scoring + splitProposals
9. `FigureRenderer` → `[]RasterizedFigure` — Per-page rendering via `fz_new_pixmap_from_page_number`

### Key Technology Mapping

| Scala | Zig |
|-------|-----|
| PDFBox `PDFTextStripper` | MuPDF `fz_stext_page` (blocks→lines→chars with quads) |
| PDFBox `PDFGraphicsStreamEngine` | MuPDF `fz_device` with overridden callbacks |
| `java.awt.image.BufferedImage` | Raw RGBA pixel data (`[]u8`) |
| spray-json | `std.json.stringify` |
| scopt `OptionParser` | Manual `std.process.Args.Iterator` |
| `scala.collection.parallel` | Not yet implemented (planned: `std.Thread` pool) |
| `Thread.interrupted()` checks | Not yet implemented (planned: `std.atomic.Value(bool)`) |
| `java.text.Normalizer` (NFKC) | Manual lookup table for affected codepoint ranges |

### Coordinate System

MuPDF uses top-left origin (y↓) which matches the internal `Box` coordinate system naturally. No coordinate flip needed for text extraction (`fz_stext_page`). For graphics (`fz_device` callbacks), coordinates must be verified per-operation.

### Box Coordinates

`Box` stores coordinates in PDF user space (72 DPI):
- `x1, y1` = top-left corner
- `x2, y2` = bottom-right corner
- `y1 < y2` always (MuPDF convention)

### Memory Strategy

- **MuPDF objects**: `defer fz_drop_*` for reference-counted handles (`fz_context`, `fz_document`, `fz_page`, `fz_stext_page`, `fz_device`, `fz_pixmap`)
- **Pipeline temporaries**: Arena allocator (`allocator` param), freed after per-page processing
- **Output data** (Figure, Caption): Caller's allocator (outlives pipeline)
- **Tests**: `std.testing.allocator` — detects leaks, double-frees, use-after-free (poisoned with `0xaa`)

### Coding Conventions

- **No comments** unless the WHY is non-obvious. No docstrings, no "added for X" comments.
- **Error handling**: Only at system boundaries (MuPDF C API calls, allocator calls). Internal invariants use `std.debug.assert`.
- **Naming**: Match Scala method/field names exactly where possible (e.g., `buildProposals`, `splitProposals`, `scoreProposal`).
- **Function ordering**: Match the Scala source file ordering so diffing is straightforward.
- **Tests**: Each module has inline tests. E2E tests in `e2e_test.zig` run on real PDFs.
- **No backwards-compatibility shims**: Delete, don't deprecate.

## Project Structure

```
pdffigures2-zig/
├── build.zig              # Build: MuPDF linking, test runner
├── build.zig.zon          # Version 0.1.0, Zig 0.17.0-dev.269+
├── src/
│   ├── main.zig           # Entry: single-PDF CLI
│   ├── box.zig            # Box struct + spatial algorithms
│   ├── paragraph.zig      # Word/Line/Paragraph/TextSpan + normalize
│   ├── figure.zig         # Figure, Caption, RasterizedFigure, SavedFigure, FigureType
│   ├── page.zig           # PageType tagged union (all 6 Page* variants)
│   ├── layout.zig         # DocumentLayout + weightedMedian
│   ├── logging.zig        # std.log.scoped wrapper
│   ├── mupdf.zig          # Auto-generated MuPDF C bindings (do not edit)
│   ├── json.zig           # JSON serialization (matches Scala JsonProtocol)
│   ├── extractor.zig      # FigureExtractor: pipeline orchestrator + public API
│   ├── e2e_test.zig       # End-to-end tests on real PDFs
│   ├── extract/           # Text, formatting, graphics, raster, section titles
│   ├── detect/            # Caption detection, caption building, figure detection
│   ├── classify/          # Region classification (body vs figure text)
│   ├── build/             # Sectioned text assembly
│   ├── render/            # Figure rendering, interruptible rendering
│   └── cli/               # Batch CLI, visualization CLI (skeletons)
└── test/
    └── test-pdfs/         # Test PDF files
```

## Reference: Scala Source

The authoritative reference is at `../pdffigures2/src/main/scala/org/allenai/pdffigures2/`. Key files and their Zig counterparts:

| Scala | Zig |
|-------|-----|
| `Box.scala` | `box.zig` |
| `Paragraph.scala` | `paragraph.zig` |
| `Figure.scala` | `figure.zig` |
| `PageStructure.scala` | `page.zig` |
| `TextExtractor.scala` | `extract/text.zig` |
| `FormattingTextExtractor.scala` | `extract/formatting.zig` |
| `DocumentLayout.scala` | `layout.zig` |
| `CaptionDetector.scala` | `detect/caption.zig` |
| `CaptionBuilder.scala` | `detect/caption_builder.zig` |
| `GraphicsExtractor.scala` / `GraphicBBDetector.scala` | `extract/graphics.zig` / `extract/graphic.zig` |
| `RegionClassifier.scala` | `classify/region.zig` |
| `FigureDetector.scala` | `detect/figure.zig` |
| `FigureRenderer.scala` | `render/figure.zig` |
| `FigureExtractor.scala` | `extractor.zig` |
| `JsonProtocol.scala` | `json.zig` |
| `FigureExtractorBatchCli.scala` | `cli/batch.zig` |
| `FigureExtractorVisualizationCli.scala` | `cli/visualize.zig` |

## Known Differences from Scala

1. **Page numbers**: Zig pages = Scala pages + 1 (MuPDF 1-indexed vs PDFBox 0-indexed)
2. **Caption text**: Some captions may differ slightly due to MuPDF paragraph grouping differences vs PDFBox
3. **Extra detections**: Zig may find additional figures Scala misses (confirmed correct in testing on paper008.pdf)
4. **MuPDF bindings**: `mupdf.zig` is auto-generated via `zig translate-c`. If MuPDF headers change, regenerate.

## MuPDF-Specific Adaptations

These are intentional deviations from Scala that compensate for MuPDF vs PDFBox differences:

### figure.zig (FigureDetector)
- **crop_content filter**: On two-column pages, column-spanning content is excluded from `Box.crop` to prevent over-cropping of single-column proposals. MuPDF captures full-width graphics/paragraphs that PDFBox doesn't.
- **Over-expansion constraints**: When no horizontal blockers exist, proposals are constrained to caption x-range + margin to avoid full-column-width proposals. MuPDF's `boxExpandLR` expands further due to different content box distribution.
- **Second-chance proposals**: Additional UP/DOWN proposals are attempted with relaxed constraints and `possible_figure_content`-based cropping when primary proposals fail.

### graphic.zig (GraphicsExtractor)
- **fillShade**: Intentionally a no-op, matching PDFBox's `GraphicBBDetector` behavior which does not intercept shading operations. MuPDF would otherwise capture gradient-filled background rectangles.

### text.zig (TextExtractor)
- **Gap-based word splitting**: When character-to-character gaps exceed a threshold (2× font size or 4pt), characters are split into separate words. Handles table data where PDF producers use absolute positioning instead of space characters.

### classifyIsTitle (RegionClassifier)
- Now fully implemented matching Scala's logic: alignment/centering check → title-start text → title-style (font consistency, non-standard fonts, all-caps detection). The original Zig stub checked only font size and was incorrect.