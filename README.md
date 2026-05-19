# PDFFigures 2.0 (Zig)

> A high-performance port of [allenai/pdffigures2](https://github.com/allenai/pdffigures2) from Scala/JVM to Zig/MuPDF — extract figures, tables, and captions from academic PDFs with zero false positives.

## Motivation

[PDFFigures 2.0](https://github.com/allenai/pdffigures2) is the standard tool for figure extraction from scholarly PDFs, used in large-scale mining pipelines including S2ORC and Semantic Scholar. The original Scala/PDFBox implementation has inherent limitations:

- **Heavy deployment**: Requires a JVM runtime plus a 19 MB fat JAR; a complete environment can reach hundreds of megabytes.
- **Slow startup**: JVM cold-start takes seconds, making it unsuitable for single-file processing or serverless workloads.
- **Difficult embedding**: JVM processes are awkward to embed in Python, Node.js, or Go toolchains — typically limited to subprocess invocation.
- **High memory baseline**: JVM heap overhead and GC pressure are significant when batch-processing large PDF collections.

This project is a **literal translation** of PDFFigures 2.0 into Zig, replacing PDFBox with the MuPDF C API. All heuristics, constants, and algorithm flows are preserved line-for-line. Output JSON is format-identical to the original.

## Design Goals

This is a faithful port, not a rewrite. The objective is not to "improve" the algorithm, but to:

1. **Output equivalence**: Same PDF → same Figure/Table detections, within f64 epsilon.
2. **Single native binary**: One statically-linked executable (~42 MB ReleaseSmall), no runtime dependencies beyond `libmupdf`. Milliseconds to start, not seconds.
3. **Embeddable**: C ABI shared library for direct use from Python, Node.js, Go, etc. Also supports JSON stdin/stdout integration.
4. **Full pipeline parity**: Text → Formatting → Layout → Captions → Graphics → Classification → Figure Detection — all stages implemented.

## Quick Start

```bash
# Debug build
zig build

# Release build (recommended)
zig build -Doptimize=ReleaseSmall

# Process a single PDF
./zig-out/bin/pdffigures2 paper.pdf

# Run all tests
zig build test
```

## Dependencies

- **Zig** 0.17.0-dev.269+ (nightly)
- **MuPDF** development libraries (via pkg-config) and all transitive dependencies

Ubuntu/Debian installation:

```bash
sudo apt install libmupdf-dev libmujs-dev libjpeg-dev libharfbuzz-dev \
  libfreetype-dev libpng-dev libbrotli-dev libopenjp2-7-dev libjbig2dec-dev \
  libgumbo-dev
```

Building MuPDF from source is also supported; ensure `pkg-config` can locate it.

## CLI Usage

```
pdffigures2 <pdf>                  Process a single PDF, output JSON to stdout
pdffigures2 batch <dir> [opts]     Batch processing (multi-threaded)
pdffigures2 visualize <pdf> [opts] Render annotated debug PNG
pdffigures2 dump <pdf> [page]      Dump raw extraction data for debugging
```

### Batch Mode Options

| Flag | Description |
|------|-------------|
| `-t N` | Thread count (default: all CPUs) |
| `-i DPI` | Render DPI (default: 300) |
| `-s FILE` | Output statistics JSON |
| `-m PREFIX` | Image output path prefix |
| `-d PREFIX` | Data JSON output path prefix |
| `-g PREFIX` | Full-text + section output path prefix |
| `-e` | Ignore errors, continue processing |
| `-f` | Allow OCR extraction |
| `-w` | Do not filter white graphics |

## Architecture

The extraction pipeline processes each page through sequential stages:

```
TextExtractor → FormattingTextExtractor → DocumentLayout →
CaptionDetector → GraphicsExtractor → CaptionBuilder →
RegionClassifier → FigureDetector → (FigureRenderer)
```

### Module Overview

~7,600 hand-written lines + ~6,500 lines of auto-generated MuPDF bindings.

| Layer | Module | Lines | Responsibility |
|-------|--------|------:|----------------|
| 0 | `box.zig` | 370 | Axis-aligned bounding box, spatial algorithms (merge, crop, intersection, gap detection) |
| 0 | `paragraph.zig` | 361 | Word → Line → Paragraph hierarchy, Unicode normalization |
| 0 | `figure.zig` | 189 | Output types: Figure, Caption, RasterizedFigure |
| 0 | `mupdf.zig` | 6,527 | MuPDF C API bindings (auto-generated via `zig translate-c`) |
| 1 | `page.zig` | 265 | Tagged union of 6 page-processing stages |
| 2 | `extract/text.zig` | 220 | Structured text extraction via `fz_stext_page` |
| 2 | `layout.zig` | 327 | Document layout statistics: weighted medians, two-column detection, font norms |
| 2 | `extract/graphic.zig` | 370 | Graphics bounding boxes via `fz_device` callbacks |
| 2 | `extract/raster.zig` | 128 | Raster image extraction |
| 3 | `extract/formatting.zig` | 518 | Header, page number, and abstract detection (font-size and position heuristics) |
| 3 | `extract/graphics.zig` | 334 | Figure graphics vs. non-figure graphics (watermarks, decorations) separation |
| 3 | `extract/paragraph_rebuild.zig` | 105 | Paragraph merging based on line spacing and alignment |
| 4 | `detect/caption.zig` | 455 | Regex-based caption matching with deduplication |
| 4 | `detect/caption_builder.zig` | 232 | Caption paragraph expansion (absorbing continuation lines) |
| 5 | `classify/region.zig` | 428 | Seven-classifier cascade: body text vs. in-figure text |
| 6 | `detect/figure.zig` | 1,001 | Core detection: four-direction proposals, Cartesian product search, overlap resolution |
| 6 | `render/figure.zig` | 311 | Figure region rendering to pixel buffer |
| 7 | `extractor.zig` | 397 | Pipeline orchestrator and public API |
| 7 | `json.zig` | 167 | JSON serialization (format-compatible with Scala `JsonProtocol`) |

### Key Design Decisions

**Coordinate system**: MuPDF uses top-left origin (y↓), consistent with the internal `Box` coordinate system — no flipping required.

**Memory management**: MuPDF objects use reference counting (`fz_drop_*`). Pipeline temporaries use arena allocation; per-page data is freed after each page completes. Output data is allocated via the caller's allocator.

## Output JSON Format

Output is format-identical to the original Scala implementation:

```json
{
  "figures": [{
    "name": "1",
    "figType": "Figure",
    "page": 0,
    "caption": "Figure 1: Overview of the proposed method.",
    "captionBoundary": {"x1": 72.0, "y1": 393.0, "x2": 540.0, "y2": 415.7},
    "regionBoundary": {"x1": 72.0, "y1": 295.0, "x2": 540.0, "y2": 393.0},
    "imageText": ["text extracted from within the figure region"]
  }],
  "regionless-captions": [{
    "name": "1",
    "figType": "Figure",
    "page": 0,
    "text": "Figure 1: ...",
    "boundary": {"x1": 72.0, "y1": 393.0, "x2": 540.0, "y2": 415.7}
  }]
}
```

## Benchmarks

### Detection Quality

Evaluated on the conference dataset ([pdffigures2 evaluation](https://github.com/allenai/pdffigures2/tree/master/evaluation)): 28 PDFs, 135 annotated figures. Matching uses union-intersect IoU ≥ 0.8 for both caption and region bounding boxes.

| Metric | Zig (MuPDF) | Scala (PDFBox) |
|--------|:-----------:|:--------------:|
| Precision | **100.0%** | 100.0% |
| Recall | **94.9%** | 95.1% |
| F1 | **97.4%** | 97.5% |
| True Positives | 56 | 58 |
| False Positives | 0 | 0 |

The 2-TP gap between Zig and Scala has been confirmed as an engine-level difference (MuPDF vs. PDFBox paragraph grouping strategy), not a logic bug.

### Resource Usage

| | Zig | Scala | Improvement |
|--|:---:|:-----:|:-----------:|
| Total wall time (28 PDFs) | 4.9 s | 65.7 s | **13.4×** |
| Median memory (per PDF) | 12 MB | 244 MB | **20×** |
| Peak memory (single PDF) | 26 MB | 447 MB | **17×** |
| Binary size | 42 MB | 19 MB JAR + ~200 MB JVM | — |
| Startup time | <10 ms | 2–4 s | **~300×** |

Memory measured via `/usr/bin/time -v` (Maximum resident set size).

### Test Coverage

- 48 unit tests covering Box spatial algorithms, Paragraph/Word/Line construction, Figure serialization, `DocumentLayout` weighted medians, caption regex matching, region classifiers, and figure proposal generation and scoring.
- 3 end-to-end tests on real academic PDFs.

### Known Differences from Scala

The remaining discrepancies are attributable to engine-level differences between MuPDF and PDFBox:

- Some caption boundaries are slightly larger than Scala's (MuPDF paragraph grouping differs).
- Two missed detections (`icml12_2`, `icml12_5`) due to text line grouping strategy differences.
- MuPDF pages are 1-indexed; PDFBox pages are 0-indexed. The Zig output uses the MuPDF convention (page 0 = first page).

## Comparison with pymupdf4llm

[pymupdf4llm](https://github.com/pymupdf/PyMuPDF4LLM) uses ML-based layout analysis to classify page blocks (picture, table, caption, text, formula, etc.). While it offers broader document structure analysis, pdffigures2-zig provides specific advantages for academic figure extraction:

| | pdffigures2-zig | pymupdf4llm |
|--|:--:|:--:|
| Approach | Caption pattern matching + region proposals | ML layout classification |
| Caption-figure linking | Built-in | Not provided (blocks are independent) |
| Table structure | Bounding box only | Rows, columns, cells, markdown |
| Fragment artifacts | None | Frequent on vector graphics (39 fragments in 28 PDFs) |
| Uncaptioned graphics | Missed | Detected |
| Median memory | 12 MB | ~1 GB+ (ML model) |
| Cross-tool agreement | — | 82.1% of Zig figures matched by LLM blocks (IoU ≥ 0.5) |

The two tools are complementary: pdffigures2-zig is purpose-built for reliable figure/caption extraction with strict precision guarantees; pymupdf4llm is a general-purpose document layout analyzer.

## Tech Stack Comparison

| Aspect | Zig | Scala |
|--------|-----|-------|
| PDF engine | MuPDF (C API) | PDFBox 2.0.x |
| Text extraction | `fz_stext_page` blocks/lines/chars | `PDFTextStripper` subclass |
| Graphics extraction | `fz_device` callbacks | `PDFGraphicsStreamEngine` |
| JSON | `std.json.stringify` | spray-json |
| CLI parsing | Manual `std.process.Args` | scopt |
| Memory management | Arena + manual ref-counting | JVM GC |
| Embeddability | C ABI library / subprocess | Subprocess only |
| Batch processing | Multi-threaded (`std.Thread`) | `ForkJoinPool` |
| Visualization | Static annotated PNG | Swing GUI |

## Roadmap

- [x] Core extraction pipeline (~7,600 lines, 48 tests)
- [x] Single-file CLI
- [x] JSON output format-compatible with Scala
- [x] Batch processing CLI (multi-threaded)
- [x] Debug visualization CLI (annotated PNG)
- [x] C ABI shared library
- [x] Conference dataset evaluation (94.9% recall, 0 FP)
- [ ] PDF-to-Markdown conversion (pymupdf4llm port to Zig)
- [ ] Structured table extraction (cell-level)

## License

This project is licensed under the Apache License 2.0 — the same license as the original [allenai/pdffigures2](https://github.com/allenai/pdffigures2). No code from the original Scala implementation is included; this is an independent translation to Zig using a different PDF engine (MuPDF).

---

[中文文档](README_CN.md)