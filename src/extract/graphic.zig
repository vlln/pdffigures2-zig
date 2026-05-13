// Graphics bounding box detection via custom MuPDF fz_device.
// Direct translation of GraphicBBDetector.scala.
// Intercepts fill_path, stroke_path, fill_image, fill_shade to capture
// the bounding boxes of all graphical operations while ignoring text.

const std = @import("std");
const c = @import("../mupdf.zig");
const Box = @import("../box.zig").Box;

/// State for the custom graphics device.
const GfxState = struct {
    bounds: std.ArrayList(Box),
    allocator: std.mem.Allocator,
    ignore_white: bool,
    ctx: *c.fz_context,
};

/// Extended device struct with our state pointer after the base fz_device.
/// fz_new_device_of_size allocates enough space for both the base device and our extra fields.
const GfxDevice = extern struct {
    base: c.fz_device,
    state: *GfxState,
};

/// Check if all color components are at maximum (white).
fn isWhiteColor(n: c_int, color: [*c]const f32) bool {
    var i: c_int = 0;
    while (i < n) : (i += 1) {
        if (color[@intCast(i)] < 0.99) return false;
    }
    return true;
}

/// Add the path bounds to the accumulated list, after clipping and white-filtering.
fn addPathBounds(
    gfx: *GfxDevice,
    path: ?*const c.fz_path,
    stroke: ?*const c.fz_stroke_state,
    ctm: c.fz_matrix,
    cs: [*c]c.fz_colorspace,
    color: [*c]const f32,
) void {
    const state = gfx.state;
    if (state.ignore_white) {
        const n = c.fz_colorspace_n(state.ctx, cs);
        if (isWhiteColor(n, color)) return;
    }
    const rect = c.fz_bound_path(state.ctx, path, stroke, ctm);
    if (c.fz_is_empty_rect(rect) != 0) return;
    if (c.fz_is_infinite_rect(rect) != 0) return;

    // Clip against current scissor
    const scissor = c.fz_device_current_scissor(state.ctx, &gfx.base);
    const clipped = if (c.fz_is_infinite_rect(scissor) != 0) rect else c.fz_intersect_rect(rect, scissor);
    if (c.fz_is_empty_rect(clipped) != 0) return;

    const b = Box.init(
        @floatCast(clipped.x0),
        @floatCast(clipped.y0),
        @floatCast(clipped.x1),
        @floatCast(clipped.y1),
    );
    state.bounds.append(state.allocator, b) catch {};
}

fn addImageBounds(
    gfx: *GfxDevice,
    ctm: c.fz_matrix,
) void {
    const state = gfx.state;
    // Image is mapped from unit rect [0,0,1,1] by the CTM
    const unit = c.fz_make_rect(0, 0, 1, 1);
    const rect = c.fz_transform_rect(unit, ctm);
    if (c.fz_is_empty_rect(rect) != 0) return;

    const scissor = c.fz_device_current_scissor(state.ctx, &gfx.base);
    const clipped = if (c.fz_is_infinite_rect(scissor) != 0) rect else c.fz_intersect_rect(rect, scissor);
    if (c.fz_is_empty_rect(clipped) != 0) return;

    const b = Box.init(
        @floatCast(clipped.x0),
        @floatCast(clipped.y0),
        @floatCast(clipped.x1),
        @floatCast(clipped.y1),
    );
    state.bounds.append(state.allocator, b) catch {};
}

// ---- Device callbacks ----

fn closeDevice(ctx: [*c]c.fz_context, dev: [*c]c.fz_device) callconv(.c) void {
    _ = ctx;
    _ = dev;
}

fn dropDevice(ctx: [*c]c.fz_context, dev: [*c]c.fz_device) callconv(.c) void {
    _ = ctx;
    _ = dev;
}

fn fillPath(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    path: ?*const c.fz_path,
    even_odd: c_int,
    ctm: c.fz_matrix,
    cs: [*c]c.fz_colorspace,
    color: [*c]const f32,
    alpha: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = ctx;
    _ = even_odd;
    _ = alpha;
    const gfx: *GfxDevice = @ptrCast(@alignCast(dev));
    addPathBounds(gfx, path, null, ctm, cs, color);
}

fn strokePath(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    path: ?*const c.fz_path,
    stroke: [*c]const c.fz_stroke_state,
    ctm: c.fz_matrix,
    cs: [*c]c.fz_colorspace,
    color: [*c]const f32,
    alpha: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = ctx;
    _ = alpha;
    const gfx: *GfxDevice = @ptrCast(@alignCast(dev));
    addPathBounds(gfx, path, stroke, ctm, cs, color);
}

fn clipPath(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    path: ?*const c.fz_path,
    even_odd: c_int,
    ctm: c.fz_matrix,
    scissor: c.fz_rect,
) callconv(.c) void {
    _ = ctx;
    _ = path;
    _ = even_odd;
    _ = ctm;
    _ = scissor;
    _ = dev;
    // MuPDF tracks the scissor internally; fz_device_current_scissor will return it
}

fn clipStrokePath(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    path: ?*const c.fz_path,
    stroke: [*c]const c.fz_stroke_state,
    ctm: c.fz_matrix,
    scissor: c.fz_rect,
) callconv(.c) void {
    _ = ctx;
    _ = path;
    _ = stroke;
    _ = ctm;
    _ = scissor;
    _ = dev;
}

fn ignoreText(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    text: [*c]const c.fz_text,
    ctm: c.fz_matrix,
    _: [*c]c.fz_colorspace,
    _: [*c]const f32,
    _: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = ctx;
    _ = dev;
    _ = text;
    _ = ctm;
    // Text is always ignored — we only want graphics
}

