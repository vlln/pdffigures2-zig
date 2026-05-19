// FigureExtractor: main pipeline orchestrator and public API.
// Direct translation of FigureExtractor.scala.
//
// Coordinates the full pipeline:
//   text extraction → formatting → layout → caption detection →
//   graphics extraction → caption building → region classification → figure detection.

const std = @import("std");
const c = @import("mupdf.zig");
const Box = @import("box.zig").Box;
const paragraph = @import("paragraph.zig");
const Paragraph = paragraph.Paragraph;
const figure = @import("figure.zig");
const Figure = figure.Figure;
const Caption = figure.Caption;
const FigureType = figure.FigureType;
const FiguresInDocument = figure.FiguresInDocument;
const RasterizedFigure = figure.RasterizedFigure;
const RasterizedFiguresInDocument = figure.RasterizedFiguresInDocument;
const page = @import("page.zig");
const ClassifiedText = page.ClassifiedText;
const PageWithText = page.PageWithText;
const PageWithClassifiedText = page.PageWithClassifiedText;
const PageWithFigures = page.PageWithFigures;
const PageWithCaptions = page.PageWithCaptions;
const PageWithBodyText = page.PageWithBodyText;
const layout = @import("layout.zig");
const DocumentLayout = layout.DocumentLayout;
const extract_text = @import("extract/text.zig");
const formatting = @import("extract/formatting.zig");
const paragraph_rebuild = @import("extract/paragraph_rebuild.zig");
const caption_detector = @import("detect/caption.zig");
const caption_builder = @import("detect/caption_builder.zig");
const graphics_extract = @import("extract/graphics.zig");
const classify_region = @import("classify/region.zig");
const detect_figure = @import("detect/figure.zig");
const render_figure = @import("render/figure.zig");
const json = @import("json.zig");

/// Configuration for the figure extraction pipeline.
pub const ExtractorConfig = struct {
    allow_ocr: bool = false,
    ignore_white_graphics: bool = false,
    detect_section_titles_first: bool = false,
    rebuild_paragraphs: bool = true,
    clean_rasterized_figure_regions: bool = true,
    dpi: u32 = 300,
};

/// Internal document content produced by parseDocument.
const DocumentContent = struct {
    layout: ?DocumentLayout,
    pages_with_figures: []const PageWithFigures,
    pages_without_figures: []const PageWithClassifiedText,

    fn figures(self: DocumentContent, allocator: std.mem.Allocator) ![]const Figure {
        var all: std.ArrayList(Figure) = .empty;
        for (self.pages_with_figures) |pf| {
            try all.appendSlice(allocator, pf.figures);
        }
        return all.toOwnedSlice(allocator);
    }

    fn failedCaptions(self: DocumentContent, allocator: std.mem.Allocator) ![]const Caption {
        var all: std.ArrayList(Caption) = .empty;
        for (self.pages_with_figures) |pf| {
            try all.appendSlice(allocator, pf.failed_captions);
        }
        return all.toOwnedSlice(allocator);
    }
};

