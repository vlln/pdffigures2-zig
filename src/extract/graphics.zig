// Graphics extraction orchestration: raw graphic detection + preprocessing.
// Direct translation of GraphicsExtractor.scala.
// Separates figure graphics from non-figure graphics (header lines, side panels).

const std = @import("std");
const c = @import("../mupdf.zig");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const page = @import("../page.zig");
const ClassifiedText = page.ClassifiedText;
const PageWithGraphics = page.PageWithGraphics;
const graphic = @import("graphic.zig");
const raster = @import("raster.zig");

/// Tolerance for merging nearby bounding boxes.
const GraphicClusteringTolerance: f64 = 2;

/// Minimum area for OCR connected components.
const OcrGraphicMinSize: u32 = 2;

/// How close a graphic must be to page bounds to trigger OCR fallback.
const OcrPageBoundsTolerance: f64 = 70;

/// Header line detection: minimum fraction of page width.
const HeaderLineMinWidthPercent: f64 = 0.70;

/// Header line detection: maximum height.
const HeaderLineMinHeight: f64 = 5;

/// Header line detection: minimum y1 (top of page).
const HeaderLineMinY1: f64 = 72;

/// Distance tolerance from header text to header line.
const HeaderLineMinDistToHeader: f64 = 18;

/// Distance between first and second header lines.
const SecondHeaderMinDistToFirst: f64 = 36;

/// Max width difference between two header lines.
const SecondHeaderMaxWidthDifference: f64 = 0.1;

/// Max area for a graphic to be considered "mixed in" with text.
const MixedInGraphicMaxSize: f64 = 70;

/// Tolerance for checking if a graphic is contained within text.
const MixedInGraphicContainsTolerance: f64 = 2;

/// Extract graphics from a page, separating figure graphics from non-figure graphics.
pub fn extractGraphics(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    mu_page: [*c]c.fz_page,
    page_number: u32,
    paragraphs_slice: []const Paragraph,
    allow_ocr: bool,
    ignore_white_graphics: bool,
) !PageWithGraphics {
    const page_bounds_rect = c.fz_bound_page(ctx, mu_page);
    const page_bounds = Box.init(
        @floatCast(page_bounds_rect.x0),
        @floatCast(page_bounds_rect.y0),
        @floatCast(page_bounds_rect.x1),
        @floatCast(page_bounds_rect.y1),
    );

    const raw_graphics = try extractRawGraphics(
        allocator,
        ctx,
        mu_page,
        paragraphs_slice,
        allow_ocr,
        ignore_white_graphics,
        page_bounds,
    );

    const fig_graphics, const non_fig_graphics = try preprocessGraphics(
        allocator,
        raw_graphics,
        paragraphs_slice,
        page_bounds,
    );

    return PageWithGraphics{
        .page_number = page_number,
        .paragraphs = paragraphs_slice,
        .graphics = fig_graphics,
        .non_figure_graphics = non_fig_graphics,
        .classified_text = ClassifiedText{},
    };
}

/// Detect raw graphics on a page, falling back to raster CC for OCR pages.
fn extractRawGraphics(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    mu_page: [*c]c.fz_page,
    text_paragraphs: []const Paragraph,
    allow_ocr: bool,
    ignore_white_graphics: bool,
    page_bounds: Box,
) ![]const Box {
    var graphics = try graphic.findGraphicBB(allocator, ctx, mu_page, ignore_white_graphics);

    // Check if it's an OCR'd page (scanned PDF): a single large graphic covers the page
    for (graphics) |g| {
        if (g.contains(page_bounds, OcrPageBoundsTolerance)) {
            if (!allow_ocr) {
                return error.OcredPdf;
            }
            // Fall back to connected-component analysis
            // Collect text bounding boxes to erase from raster
            var remove_regions = try std.ArrayList(Box).initCapacity(allocator, text_paragraphs.len);
            for (text_paragraphs) |p| {
                remove_regions.appendAssumeCapacity(p.boundary);
            }
            graphics = try raster.findCCBoundingBoxes(allocator, ctx, mu_page, remove_regions.items);
            break;
        }
    }

    return graphics;
}

