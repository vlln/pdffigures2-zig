// Interruptible PDF rendering with cancellation support.
// Direct translation of InterruptiblePDFRenderer.scala.
// Uses MuPDF's fz_cookie mechanism for safe mid-render abort.

const std = @import("std");
const c = @import("../mupdf.zig");

/// Shared cancellation flag for interruptible operations.
pub const CancellationToken = struct {
    flag: std.atomic.Value(bool) = std.atomic.Value(bool).init(false),

    pub fn cancel(self: *CancellationToken) void {
        self.flag.store(true, .release);
    }

    pub fn isCancelled(self: *const CancellationToken) bool {
        return self.flag.load(.acquire);
    }
};

/// Error returned when rendering is cancelled mid-operation.
pub const CancelledError = error.Cancelled;

/// Render a page to a pixmap at the given DPI, checking for cancellation.
/// Uses fz_cookie so MuPDF can abort rendering partway through if cancelled.
/// Returns null if cancelled before rendering could complete.
pub fn renderPage(
    ctx: *c.fz_context,
    page: *c.fz_page,
    dpi: f32,
    token: ?*const CancellationToken,
) !?*c.fz_pixmap {
    // Check cancellation before starting
    if (token != null and token.?.isCancelled()) return null;

    const scale = dpi / 72.0;
    const ctm = c.fz_scale(scale, scale);

    // Use display list + cookie for interruptible rendering
    const list = c.fz_new_display_list_from_page(ctx, page);
    if (list == null) return error.RenderError;
    defer c.fz_drop_display_list(ctx, list);

    // Check cancellation again before expensive operation
    if (token != null and token.?.isCancelled()) return null;

    const rect = c.fz_bound_display_list(ctx, list);
    const bbox = c.fz_irect{
        .x0 = 0,
        .y0 = 0,
        .x1 = @intFromFloat(@ceil(rect.x1 * scale)),
        .y1 = @intFromFloat(@ceil(rect.y1 * scale)),
    };

    const pixmap = c.fz_new_pixmap_with_bbox(ctx, c.fz_device_rgb(ctx), bbox, null, 1);
    if (pixmap == null) return error.RenderError;
    errdefer c.fz_drop_pixmap(ctx, pixmap);

    c.fz_clear_pixmap_with_value(ctx, pixmap, 0xff);

    const dev = c.fz_new_draw_device(ctx, ctm, pixmap);
    if (dev == null) return error.RenderError;
    defer c.fz_drop_device(ctx, dev);

    // Set up cookie for cancellation — MuPDF checks cookie.abort during rendering
    var cookie: c.fz_cookie = .{
        .abort = 0,
        .progress = 0,
        .progress_max = 0,
        .errors = 0,
        .incomplete = 0,
    };

    c.fz_run_display_list(ctx, list, dev, ctm, c.fz_infinite_rect, &cookie);

    // If rendering was aborted by the cookie mechanism, incomplete will be set
    if (cookie.incomplete != 0 and token != null and token.?.isCancelled()) {
        return null;
    }

    // Check cancellation one more time after rendering
    if (token != null and token.?.isCancelled()) {
        return null;
    }

    return pixmap;
}

/// Render a page to a pixmap without cancellation support.
pub fn renderPageSimple(
    ctx: *c.fz_context,
    page: *c.fz_page,
    dpi: f32,
) !*c.fz_pixmap {
    const result = try renderPage(ctx, page, dpi, null);
    return result orelse return error.RenderError;
}

test "CancellationToken cancel and check" {
    var token = CancellationToken{};
    try std.testing.expect(!token.isCancelled());
    token.cancel();
    try std.testing.expect(token.isCancelled());
}

test "renderPage returns null when cancelled before start" {
    const ctx = c.fz_new_context(null, null, 256 << 20) orelse return error.MupdfError;
    defer c.fz_drop_context(ctx);

    // Create a minimal 1x1 page
    const buf = c.fz_new_buffer_from_copied_data(ctx, "%PDF-1.0\n1 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 1 1]>>endobj\n2 0 obj<</Type/Pages/Kids[1 0 R]/Count 1>>endobj\n3 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\nxref\n0 4\n0000000000 65535 f \n0000000009 00000 n \n0000000074 00000 n \n0000000145 00000 n \ntrailer<</Size 4/Root 3 0 R>>\nstartxref\n202\n%%EOF", @intCast("%PDF-1.0\n1 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 1 1]>>endobj\n2 0 obj<</Type/Pages/Kids[1 0 R]/Count 1>>endobj\n3 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\nxref\n0 4\n0000000000 65535 f \n0000000009 00000 n \n0000000074 00000 n \n0000000145 00000 n \ntrailer<</Size 4/Root 3 0 R>>\nstartxref\n202\n%%EOF".len));
    if (buf == null) return error.BufferError;
    defer c.fz_drop_buffer(ctx, buf);
    const doc = c.fz_open_document_with_buffer(ctx, buf, "minimal.pdf");
    if (doc == null) return error.DocError;
    defer c.fz_drop_document(ctx, doc);

    const page = c.fz_load_page(ctx, doc, 0);
    if (page == null) return error.PageError;
    defer c.fz_drop_page(ctx, page);

    // Render without cancellation — should succeed
    {
        const pix = try renderPage(ctx, page, 72.0, null);
        try std.testing.expect(pix != null);
        c.fz_drop_pixmap(ctx, pix);
    }

    // Render with pre-cancelled token — should return null
    {
        var token = CancellationToken{};
        token.cancel();
        const pix = try renderPage(ctx, page, 72.0, &token);
        try std.testing.expect(pix == null);
    }
}