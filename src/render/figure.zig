// Figure rendering: renders extracted figures as images in RGBA pixel buffers.
// Direct translation of FigureRenderer.scala.
// Uses MuPDF for page rendering and sub-region extraction.

const std = @import("std");
const c = @import("../mupdf.zig");
const Box = @import("../box.zig").Box;
const figure = @import("../figure.zig");
const Figure = figure.Figure;
const RasterizedFigure = figure.RasterizedFigure;
const page = @import("../page.zig");
const PageWithFigures = page.PageWithFigures;

/// Maximum pixels to expand rasterized figure when cleaning.
const MaxExpand: i32 = 20;

/// Min space to allow between expanded regions and non-figure content.
const PadNonFigureContent: i32 = 2;

/// Padding for unexpanded images.
const PadUnexpandedImage: i32 = 1;

/// Expand figure bounds to avoid clipping connected components, while staying away
/// from other content. Direct translation of expandFigureBounds in FigureRenderer.scala.
pub fn expandFigureBounds(
    x1: i32,
    y1: i32,
    x2: i32,
    y2: i32,
    other_content_scaled: []const Box,
    content_pad: i32,
    pixels: []u8,
    width: u32,
    height: u32,
) struct { x1: i32, y1: i32, x2: i32, y2: i32 } {
    const w: i32 = @intCast(width);
    const h: i32 = @intCast(height);

    var new_y1 = y1;
    var new_x1 = x1;
    var new_y2 = y2;
    var new_x2 = x2;

    // Check if pixel at (x, y) is not white (RGBA = [~255,~255,~255,~255])
    const isColored = struct {
        fn call(px: []u8, w32: u32, px_x: i32, px_y: i32) bool {
            const idx: usize = @intCast(@as(u32, @intCast(px_y)) * w32 * 4 + @as(u32, @intCast(px_x)) * 4);
            if (idx + 3 >= px.len) return false;
            return px[idx] < 250 or px[idx + 1] < 250 or px[idx + 2] < 250;
        }
    }.call;

    const intersectsAny = struct {
        fn call(box: Box, others: []const Box, pad: i32) bool {
            const padded = Box.init(
                box.x1 - @as(f64, @floatFromInt(pad)),
                box.y1 - @as(f64, @floatFromInt(pad)),
                box.x2 + @as(f64, @floatFromInt(pad)),
                box.y2 + @as(f64, @floatFromInt(pad)),
            );
            return padded.intersectsAny(others, 0);
        }
    }.call;

    // Expand up
    while (new_y1 > 0 and y1 - new_y1 < MaxExpand and
        !intersectsAny(Box.init(
            @floatFromInt(new_x1),
            @floatFromInt(new_y1 - 1),
            @floatFromInt(new_x2),
            @floatFromInt(new_y1),
    ), other_content_scaled, content_pad))
    {
        // Check if there's a colored pixel at row new_y1-1 adjacent to a colored pixel at new_y1
        var has_edge = false;
        var x: i32 = new_x1;
        while (x <= new_x2) : (x += 1) {
            if (isColored(pixels, width, x, new_y1 - 1) and
                isColored(pixels, width, x, new_y1))
            {
                has_edge = true;
                break;
            }
        }
        if (!has_edge) break;
        new_y1 -= 1;
    }

    // Expand down
    while (new_y2 < h - 1 and new_y2 - y2 < MaxExpand and
        !intersectsAny(Box.init(
            @floatFromInt(new_x1),
            @floatFromInt(new_y2),
            @floatFromInt(new_x2),
            @floatFromInt(new_y2 + 1),
    ), other_content_scaled, content_pad))
    {
        var has_edge = false;
        var x: i32 = new_x1;
        while (x <= new_x2) : (x += 1) {
            if (isColored(pixels, width, x, new_y2 + 1) and
                isColored(pixels, width, x, new_y2))
            {
                has_edge = true;
                break;
            }
        }
        if (!has_edge) break;
        new_y2 += 1;
    }

    // Expand left
    while (new_x1 > 0 and x1 - new_x1 < MaxExpand and
        !intersectsAny(Box.init(
            @floatFromInt(new_x1 - 1),
            @floatFromInt(new_y1),
            @floatFromInt(new_x1),
            @floatFromInt(new_y2),
    ), other_content_scaled, content_pad))
    {
        var has_edge = false;
        var y: i32 = new_y1;
        while (y <= new_y2) : (y += 1) {
            if (isColored(pixels, width, new_x1, y) and
                isColored(pixels, width, new_x1 - 1, y))
            {
                has_edge = true;
                break;
            }
        }
        if (!has_edge) break;
        new_x1 -= 1;
    }

    // Expand right
    while (new_x2 < w - 1 and new_x2 - x2 < MaxExpand and
        !intersectsAny(Box.init(
            @floatFromInt(new_x2),
            @floatFromInt(new_y1),
            @floatFromInt(new_x2 + 1),
            @floatFromInt(new_y2),
    ), other_content_scaled, content_pad))
    {
        var has_edge = false;
        var y: i32 = new_y1;
        while (y <= new_y2) : (y += 1) {
            if (isColored(pixels, width, new_x2, y) and
                isColored(pixels, width, new_x2 + 1, y))
            {
                has_edge = true;
                break;
            }
        }
        if (!has_edge) break;
        new_x2 += 1;
    }

    return .{ .x1 = new_x1, .y1 = new_y1, .x2 = new_x2, .y2 = new_y2 };
}