/// Run the full extraction pipeline on a PDF file.
fn parseDocument(
    arena: std.mem.Allocator,
    ctx: *c.fz_context,
    doc: *c.fz_document,
    config: ExtractorConfig,
) !DocumentContent {
    // Step 1: Extract text from all pages
    const pages_with_text = try extract_text.extractText(arena, ctx, doc);

    // Step 2: Classify formatting text
    const pages_with_formatting = try formatting.extractFormattingText(arena, pages_with_text);

    // Step 3: Build document layout
    const doc_layout = layout.buildLayout(arena, pages_with_formatting);
    if (doc_layout == null) {
        return DocumentContent{
            .layout = null,
            .pages_with_figures = &.{},
            .pages_without_figures = pages_with_formatting,
        };
    }
    const dl = doc_layout.?;

    // Step 4: Optionally rebuild paragraphs
    const rebuilt_pages = if (config.rebuild_paragraphs) blk: {
        var rebuilt = try std.ArrayList(PageWithClassifiedText).initCapacity(arena, pages_with_formatting.len);
        for (pages_with_formatting) |p| {
            rebuilt.appendAssumeCapacity(try paragraph_rebuild.rebuildParagraphs(arena, p, dl));
        }
        break :blk rebuilt.items;
    } else pages_with_formatting;

    // Step 5: Optionally strip section titles (experimental — skipped in this impl)
    const with_sections = rebuilt_pages;

    // Step 6: Detect caption candidates
    // Build anonymous struct type expected by findCaptionCandidates
    const PageInfo = struct { page_number: u32, paragraphs: []const Paragraph };
    var page_infos = try std.ArrayList(PageInfo).initCapacity(arena, with_sections.len);
    for (with_sections) |p| {
        page_infos.appendAssumeCapacity(.{ .page_number = p.page_number, .paragraphs = p.paragraphs });
    }

    const caption_starts = try caption_detector.findCaptionCandidates(arena, page_infos.items);
    const selected_captions = try caption_detector.selectCaptionCandidates(
        arena,
        caption_starts.items,
        caption_detector.defaultFilters(),
    );

    // Group selected captions by page
    var captions_by_page = std.AutoHashMap(u32, std.ArrayList(caption_detector.CaptionStart)).init(arena);
    for (selected_captions.items) |cap| {
        const entry = try captions_by_page.getOrPutValue(cap.page, std.ArrayList(caption_detector.CaptionStart).empty);
        try entry.value_ptr.append(arena, cap);
    }

    var pages_with_figures = std.ArrayList(PageWithFigures).empty;
    var other_pages = std.ArrayList(PageWithClassifiedText).empty;

    // Step 7-11: Process each page that has captions
    for (with_sections) |page_text| {
        const page_num = page_text.page_number;

        const page_candidates = captions_by_page.get(page_num);
        if (page_candidates == null or page_candidates.?.items.len == 0) {
            try other_pages.append(arena, page_text);
            continue;
        }

        // Load MuPDF page for graphics extraction
        const mu_page = c.fz_load_page(ctx, doc, @intCast(page_num));
        if (mu_page == null) return error.PageLoadError;
        defer c.fz_drop_page(ctx, mu_page);

        // Extract graphics
        const page_with_graphics = try graphics_extract.extractGraphics(
            arena,
            ctx,
            mu_page,
            page_num,
            page_text.paragraphs,
            config.allow_ocr,
            config.ignore_white_graphics,
        );

        // Build captions
        const page_with_captions = try caption_builder.buildCaptions(
            arena,
            page_candidates.?.items,
            page_with_graphics,
            dl.median_line_spacing,
        );

        // Classify regions
        const page_with_regions = try classify_region.classifyRegions(
            arena,
            page_with_captions,
            dl,
        );

        // Detect figures
        const page_with_figures = try detect_figure.detectFigures(
            arena,
            page_with_regions,
            dl,
        );

        try pages_with_figures.append(arena, page_with_figures);
    }

    // Add pages without captions as "pages without figures"
    for (with_sections) |page_text| {
        const page_num = page_text.page_number;
        var has_figures = false;
        for (pages_with_figures.items) |pf| {
            if (pf.page_number == page_num) {
                has_figures = true;
                break;
            }
        }
        if (!has_figures) {
            // Check we haven't already added it
            var already_added = false;
            for (other_pages.items) |op| {
                if (op.page_number == page_num) {
                    already_added = true;
                    break;
                }
            }
            if (!already_added) {
                try other_pages.append(arena, page_text);
            }
        }
    }

    return DocumentContent{
        .layout = dl,
        .pages_with_figures = pages_with_figures.items,
        .pages_without_figures = other_pages.items,
    };
}

/// Extract figures from a PDF file.
pub fn getFigures(
    arena: std.mem.Allocator,
    ctx: *c.fz_context,
    doc: *c.fz_document,
    config: ExtractorConfig,
) !FiguresInDocument {
    const content = try parseDocument(arena, ctx, doc, config);
    return FiguresInDocument{
        .figures = try content.figures(arena),
        .failed_captions = try content.failedCaptions(arena),
    };
}

/// Extract figures with rendered images from a PDF file.
pub fn getRasterizedFigures(
    arena: std.mem.Allocator,
    ctx: *c.fz_context,
    doc: *c.fz_document,
    config: ExtractorConfig,
) !RasterizedFiguresInDocument {
    const content = try parseDocument(arena, ctx, doc, config);

    var all_rast = std.ArrayList(RasterizedFigure).empty;
    for (content.pages_with_figures) |pf| {
        if (pf.figures.len == 0) continue;
        const mu_page = c.fz_load_page(ctx, doc, @intCast(pf.page_number));
        if (mu_page == null) return error.PageLoadError;
        defer c.fz_drop_page(ctx, mu_page);

        const rendered = try render_figure.renderFigures(
            arena,
            ctx,
            mu_page,
            pf,
            config.dpi,
            config.clean_rasterized_figure_regions,
        );
        try all_rast.appendSlice(arena, rendered);
    }

    return RasterizedFiguresInDocument{
        .figures = all_rast.items,
        .failed_captions = try content.failedCaptions(arena),
    };
}

/// Extract figures and output JSON string.
pub fn getFiguresJson(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    doc: *c.fz_document,
    config: ExtractorConfig,
) ![]const u8 {
    var sub_arena = std.heap.ArenaAllocator.init(allocator);
    defer sub_arena.deinit();
    const sub = sub_arena.allocator();
    const content = try parseDocument(sub, ctx, doc, config);
    const figs = try content.figures(sub);
    const caps = try content.failedCaptions(sub);
    return try json.figuresDocumentToJson(allocator, figs, caps);
}

