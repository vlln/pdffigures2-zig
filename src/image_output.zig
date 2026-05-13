// Image output utilities: save pixmaps to PNG, draw overlays on pixmaps.
// Thin wrappers over MuPDF's built-in image I/O functions.

const std = @import("std");
const c = @import("mupdf.zig");
const Box = @import("box.zig").Box;

/// RGBA color for drawing overlays.
pub const Rgba = struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8 = 255,
};

/// Predefined colors matching Scala VisualLogger conventions.
pub const Colors = struct {
    pub const figure_region = Rgba{ .r = 255, .g = 0, .b = 0 }; // Red
    pub const caption = Rgba{ .r = 0, .g = 0, .b = 255 }; // Blue
    pub const body_text = Rgba{ .r = 0, .g = 200, .b = 0 }; // Green
    pub const other_text = Rgba{ .r = 255, .g = 255, .b = 0 }; // Yellow
    pub const graphics = Rgba{ .r = 255, .g = 165, .b = 0 }; // Orange
};

/// Save a pixmap as a PNG file.
pub fn savePixmapAsPng(ctx: *c.fz_context, pixmap: *c.fz_pixmap, path: []const u8) !void {
    const path_c = try std.heap.c_allocator.dupeZ(u8, path);
    defer std.heap.c_allocator.free(path_c);
    c.fz_save_pixmap_as_png(ctx, pixmap, path_c.ptr);
}

/// Encode a pixmap as PNG to an in-memory buffer.
/// Returns the encoded data (owned by caller's allocator).
pub fn pixmapToPngBuffer(ctx: *c.fz_context, pixmap: *c.fz_pixmap, allocator: std.mem.Allocator) ![]u8 {
    const buf = c.fz_new_buffer_from_pixmap_as_png(ctx, pixmap, .{ .ri = 0, .bp = 0, .op = 0, .opm = 0 });
    if (buf == null) return error.PngEncodeError;
    defer c.fz_drop_buffer(ctx, buf);

    const len: usize = @intCast(buf.*.len);
    const data = buf.*.data;
    const result = try allocator.alloc(u8, len);
    @memcpy(result, data[0..len]);
    return result;
}

/// Draw a single-pixel horizontal line on a pixmap.
fn drawHLine(
    samples: [*]u8,
    stride: usize,
    x1: i32,
    x2: i32,
    y: i32,
    width: i32,
    height: i32,
    color: Rgba,
) void {
    if (y < 0 or y >= height) return;
    const sx = @max(0, x1);
    const ex = @min(x2, width);
    var x = sx;
    while (x < ex) : (x += 1) {
        const idx = @as(usize, @intCast(y)) * stride + @as(usize, @intCast(x)) * 4;
        samples[idx] = color.r;
        samples[idx + 1] = color.g;
        samples[idx + 2] = color.b;
        samples[idx + 3] = color.a;
    }
}

/// Draw a single-pixel vertical line on a pixmap.
fn drawVLine(
    samples: [*]u8,
    stride: usize,
    x: i32,
    y1: i32,
    y2: i32,
    width: i32,
    height: i32,
    color: Rgba,
) void {
    if (x < 0 or x >= width) return;
    const sy = @max(0, y1);
    const ey = @min(y2, height);
    var y = sy;
    while (y < ey) : (y += 1) {
        const idx = @as(usize, @intCast(y)) * stride + @as(usize, @intCast(x)) * 4;
        samples[idx] = color.r;
        samples[idx + 1] = color.g;
        samples[idx + 2] = color.b;
        samples[idx + 3] = color.a;
    }
}

/// Draw a colored rectangle border on a pixmap with given thickness.
/// The box coordinates are in pixmap pixel space (already scaled to DPI).
pub fn drawRect(ctx: *c.fz_context, pixmap: *c.fz_pixmap, box: Box, color: Rgba, thickness: u32) void {
    const w: i32 = c.fz_pixmap_width(ctx, pixmap);
    const h: i32 = c.fz_pixmap_height(ctx, pixmap);
    const stride: usize = @intCast(c.fz_pixmap_stride(ctx, pixmap));
    const samples = c.fz_pixmap_samples(ctx, pixmap);

    const x1: i32 = @as(i32, @intFromFloat(@round(box.x1)));
    const y1: i32 = @as(i32, @intFromFloat(@round(box.y1)));
    const x2: i32 = @as(i32, @intFromFloat(@round(box.x2)));
    const y2: i32 = @as(i32, @intFromFloat(@round(box.y2)));
    const t: i32 = @intCast(thickness);

    // Top and bottom edges
    var offset: i32 = 0;
    while (offset < t) : (offset += 1) {
        drawHLine(samples, stride, x1, x2, y1 + offset, w, h, color);
        drawHLine(samples, stride, x1, x2, y2 - 1 - offset, w, h, color);
    }

    // Left and right edges
    offset = 0;
    while (offset < t) : (offset += 1) {
        drawVLine(samples, stride, x1 + offset, y1, y2, w, h, color);
        drawVLine(samples, stride, x2 - 1 - offset, y1, y2, w, h, color);
    }
}