fn ignoreStrokeText(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    text: [*c]const c.fz_text,
    _: [*c]const c.fz_stroke_state,
    ctm: c.fz_matrix,
    _: [*c]c.fz_colorspace,
    _: [*c]const f32,
    _: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = ctx;
    _ = dev;
    _ = text;
    _ = ctm;
}

fn ignoreClipText(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    text: [*c]const c.fz_text,
    ctm: c.fz_matrix,
    _: c.fz_rect,
) callconv(.c) void {
    _ = ctx;
    _ = dev;
    _ = text;
    _ = ctm;
}

fn ignoreClipStrokeText(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    text: [*c]const c.fz_text,
    _: [*c]const c.fz_stroke_state,
    ctm: c.fz_matrix,
    _: c.fz_rect,
) callconv(.c) void {
    _ = ctx;
    _ = dev;
    _ = text;
    _ = ctm;
}

fn fillShade(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    shd: [*c]c.fz_shade,
    ctm: c.fz_matrix,
    alpha: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = alpha;
    const gfx: *GfxDevice = @ptrCast(@alignCast(dev));
    const state = gfx.state;
    const rect = c.fz_bound_shade(ctx, shd, ctm);
    if (c.fz_is_empty_rect(rect) != 0) return;

    const scissor = c.fz_device_current_scissor(state.ctx, &gfx.base);
    const clipped = if (c.fz_is_infinite_rect(scissor) != 0) rect else c.fz_intersect_rect(rect, scissor);
    if (c.fz_is_empty_rect(clipped) != 0) return;

    const b = Box.init(
        @floatCast(clipped.x0),
        @floatCast(clipped.y0),
        @floatCast(clipped.x1),
        @floatCast(clipped.y1),
    );
    state.bounds.append(state.allocator, b) catch {};
}

fn fillImage(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    img: ?*c.fz_image,
    ctm: c.fz_matrix,
    alpha: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = ctx;
    _ = img;
    _ = alpha;
    const gfx: *GfxDevice = @ptrCast(@alignCast(dev));
    addImageBounds(gfx, ctm);
}

fn fillImageMask(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    img: ?*c.fz_image,
    ctm: c.fz_matrix,
    cs: [*c]c.fz_colorspace,
    color: [*c]const f32,
    alpha: f32,
    _: c.fz_color_params,
) callconv(.c) void {
    _ = ctx;
    _ = img;
    _ = cs;
    _ = color;
    _ = alpha;
    const gfx: *GfxDevice = @ptrCast(@alignCast(dev));
    addImageBounds(gfx, ctm);
}

fn popClip(ctx: [*c]c.fz_context, dev: [*c]c.fz_device) callconv(.c) void {
    _ = ctx;
    _ = dev;
    // MuPDF handles clip stack internally
}

fn beginTile(
    ctx: [*c]c.fz_context,
    dev: [*c]c.fz_device,
    area: c.fz_rect,
    view: c.fz_rect,
    xstep: f32,
    ystep: f32,
    ctm: c.fz_matrix,
    id: c_int,
) callconv(.c) c_int {
    _ = ctx;
    _ = dev;
    _ = area;
    _ = view;
    _ = xstep;
    _ = ystep;
    _ = ctm;
    _ = id;
    return 0; // Don't handle tiles specially
}

/// Find bounding boxes of all graphical operations on a page.
/// Excludes text, includes paths, images, and shadings.
/// If ignore_white is true, white-filled/stroked paths are excluded.
pub fn findGraphicBB(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    page: [*c]c.fz_page,
    ignore_white: bool,
) ![]const Box {
    var gfx_state = GfxState{
        .bounds = std.ArrayList(Box).empty,
        .allocator = allocator,
        .ignore_white = ignore_white,
        .ctx = ctx,
    };
    errdefer gfx_state.bounds.deinit(allocator);

    const dev_size: c_int = @intCast(@sizeOf(GfxDevice));
    const dev_ptr = c.fz_new_device_of_size(ctx, dev_size);
    if (dev_ptr == null) return error.OutOfMemory;
    errdefer c.fz_drop_device(ctx, dev_ptr);

    const gfx: *GfxDevice = @ptrCast(@alignCast(dev_ptr));
    gfx.state = &gfx_state;

    // Set up callbacks
    gfx.base.close_device = &closeDevice;
    gfx.base.drop_device = &dropDevice;
    gfx.base.fill_path = &fillPath;
    gfx.base.stroke_path = &strokePath;
    gfx.base.clip_path = &clipPath;
    gfx.base.clip_stroke_path = &clipStrokePath;
    gfx.base.fill_text = &ignoreText;
    gfx.base.stroke_text = &ignoreStrokeText;
    gfx.base.clip_text = &ignoreClipText;
    gfx.base.clip_stroke_text = &ignoreClipStrokeText;
    // ignore_text is a legacy 4-param callback; we already handle all four
    // specific text callbacks above, so leave ignore_text as null (default).
    gfx.base.fill_shade = &fillShade;
    gfx.base.fill_image = &fillImage;
    gfx.base.fill_image_mask = &fillImageMask;
    gfx.base.pop_clip = &popClip;
    gfx.base.begin_tile = &beginTile;

    // Enable device hints for bounding box tracking
    c.fz_enable_device_hints(ctx, &gfx.base, c.FZ_DONT_INTERPOLATE_IMAGES);

    // Run the page through our device
    c.fz_run_page(ctx, page, &gfx.base, c.fz_identity, null);
    c.fz_close_device(ctx, &gfx.base);
    c.fz_drop_device(ctx, &gfx.base);

    return gfx_state.bounds.toOwnedSlice(allocator);
}