/// Per-page debug data for visualization overlays.
pub const DebugPageData = struct {
    page_number: u32,
    body_text: []const Paragraph,
    other_text: []const Paragraph,
    graphics: []const Box,
    non_figure_graphics: []const Box,
    captions: []const figure.CaptionParagraph,
    figures: []const Figure,
};

/// Run extraction and return debug data for visualization alongside figures.
pub fn getFiguresWithDebugData(
    arena: std.mem.Allocator,
    ctx: *c.fz_context,
    doc: *c.fz_document,
    config: ExtractorConfig,
) !struct { figures: []const Figure, debug_pages: []const DebugPageData } {
    // Step 1: Extract text from all pages
    const pages_with_text = try extract_text.extractText(arena, ctx, doc);

    // Step 2: Classify formatting text
    const pages_with_formatting = try formatting.extractFormattingText(arena, pages_with_text);

    // Step 3: Build document layout
    const doc_layout = layout.buildLayout(arena, pages_with_formatting);
    if (doc_layout == null) {
        return .{ .figures = &.{}, .debug_pages = &.{} };
    }
    const dl = doc_layout.?;

    // Step 4: Optionally rebuild paragraphs
    const rebuilt_pages = if (config.rebuild_paragraphs) blk: {
        var rebuilt = try std.ArrayList(PageWithClassifiedText).initCapacity(arena, pages_with_formatting.len);
        for (pages_with_formatting) |p| {
            rebuilt.appendAssumeCapacity(try paragraph_rebuild.rebuildParagraphs(arena, p, dl));
        }
        break :blk rebuilt.items;
    } else pages_with_formatting;

    // Step 5: Detect caption candidates
    const PageInfo = struct { page_number: u32, paragraphs: []const Paragraph };
    var page_infos = try std.ArrayList(PageInfo).initCapacity(arena, rebuilt_pages.len);
    for (rebuilt_pages) |p| {
        page_infos.appendAssumeCapacity(.{ .page_number = p.page_number, .paragraphs = p.paragraphs });
    }

    const caption_starts = try caption_detector.findCaptionCandidates(arena, page_infos.items);
    const selected_captions = try caption_detector.selectCaptionCandidates(
        arena,
        caption_starts.items,
        caption_detector.defaultFilters(),
    );

    // Group selected captions by page
    var captions_by_page = std.AutoHashMap(u32, std.ArrayList(caption_detector.CaptionStart)).init(arena);
    for (selected_captions.items) |cap| {
        const entry = try captions_by_page.getOrPutValue(cap.page, std.ArrayList(caption_detector.CaptionStart).empty);
        try entry.value_ptr.append(arena, cap);
    }

    var all_figures = std.ArrayList(Figure).empty;
    var debug_pages = std.ArrayList(DebugPageData).empty;

    for (rebuilt_pages) |page_text| {
        const page_num = page_text.page_number;
        const page_candidates = captions_by_page.get(page_num);

        if (page_candidates == null or page_candidates.?.items.len == 0) {
            try debug_pages.append(arena, .{
                .page_number = page_num,
                .body_text = &.{},
                .other_text = &.{},
                .graphics = &.{},
                .non_figure_graphics = &.{},
                .captions = &.{},
                .figures = &.{},
            });
            continue;
        }

        const mu_page = c.fz_load_page(ctx, doc, @intCast(page_num));
        if (mu_page == null) return error.PageLoadError;
        defer c.fz_drop_page(ctx, mu_page);

        const page_with_graphics = try graphics_extract.extractGraphics(
            arena, ctx, mu_page, page_num, page_text.paragraphs,
            config.allow_ocr, config.ignore_white_graphics,
        );

        const page_with_captions = try caption_builder.buildCaptions(
            arena, page_candidates.?.items, page_with_graphics, dl.median_line_spacing,
        );

        const page_with_regions = try classify_region.classifyRegions(
            arena, page_with_captions, dl,
        );

        const page_with_figures = try detect_figure.detectFigures(
            arena, page_with_regions, dl,
        );

        try all_figures.appendSlice(arena, page_with_figures.figures);

        try debug_pages.append(arena, .{
            .page_number = page_num,
            .body_text = page_with_regions.body_text,
            .other_text = page_with_regions.other_text,
            .graphics = page_with_regions.graphics,
            .non_figure_graphics = page_with_regions.non_figure_graphics,
            .captions = page_with_regions.captions,
            .figures = page_with_figures.figures,
        });
    }

    return .{ .figures = all_figures.items, .debug_pages = debug_pages.items };
}

test "ExtractorConfig defaults" {
    const config = ExtractorConfig{};
    try std.testing.expectEqual(@as(u32, 300), config.dpi);
    try std.testing.expect(!config.ignore_white_graphics);
    try std.testing.expect(!config.allow_ocr);
}