/// Preprocess raw graphics: detect header lines, side panels, merge and filter.
fn preprocessGraphics(
    allocator: std.mem.Allocator,
    graphics: []const Box,
    text: []const Paragraph,
    page_bounds: Box,
) !struct { []const Box, []const Box } {
    const page_width = page_bounds.width();

    // Partition into wide lines and non-lines
    var wide_lines = std.ArrayList(Box).empty;
    var non_lines = std.ArrayList(Box).empty;

    // HeaderLineMinY1 in Scala is 72.0 in PDF coordinates.
    // MuPDF uses top-left origin, so y=0 is the top. HeaderLineMinY1=72 means
    // within 72 points from the top of the page (typical header area).
    // In our Box coordinates (top-left origin, y increases downward), y1 < 72 means top of page.

    for (graphics) |g| {
        const is_wide_line = g.width() > page_width * HeaderLineMinWidthPercent and
            g.height() < HeaderLineMinHeight;
        if (is_wide_line) {
            try wide_lines.append(allocator, g);
        } else {
            try non_lines.append(allocator, g);
        }
    }

    var header_lines = std.ArrayList(Box).empty;
    var remaining = std.ArrayList(Box).empty;

    if (non_lines.items.len == 0 and wide_lines.items.len > 0) {
        // Degenerate case: all graphics are wide lines
        try remaining.appendSlice(allocator, wide_lines.items);
    } else {
        // Find header lines: wide lines near header text at the top of the page
        const header_line = findClosestHeaderLine(wide_lines.items, text, page_bounds);
        if (header_line != null) {
            try header_lines.append(allocator, header_line.?);

            // Check for a second header line
            const second = findSecondHeaderLine(wide_lines.items, header_line.?, page_width);
            if (second != null) {
                try header_lines.append(allocator, second.?);
                // Add remaining wide lines (excluding the two header lines) to non_lines
                for (wide_lines.items) |g| {
                    if (!boxEquals(g, header_line.?) and !boxEquals(g, second.?)) {
                        try remaining.append(allocator, g);
                    }
                }
            } else {
                for (wide_lines.items) |g| {
                    if (!boxEquals(g, header_line.?)) {
                        try remaining.append(allocator, g);
                    }
                }
            }
        } else {
            // If only one wide line and it's above all text, treat as header
            if (wide_lines.items.len == 1) {
                // Find the minimum y1 of all text (i.e., the top of text)
                var min_text_y: f64 = std.math.floatMax(f64);
                for (text) |p| {
                    if (p.boundary.y1 < min_text_y) min_text_y = p.boundary.y1;
                }
                if (wide_lines.items[0].y1 < min_text_y) {
                    try header_lines.append(allocator, wide_lines.items[0]);
                } else {
                    try remaining.append(allocator, wide_lines.items[0]);
                }
            } else {
                try remaining.appendSlice(allocator, wide_lines.items);
            }
        }
        try remaining.appendSlice(allocator, non_lines.items);
    }

    // Detect side panels: graphics hugging the full page height on left/right edge
    var non_figure_graphics = std.ArrayList(Box).empty;
    try non_figure_graphics.appendSlice(allocator, header_lines.items);

    const page_height = page_bounds.height();
    var figure_graphics = std.ArrayList(Box).empty;

    for (remaining.items) |g| {
        // Side panel: spans at least 80% of page height, touches left or right edge
        const touches_left = g.x1 <= page_bounds.x1 + 2;
        const touches_right = g.x2 >= page_bounds.x2 - 2;
        const spans_height = g.height() > page_height * 0.8;

        if ((touches_left or touches_right) and spans_height and g.width() < page_width * 0.3) {
            try non_figure_graphics.append(allocator, g);
        } else {
            try figure_graphics.append(allocator, g);
        }
    }

    // Merge overlapping figure graphics
    var merged = try Box.mergeBoxes(allocator, figure_graphics.items, GraphicClusteringTolerance);
    defer merged.deinit(allocator);

    // Filter out small graphics that are contained within text (e.g., equation fragments)
    var final_graphics = std.ArrayList(Box).empty;
    for (merged.items) |g| {
        if (g.area() < MixedInGraphicMaxSize and isWithinText(g, text)) {
            // This is likely an equation element or underline, not a figure graphic
        } else {
            try final_graphics.append(allocator, g);
        }
    }

    return .{ final_graphics.items, non_figure_graphics.items };
}

