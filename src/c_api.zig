// C ABI shared library interface for embedding pdffigures2 in other languages.
// Exports a minimal, stable C API. All strings are malloc'd and must be freed
// by the caller using pdffigures2_free_string.

const std = @import("std");
const c = @import("mupdf.zig");
const extractor = @import("extractor.zig");
const image_output = @import("image_output.zig");

const MAX_ERROR_LEN = 1024;

/// Opaque context holding MuPDF state. Not thread-safe — caller must serialize access.
pub const Pdffigures2Context = struct {
    mu_ctx: *c.fz_context,
    last_error: [MAX_ERROR_LEN]u8 = std.mem.zeroes([MAX_ERROR_LEN]u8),
    error_len: usize = 0,
    lock: std.atomic.Value(bool) = std.atomic.Value(bool).init(false),

    fn setError(self: *Pdffigures2Context, msg: []const u8) void {
        const len = @min(msg.len, MAX_ERROR_LEN - 1);
        @memcpy(self.last_error[0..len], msg[0..len]);
        self.last_error[len] = 0;
        self.error_len = len;
    }

    fn acquireLock(self: *Pdffigures2Context) void {
        while (self.lock.swap(true, .acquire)) {
            std.atomic.spinLoopHint();
        }
    }

    fn releaseLock(self: *Pdffigures2Context) void {
        self.lock.store(false, .release);
    }
};

/// Create a new pdffigures2 context. Returns null on failure.
/// Caller must destroy with pdffigures2_destroy.
export fn pdffigures2_create() ?*Pdffigures2Context {
    const allocator = std.heap.c_allocator;

    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) return null;

    c.fz_register_document_handlers(ctx);

    const pctx = allocator.create(Pdffigures2Context) catch {
        c.fz_drop_context(ctx);
        return null;
    };
    pctx.* = .{ .mu_ctx = ctx.? };
    return pctx;
}

/// Destroy a pdffigures2 context. Pass null for safe no-op.
export fn pdffigures2_destroy(pctx: ?*Pdffigures2Context) void {
    if (pctx) |ctx| {
        c.fz_drop_context(ctx.mu_ctx);
        std.heap.c_allocator.destroy(ctx);
    }
}

/// Extract figures from a PDF file. Returns JSON string (malloc'd).
/// Caller must free with pdffigures2_free_string. Returns null on error.
export fn pdffigures2_extract(pctx: ?*Pdffigures2Context, pdf_path: [*c]const u8, dpi: c_int) [*c]u8 {
    if (pctx == null) return null;
    const self = pctx.?;

    self.acquireLock();
    defer self.releaseLock();

    const path = std.mem.sliceTo(pdf_path, 0);

    const doc = c.fz_open_document(self.mu_ctx, path);
    if (doc == null) {
        self.setError("Failed to open PDF file");
        return null;
    }
    defer c.fz_drop_document(self.mu_ctx, doc);

    const config = extractor.ExtractorConfig{ .dpi = @intCast(dpi) };
    const result = extractor.getFiguresJson(std.heap.c_allocator, self.mu_ctx, doc, config) catch |err| {
        var buf: [256]u8 = undefined;
        const msg = std.fmt.bufPrint(&buf, "Extraction failed: {}", .{err}) catch "Extraction failed";
        self.setError(msg);
        return null;
    };

    // Convert arena-allocated string to malloc'd C string
    const c_str = std.heap.c_allocator.dupeZ(u8, result) catch {
        self.setError("Memory allocation failed");
        return null;
    };
    return c_str.ptr;
}

