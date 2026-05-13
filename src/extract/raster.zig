// Connected-components graphics detection for OCR'd/scanned PDF pages.
// Direct translation of FindGraphicsRaster.scala.
// Renders a page to grayscale at 72 DPI, erases text regions, then
// finds connected components of dark pixels as graphics bounding boxes.

const std = @import("std");
const c = @import("../mupdf.zig");
const Box = @import("../box.zig").Box;

/// Grayscale threshold: pixels lighter than this are background.
const Threshold: u8 = 240;

/// Minimum area (in pixel^2) for a connected component to be kept.
const OcrGraphicMinSize: u32 = 2;

/// Render a page to grayscale and find connected components of dark pixels.
/// Text regions are erased before analysis to prevent text from being detected as graphics.
pub fn findCCBoundingBoxes(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    page: [*c]c.fz_page,
    remove: []const Box,
) ![]const Box {
    // Render page to grayscale pixmap at 72 DPI
    const identity = c.fz_identity;
    const pixmap = c.fz_new_pixmap_from_page(ctx, page, identity, c.fz_device_gray(ctx), 0);
    if (pixmap == null) return error.RenderError;
    defer c.fz_drop_pixmap(ctx, pixmap);

    const w: u32 = @intCast(c.fz_pixmap_width(ctx, pixmap));
    const h: u32 = @intCast(c.fz_pixmap_height(ctx, pixmap));
    const stride: usize = @intCast(c.fz_pixmap_stride(ctx, pixmap));
    const samples: [*]u8 = c.fz_pixmap_samples(ctx, pixmap);

    // Copy samples to a flat array we can modify
    const total_pixels = @as(usize, stride) * @as(usize, h);
    var pixels = try allocator.alloc(u8, total_pixels);
    defer allocator.free(pixels);
    @memcpy(pixels, samples[0..total_pixels]);

    // Erase text regions: set pixels inside remove boxes to threshold (white)
    for (remove) |box| {
        const x1: i32 = @intFromFloat(@max(0, @floor(box.x1)));
        const y1: i32 = @intFromFloat(@max(0, @floor(box.y1)));
        const x2: i32 = @intFromFloat(@min(@as(f64, @floatFromInt(w)), @ceil(box.x2)));
        const y2: i32 = @intFromFloat(@min(@as(f64, @floatFromInt(h)), @ceil(box.y2)));

        var y: i32 = y1;
        while (y < y2) : (y += 1) {
            const row_start: usize = @as(usize, @intCast(y)) * stride;
            var x: i32 = x1;
            while (x < x2) : (x += 1) {
                pixels[row_start + @as(usize, @intCast(x))] = Threshold;
            }
        }
    }

    // Connected-component labeling via BFS
    var result = std.ArrayList(Box).empty;

    var y: u32 = 0;
    while (y < h) : (y += 1) {
        const row_start = @as(usize, stride) * @as(usize, y);
        var x: u32 = 0;
        while (x < w) : (x += 1) {
            const idx = row_start + x;
            if (idx < total_pixels and pixels[idx] < Threshold) {
                // Found a dark pixel — flood fill
                var min_x: u32 = x;
                var max_x: u32 = x;
                var min_y: u32 = y;
                var max_y: u32 = y;
                var pixel_count_in_cc: u32 = 0;

                // BFS queue
                var queue: std.ArrayList(struct { qx: u32, qy: u32 }) = .empty;
                defer queue.deinit(allocator);
                queue.append(allocator, .{ .qx = x, .qy = y }) catch continue;
                pixels[idx] = Threshold; // mark visited

                while (queue.items.len > 0) {
                    const pt = queue.orderedRemove(0);
                    pixel_count_in_cc += 1;

                    if (pt.qx < min_x) min_x = pt.qx;
                    if (pt.qx > max_x) max_x = pt.qx;
                    if (pt.qy < min_y) min_y = pt.qy;
                    if (pt.qy > max_y) max_y = pt.qy;

                    // Check 4-connected neighbors
                    const neighbors = [_][2]i32{
                        .{ @as(i32, @intCast(pt.qx)) - 1, @as(i32, @intCast(pt.qy)) },
                        .{ @as(i32, @intCast(pt.qx)) + 1, @as(i32, @intCast(pt.qy)) },
                        .{ @as(i32, @intCast(pt.qx)), @as(i32, @intCast(pt.qy)) - 1 },
                        .{ @as(i32, @intCast(pt.qx)), @as(i32, @intCast(pt.qy)) + 1 },
                    };

                    for (neighbors) |n| {
                        if (n[0] >= 0 and n[0] < @as(i32, @intCast(w)) and
                            n[1] >= 0 and n[1] < @as(i32, @intCast(h)))
                        {
                            const n_idx: usize = @intCast(@as(usize, @intCast(n[1])) * stride + @as(usize, @intCast(n[0])));
                            if (n_idx < total_pixels and pixels[n_idx] < Threshold) {
                                pixels[n_idx] = Threshold; // mark visited
                                queue.append(allocator, .{
                                    .qx = @intCast(n[0]),
                                    .qy = @intCast(n[1]),
                                }) catch continue;
                            }
                        }
                    }
                }

                // Filter tiny components
                if (pixel_count_in_cc >= OcrGraphicMinSize) {
                    const b = Box.init(
                        @floatFromInt(min_x),
                        @floatFromInt(min_y),
                        @floatFromInt(max_x + 1),
                        @floatFromInt(max_y + 1),
                    );
                    try result.append(allocator, b);
                }
            }
        }
    }

    return result.items;
}