/// Draw a filled rectangle on a pixmap (semi-transparent overlay).
pub fn drawFilledRect(ctx: *c.fz_context, pixmap: *c.fz_pixmap, box: Box, color: Rgba) void {
    const w: i32 = c.fz_pixmap_width(ctx, pixmap);
    const h: i32 = c.fz_pixmap_height(ctx, pixmap);
    const stride: usize = @intCast(c.fz_pixmap_stride(ctx, pixmap));
    const samples = c.fz_pixmap_samples(ctx, pixmap);

    const x1: i32 = @max(0, @as(i32, @intFromFloat(@round(box.x1))));
    const y1: i32 = @max(0, @as(i32, @intFromFloat(@round(box.y1))));
    const x2: i32 = @min(w, @as(i32, @intFromFloat(@round(box.x2))));
    const y2: i32 = @min(h, @as(i32, @intFromFloat(@round(box.y2))));

    var y: i32 = y1;
    while (y < y2) : (y += 1) {
        const row_start = @as(usize, @intCast(y)) * stride;
        var x: i32 = x1;
        while (x < x2) : (x += 1) {
            const idx = row_start + @as(usize, @intCast(x)) * 4;
            // Alpha blending: mix 50% of the overlay color
            samples[idx] = @intCast((@as(u32, samples[idx]) + @as(u32, color.r)) / 2);
            samples[idx + 1] = @intCast((@as(u32, samples[idx + 1]) + @as(u32, color.g)) / 2);
            samples[idx + 2] = @intCast((@as(u32, samples[idx + 2]) + @as(u32, color.b)) / 2);
        }
    }
}

test "Rgba default alpha" {
    const c2 = Rgba{ .r = 100, .g = 150, .b = 200 };
    try std.testing.expectEqual(@as(u8, 255), c2.a);
}

test "savePixmapAsPng" {
    const ctx = c.fz_new_context(null, null, 256 << 20) orelse return error.MupdfError;
    defer c.fz_drop_context(ctx);

    // Create a small test pixmap
    const pix = c.fz_new_pixmap_with_bbox(ctx, c.fz_device_rgb(ctx), .{ .x0 = 0, .y0 = 0, .x1 = 10, .y1 = 10 }, null, 0);
    if (pix == null) return error.PixmapError;
    defer c.fz_drop_pixmap(ctx, pix);

    c.fz_clear_pixmap_with_value(ctx, pix, 0xff);

    const path = "/tmp/test_image_output.png";
    try savePixmapAsPng(ctx, pix, path);

    // Verify file was created
    const file = try std.fs.cwd().openFile(path, .{});
    const stat = try file.stat();
    try std.testing.expect(stat.size > 0);
    file.close();
    try std.fs.cwd().deleteFile(path);
}

test "pixmapToPngBuffer" {
    const ctx = c.fz_new_context(null, null, 256 << 20) orelse return error.MupdfError;
    defer c.fz_drop_context(ctx);

    const pix = c.fz_new_pixmap_with_bbox(ctx, c.fz_device_rgb(ctx), .{ .x0 = 0, .y0 = 0, .x1 = 5, .y1 = 5 }, null, 0);
    if (pix == null) return error.PixmapError;
    defer c.fz_drop_pixmap(ctx, pix);

    c.fz_clear_pixmap_with_value(ctx, pix, 0xff);

    const buf = try pixmapToPngBuffer(ctx, pix, std.testing.allocator);
    defer std.testing.allocator.free(buf);
    try std.testing.expect(buf.len > 0);

    // Check PNG signature
    try std.testing.expectEqual(@as(u8, 0x89), buf[0]);
    try std.testing.expectEqual(@as(u8, 'P'), buf[1]);
    try std.testing.expectEqual(@as(u8, 'N'), buf[2]);
    try std.testing.expectEqual(@as(u8, 'G'), buf[3]);
}

test "drawRect on pixmap" {
    const ctx = c.fz_new_context(null, null, 256 << 20) orelse return error.MupdfError;
    defer c.fz_drop_context(ctx);

    const pix = c.fz_new_pixmap_with_bbox(ctx, c.fz_device_rgb(ctx), .{ .x0 = 0, .y0 = 0, .x1 = 20, .y1 = 20 }, null, 1);
    if (pix == null) return error.PixmapError;
    defer c.fz_drop_pixmap(ctx, pix);

    c.fz_clear_pixmap_with_value(ctx, pix, 0xff);

    const b = Box.init(2, 2, 18, 18);
    drawRect(ctx, pix, b, Colors.figure_region, 2);

    // Verify corners are red
    const samples = c.fz_pixmap_samples(ctx, pix);
    const idx: usize = 2 * @as(usize, @intCast(c.fz_pixmap_stride(ctx, pix))) + 2 * 4;
    try std.testing.expectEqual(@as(u8, 255), samples[idx]);
    try std.testing.expectEqual(@as(u8, 0), samples[idx + 1]);
    try std.testing.expectEqual(@as(u8, 0), samples[idx + 2]);
}