/// Extract figures with base64-encoded PNG images in JSON.
/// Returns JSON string (malloc'd). Caller must free with pdffigures2_free_string.
export fn pdffigures2_extract_with_images(pctx: ?*Pdffigures2Context, pdf_path: [*c]const u8, dpi: c_int) [*c]u8 {
    if (pctx == null) return null;
    const self = pctx.?;

    self.acquireLock();
    defer self.releaseLock();

    const path = std.mem.sliceTo(pdf_path, 0);

    const doc = c.fz_open_document(self.mu_ctx, path);
    if (doc == null) {
        self.setError("Failed to open PDF file");
        return null;
    }
    defer c.fz_drop_document(self.mu_ctx, doc);

    const config = extractor.ExtractorConfig{ .dpi = @intCast(dpi) };
    const result = extractor.getRasterizedFigures(std.heap.c_allocator, self.mu_ctx, doc, config) catch |err| {
        var buf: [256]u8 = undefined;
        const msg = std.fmt.bufPrint(&buf, "Extraction failed: {}", .{err}) catch "Extraction failed";
        self.setError(msg);
        return null;
    };

    // Build JSON with base64-encoded images
    var json_buf = std.ArrayList(u8).initCapacity(std.heap.c_allocator, result.figures.len * 4096) catch {
        self.setError("Memory allocation failed");
        return null;
    };
    defer json_buf.deinit(std.heap.c_allocator);

    json_buf.appendSlice(std.heap.c_allocator, "[") catch {
        self.setError("Memory allocation failed");
        return null;
    };

    for (result.figures, 0..) |rf, fi| {
        if (fi > 0) {
            json_buf.appendSlice(std.heap.c_allocator, ",") catch {
                self.setError("Memory allocation failed");
                return null;
            };
        }

        // Encode image as PNG, then base64
        const png_bytes = encode_png: {
            const pix = c.fz_new_pixmap_with_data(
                self.mu_ctx,
                c.fz_device_rgb(self.mu_ctx),
                @intCast(rf.image_width),
                @intCast(rf.image_height),
                null,
                1,
                @intCast(rf.image_width * 4),
                rf.image_data.ptr,
            );
            if (pix == null) break :encode_png null;
            defer c.fz_drop_pixmap(self.mu_ctx, pix);

            break :encode_png image_output.pixmapToPngBuffer(self.mu_ctx, pix, std.heap.c_allocator) catch null;
        };

        const b64: ?[]u8 = if (png_bytes) |png| blk: {
            defer std.heap.c_allocator.free(png);
            break :blk base64Encode(std.heap.c_allocator, png) catch null;
        } else null;
        defer if (b64) |b| std.heap.c_allocator.free(b);

        const fig = rf.figure;
        var item_buf: [4096]u8 = undefined;
        const item = std.fmt.bufPrint(&item_buf,
            \\{{"name":"{s}","figType":"{s}","page":{d},"captionBoundary":{{"x1":{d:.1},"y1":{d:.1},"x2":{d:.1},"y2":{d:.1}}},"regionBoundary":{{"x1":{d:.1},"y1":{d:.1},"x2":{d:.1},"y2":{d:.1}}},"imageBase64":"{s}"}}
        , .{
            fig.name,
            @tagName(fig.fig_type),
            fig.page,
            fig.caption_boundary.x1, fig.caption_boundary.y1,
            fig.caption_boundary.x2, fig.caption_boundary.y2,
            fig.region_boundary.x1, fig.region_boundary.y1,
            fig.region_boundary.x2, fig.region_boundary.y2,
            b64 orelse "",
        }) catch {
            self.setError("String formatting failed");
            return null;
        };
        json_buf.appendSlice(std.heap.c_allocator, item) catch {
            self.setError("Memory allocation failed");
            return null;
        };
    }
    json_buf.appendSlice(std.heap.c_allocator, "]") catch {
        self.setError("Memory allocation failed");
        return null;
    };

    const c_str = std.heap.c_allocator.dupeZ(u8, json_buf.items) catch {
        self.setError("Memory allocation failed");
        return null;
    };
    return c_str.ptr;
}

/// Free a string returned by pdffigures2_extract or pdffigures2_extract_with_images.
/// Safe no-op on null.
export fn pdffigures2_free_string(str: [*c]u8) void {
    if (str != null) {
        const len = std.mem.sliceTo(str, 0).len;
        std.heap.c_allocator.free(str[0..len]);
    }
}

/// Get the last error message. Returns null if no error.
/// The returned pointer is valid until the next call on this context.
export fn pdffigures2_last_error(pctx: ?*Pdffigures2Context) [*c]const u8 {
    if (pctx) |self| {
        if (self.error_len > 0) {
            return @ptrCast(&self.last_error);
        }
    }
    return null;
}

fn base64Encode(allocator: std.mem.Allocator, data: []const u8) ![]u8 {
    const encoder = std.base64.standard.Encoder;
    const out_len = encoder.calcSize(data.len);
    const out = try allocator.alloc(u8, out_len);
    _ = encoder.encode(out, data);
    return out;
}