/// Render figures from a page to rasterized images.
pub fn renderFigures(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    mu_page: [*c]c.fz_page,
    page_with_figures: PageWithFigures,
    dpi: u32,
    clean: bool,
) ![]RasterizedFigure {
    if (page_with_figures.figures.len == 0) return &.{};

    const scale = @as(f64, @floatFromInt(dpi)) / 72.0;

    // Build non-figure content (scaled to DPI)
    var nfc_boxes = std.ArrayList(Box).empty;

    // Classified text paragraphs
    for (page_with_figures.classified_text.page_headers) |ph| {
        try nfc_boxes.append(allocator, ph.boundary.scale(scale));
    }
    for (page_with_figures.classified_text.formatting_text) |ft| {
        try nfc_boxes.append(allocator, ft.boundary.scale(scale));
    }
    for (page_with_figures.classified_text.abstract_text) |at| {
        try nfc_boxes.append(allocator, at.boundary.scale(scale));
    }
    for (page_with_figures.classified_text.section_titles) |st| {
        try nfc_boxes.append(allocator, st.boundary.scale(scale));
    }
    // Page paragraphs
    for (page_with_figures.paragraphs) |p| {
        try nfc_boxes.append(allocator, p.boundary.scale(scale));
    }
    // Failed captions
    for (page_with_figures.failed_captions) |fc| {
        try nfc_boxes.append(allocator, fc.boundary.scale(scale));
    }
    // Figure caption boundaries
    for (page_with_figures.figures) |f| {
        try nfc_boxes.append(allocator, f.caption_boundary.scale(scale));
    }

    const non_figure_content = nfc_boxes.items;

    // Figure regions scaled
    var figure_regions = std.ArrayList(Box).empty;
    for (page_with_figures.figures) |f| {
        try figure_regions.append(allocator, f.region_boundary.scale(scale));
    }

    // Render page to pixmap at given DPI
    const ctm = c.fz_scale(@floatCast(scale), @floatCast(scale));
    const pixmap = c.fz_new_pixmap_from_page(ctx, mu_page, ctm, c.fz_device_rgb(ctx), 1);
    if (pixmap == null) return error.RenderError;
    defer c.fz_drop_pixmap(ctx, pixmap);

    const page_w: u32 = @intCast(c.fz_pixmap_width(ctx, pixmap));
    const page_h: u32 = @intCast(c.fz_pixmap_height(ctx, pixmap));
    const page_stride: usize = @intCast(c.fz_pixmap_stride(ctx, pixmap));
    const page_samples: [*]u8 = c.fz_pixmap_samples(ctx, pixmap);

    // Copy samples to managed memory
    const pixel_count = page_stride * @as(usize, page_h);
    var full_pixels = try allocator.alloc(u8, pixel_count);
    defer allocator.free(full_pixels);
    @memcpy(full_pixels, page_samples[0..pixel_count]);

    var result = std.ArrayList(RasterizedFigure).empty;

    for (page_with_figures.figures, 0..) |fig, fig_idx| {
        // Other figure regions (for collision avoidance)
        var other_figure_regions = std.ArrayList(Box).empty;
        for (figure_regions.items, 0..) |fr, j| {
            if (j != fig_idx) {
                try other_figure_regions.append(allocator, fr);
            }
        }

        const r = fig.region_boundary;
        const px_x1: i32 = @intFromFloat(@max(0, @floor(scale * r.x1)));
        const px_y1: i32 = @intFromFloat(@max(0, @floor(scale * r.y1)));
        const px_x2: i32 = @intFromFloat(@min(@as(f64, @floatFromInt(page_w - 1)), @ceil(scale * r.x2)));
        const px_y2: i32 = @intFromFloat(@min(@as(f64, @floatFromInt(page_h - 1)), @ceil(scale * r.y2)));

        var other_content = std.ArrayList(Box).empty;
        try other_content.appendSlice(allocator, non_figure_content);
        try other_content.appendSlice(allocator, other_figure_regions.items);
        var expanded = expandFigureBounds(
            px_x1, px_y1, px_x2, px_y2,
            other_content.items,
            if (clean) PadNonFigureContent else PadUnexpandedImage,
            full_pixels,
            page_w,
            page_h,
        );
        if (!clean) {
            expanded.x1 = @max(px_x1 - PadUnexpandedImage, 0);
            expanded.y1 = @max(px_y1 - PadUnexpandedImage, 0);
            expanded.x2 = @min(px_x2 + PadUnexpandedImage * 2, @as(i32, @intCast(page_w)) - 1);
            expanded.y2 = @min(px_y2 + PadUnexpandedImage * 2, @as(i32, @intCast(page_h)) - 1);
        }

        const sub_w: u32 = @intCast(expanded.x2 - expanded.x1 + 1);
        const sub_h: u32 = @intCast(expanded.y2 - expanded.y1 + 1);
        const sub_pixel_count = @as(usize, sub_w) * @as(usize, sub_h) * 4;
        var sub_pixels = try allocator.alloc(u8, sub_pixel_count);

        // Extract sub-region
        var sy: u32 = 0;
        while (sy < sub_h) : (sy += 1) {
            const src_y: u32 = @intCast(expanded.y1);
            const src_row: usize = @as(usize, src_y + sy) * page_stride;
            const dst_row: usize = sy * @as(usize, sub_w) * 4;
            const src_start: usize = src_row + @as(usize, @intCast(expanded.x1)) * 4;
            @memcpy(
                sub_pixels[dst_row .. dst_row + @as(usize, sub_w) * 4],
                full_pixels[src_start .. src_start + @as(usize, sub_w) * 4],
            );
        }

        try result.append(allocator, RasterizedFigure.init(
            fig,
            Box.init(
                @floatFromInt(expanded.x1),
                @floatFromInt(expanded.y1),
                @floatFromInt(expanded.x2),
                @floatFromInt(expanded.y2),
            ),
            sub_pixels,
            sub_w,
            sub_h,
            dpi,
        ));
    }

    return result.items;
}

test "expandFigureBounds no expand on empty image" {
    const w: u32 = 100;
    const h: u32 = 100;
    const pixels = try std.testing.allocator.alloc(u8, w * h * 4);
    defer std.testing.allocator.free(pixels);
    @memset(pixels, 255); // All white

    const result = expandFigureBounds(10, 10, 50, 50, &.{}, PadNonFigureContent, pixels, w, h);
    // Should not expand since all pixels are white
    try std.testing.expectEqual(@as(i32, 10), result.x1);
    try std.testing.expectEqual(@as(i32, 10), result.y1);
    try std.testing.expectEqual(@as(i32, 50), result.x2);
    try std.testing.expectEqual(@as(i32, 50), result.y2);
}