/// Find the header line closest to header text at the top of the page.
fn findClosestHeaderLine(wide_lines: []const Box, text: []const Paragraph, _: Box) ?Box {
    if (wide_lines.len == 0) return null;

    // Find the header text: the first paragraph that is within the top 72 pts of the page
    var header_text: ?Box = null;
    for (text) |p| {
        if (p.boundary.y2 < HeaderLineMinY1) {
            header_text = p.boundary;
            break;
        }
    }

    if (header_text == null) return null;
    const ht = header_text.?;

    // Find the wide line closest to the header text within tolerance
    var best_line: ?Box = null;
    var best_dist: f64 = std.math.floatMax(f64);

    for (wide_lines) |line| {
        const dist_to_header = @abs(line.y1 - ht.y2);
        if (dist_to_header < HeaderLineMinDistToHeader and dist_to_header < best_dist) {
            best_dist = dist_to_header;
            best_line = line;
        }
    }

    return best_line;
}

/// Find a second header line below the first one.
fn findSecondHeaderLine(wide_lines: []const Box, first_line: Box, page_width: f64) ?Box {
    if (wide_lines.len < 2) return null;

    const first_width = first_line.width();

    for (wide_lines) |line| {
        if (boxEquals(line, first_line)) continue;
        // Must be below the first line, within distance tolerance, and similar width
        const dist = line.y1 - first_line.y2;
        if (dist > 0 and dist < SecondHeaderMinDistToFirst) {
            const width_diff = @abs(line.width() - first_width) / page_width;
            if (width_diff < SecondHeaderMaxWidthDifference) {
                return line;
            }
        }
    }

    return null;
}

/// Check if a small graphic is contained within a text paragraph.
fn isWithinText(g: Box, text: []const Paragraph) bool {
    for (text) |p| {
        if (p.boundary.contains(g, MixedInGraphicContainsTolerance)) {
            return true;
        }
    }
    return false;
}

/// Check if two boxes are approximately equal (needed for dedup).
fn boxEquals(a: Box, b: Box) bool {
    return @abs(a.x1 - b.x1) < 0.01 and
        @abs(a.y1 - b.y1) < 0.01 and
        @abs(a.x2 - b.x2) < 0.01 and
        @abs(a.y2 - b.y2) < 0.01;
}

test "boxEquals" {
    const a = Box.init(1, 2, 3, 4);
    const b = Box.init(1.1, 2.1, 3.1, 4.1);
    try std.testing.expect(!boxEquals(a, b));
    try std.testing.expect(boxEquals(a, a));
}

test "isWithinText true" {
    const g = Box.init(50, 50, 60, 60);
    const word = paragraph.Word{ .text = "test", .boundary = Box.init(40, 40, 70, 70), .font_name = null, .font_size = null };
    const line = paragraph.Line.init(&.{word}, 0);
    const p = paragraph.Paragraph.init(&.{line});
    try std.testing.expect(isWithinText(g, &.{p}));
}

test "isWithinText empty" {
    const g = Box.init(50, 50, 60, 60);
    try std.testing.expect(!isWithinText(g, &.{}));
}

test "isWithinText far" {
    const g = Box.init(50, 50, 60, 60);
    const word = paragraph.Word{ .text = "far", .boundary = Box.init(200, 200, 300, 300), .font_name = null, .font_size = null };
    const line = paragraph.Line.init(&.{word}, 0);
    const p = paragraph.Paragraph.init(&.{line});
    try std.testing.expect(!isWithinText(g, &.{p}));
}