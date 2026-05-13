// Visualization CLI: renders PDF pages with annotated overlays for
// figures, captions, body text, other text, and graphics regions.
// Direct translation of FigureExtractorVisualizationCli.scala.
// Outputs static PNG files (Scala version uses Swing GUI).

const std = @import("std");
const c = @import("../mupdf.zig");
const extractor = @import("../extractor.zig");
const image_output = @import("../image_output.zig");
const Box = @import("../box.zig").Box;

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: [][]const u8) !void {
    _ = io;
    var input_path: ?[]const u8 = null;
    var output_prefix: ?[]const u8 = null;
    var display_dpi: f32 = 55;
    var show_all_steps = false;
    var show_captions = false;
    var show_regions = false;
    var show_graphics = false;
    var show_sections = false;
    var page_list: ?[]const u8 = null;

    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            printUsage();
            return;
        } else if (std.mem.eql(u8, arg, "-o")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            output_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-d")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            display_dpi = try std.fmt.parseFloat(f32, args[i]);
        } else if (std.mem.eql(u8, arg, "-p")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            page_list = args[i];
        } else if (std.mem.eql(u8, arg, "-s")) {
            show_all_steps = true;
        } else if (std.mem.eql(u8, arg, "-c")) {
            show_captions = true;
        } else if (std.mem.eql(u8, arg, "-r")) {
            show_regions = true;
        } else if (std.mem.eql(u8, arg, "-g")) {
            show_graphics = true;
        } else if (std.mem.eql(u8, arg, "-t")) {
            show_sections = true;
        } else if (arg[0] != '-') {
            input_path = arg;
        }
    }

    const pdf_path = input_path orelse {
        printStderr("Error: no input PDF specified\n", .{});
        printUsage();
        std.process.exit(1);
    };

    // Parse page list (1-based, comma-separated)
    var pages_to_render = std.AutoHashMap(u32, void).init(allocator);
    defer pages_to_render.deinit();
    if (page_list) |pl| {
        var it = std.mem.splitScalar(u8, pl, ',');
        while (it.next()) |num_str| {
            const num = std.fmt.parseUnsigned(u32, std.mem.trim(u8, num_str, " "), 10) catch continue;
            if (num > 0) try pages_to_render.put(num, {});
        }
    }

    // Derive output prefix from input filename if not specified
    const stem = if (output_prefix) |p| p else blk: {
        const basename = std.fs.path.basename(pdf_path);
        if (std.mem.endsWith(u8, basename, ".pdf")) {
            break :blk basename[0 .. basename.len - 4];
        }
        break :blk basename;
    };

    // Show all steps by default unless specific flags given
    if (!show_captions and !show_regions and !show_graphics and !show_sections) {
        show_all_steps = true;
    }

    // Create MuPDF context
    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) {
        printStderr("Error: failed to create MuPDF context\n", .{});
        std.process.exit(1);
    }
    defer c.fz_drop_context(ctx);

    c.fz_register_document_handlers(ctx);

    const doc = c.fz_open_document(ctx, @ptrCast(pdf_path));
    if (doc == null) {
        printStderr("Error: failed to open PDF\n", .{});
        std.process.exit(1);
    }
    defer c.fz_drop_document(ctx, doc);

    const page_count = c.fz_count_pages(ctx, doc);

    // Run extraction with debug data
    const config = extractor.ExtractorConfig{};
    const result = extractor.getFiguresWithDebugData(allocator, ctx, doc, config) catch |err| {
        printStderr("Error: extraction failed: {}\n", .{err});
        std.process.exit(1);
    };

    // Render each page
    for (result.debug_pages) |dp| {
        const page_num = dp.page_number;

        // Filter by page list if specified
        if (pages_to_render.count() > 0 and !pages_to_render.contains(page_num)) continue;
        if (page_num > page_count) continue;

        printStderr("Rendering page {d}/{d}...\n", .{ page_num, page_count });

        const mu_page = c.fz_load_page(ctx, doc, @intCast(page_num - 1));
        if (mu_page == null) {
            printStderr("  Warning: failed to load page {d}\n", .{page_num});
            continue;
        }
        defer c.fz_drop_page(ctx, mu_page);

        const scale = display_dpi / 72.0;
        const ctm = c.fz_scale(scale, scale);
        const pixmap = c.fz_new_pixmap_from_page(ctx, mu_page, ctm, c.fz_device_rgb(ctx), 0);
        if (pixmap == null) {
            printStderr("  Warning: failed to render page {d}\n", .{page_num});
            continue;
        }
        defer c.fz_drop_pixmap(ctx, pixmap);

        // Scale boxes from PDF space to pixel space
        const scl = @as(f64, @floatCast(scale));

        // Draw overlay layers
        if (show_all_steps or show_regions) {
            // Body text → green
            for (dp.body_text) |p| {
                const b = p.boundary.scale(scl);
                image_output.drawRect(ctx, pixmap, b, image_output.Colors.body_text, 1);
            }
            // Other text → yellow
            for (dp.other_text) |p| {
                const b = p.boundary.scale(scl);
                image_output.drawRect(ctx, pixmap, b, image_output.Colors.other_text, 1);
            }
        }

        if (show_all_steps or show_graphics) {
            // Graphics → orange
            for (dp.graphics) |g| {
                const b = g.scale(scl);
                image_output.drawRect(ctx, pixmap, b, image_output.Colors.graphics, 2);
            }
        }

        if (show_all_steps or show_captions) {
            // Captions → blue
            for (dp.captions) |cap| {
                const b = cap.boundary().scale(scl);
                image_output.drawRect(ctx, pixmap, b, image_output.Colors.caption, 3);
            }
        }

        // Figures → red (always shown)
        for (dp.figures) |fig| {
            const rb = fig.region_boundary.scale(scl);
            const cb = fig.caption_boundary.scale(scl);
            image_output.drawRect(ctx, pixmap, rb, image_output.Colors.figure_region, 3);
            image_output.drawFilledRect(ctx, pixmap, cb, image_output.Colors.caption);
        }

        // Save to file
        var filename_buf: [256]u8 = undefined;
        const filename = try std.fmt.bufPrint(&filename_buf, "{s}_page_{d}.png", .{ stem, page_num });
        try image_output.savePixmapAsPng(ctx, pixmap, filename);
        printStderr("  Saved {s}\n", .{filename});
    }

    printStderr("Done. {d} figures found across {d} pages.\n", .{ result.figures.len, result.debug_pages.len });
}

fn printUsage() void {
    std.debug.print(
        \\Usage: pdffigures2 visualize <input.pdf> [options]
        \\
        \\Options:
        \\  -o <prefix>   Output filename prefix (default: input stem)
        \\  -d <dpi>      Display DPI (default: 55)
        \\  -p <pages>    Comma-separated page numbers, 1-based (default: all)
        \\  -s            Show all visualization layers
        \\  -c            Show caption boundaries
        \\  -r            Show body/other text regions
        \\  -g            Show graphics bounding boxes
        \\  -t            Show section titles
        \\  -h            Show this help
        \\
        \\Layer colors:
        \\  Red (thick)   = Figure region boundary
        \\  Blue (thick)  = Caption boundary
        \\  Green (thin)  = Body text paragraphs
        \\  Yellow (thin) = Other/unknown text
        \\  Orange (mid)  = Graphics bounding boxes
        \\
    , .{});
}

fn printStderr(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}