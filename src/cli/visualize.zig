// Visualization CLI: renders PDF pages with annotated overlays for
// figures, captions, body text, other text, and graphics regions.
// Direct translation of FigureExtractorVisualizationCli.scala.
// Outputs static PNG files (Scala version uses Swing GUI).

const std = @import("std");
const c = @import("../mupdf.zig");
const extractor = @import("../extractor.zig");
const image_output = @import("../image_output.zig");
const Box = @import("../box.zig").Box;
const Paragraph = @import("../paragraph.zig").Paragraph;

const Rgba = image_output.Rgba;
const Colors = struct {
    pub const figure_region = Rgba{ .r = 0, .g = 200, .b = 0 }; // Green (Scala)
    pub const caption = Rgba{ .r = 0, .g = 0, .b = 255 }; // Blue (Scala)
    pub const caption_joint = Rgba{ .r = 0, .g = 0, .b = 255 }; // Blue
    pub const body_text = Rgba{ .r = 0, .g = 200, .b = 0 }; // Green
    pub const other_text = Rgba{ .r = 255, .g = 255, .b = 0 }; // Yellow
    pub const graphics = Rgba{ .r = 0, .g = 200, .b = 0 }; // Green (Scala: graphic elements)
    pub const graphics_cluster = Rgba{ .r = 0, .g = 100, .b = 0 }; // Dark green (Scala: clustered)
    pub const non_figure_content = Rgba{ .r = 0, .g = 0, .b = 0 }; // Black
    pub const paragraph = Rgba{ .r = 0, .g = 0, .b = 255 }; // Blue (Scala paragraphs)
    pub const text_line = Rgba{ .r = 255, .g = 0, .b = 0 }; // Red (Scala text lines)
    pub const section_title = Rgba{ .r = 255, .g = 0, .b = 0 }; // Red (Scala sections)
    pub const cleaned_figure = Rgba{ .r = 0, .g = 0, .b = 0 }; // Black (Scala cleaned)
    pub const figure_region_original = Rgba{ .r = 0, .g = 200, .b = 0 }; // Green (Scala original)
};

const CliConfig = struct {
    input_path: []const u8,
    output_prefix: ?[]const u8 = null,
    display_dpi: u32 = 55,
    show_all_steps: bool = false,
    show_extractions: bool = false,
    show_graphic_clustering: bool = false,
    show_cleaned_figure_regions: bool = false,
    show_regions: bool = false,
    show_captions: bool = false,
    show_sections: bool = false,
    page_list: ?[]const u8 = null,
};

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: [][]const u8) !void {
    var config = CliConfig{ .input_path = undefined };

    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            printUsage();
            return;
        } else if (std.mem.eql(u8, arg, "-o")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            config.output_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-d") or std.mem.eql(u8, arg, "--display-dpi")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            config.display_dpi = try std.fmt.parseUnsigned(u32, args[i], 10);
        } else if (std.mem.eql(u8, arg, "-p") or std.mem.eql(u8, arg, "--pages")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            config.page_list = args[i];
        } else if (std.mem.eql(u8, arg, "-s") or std.mem.eql(u8, arg, "--show-steps")) {
            config.show_all_steps = true;
        } else if (std.mem.eql(u8, arg, "-e") or std.mem.eql(u8, arg, "--show-extractions")) {
            config.show_extractions = true;
        } else if (std.mem.eql(u8, arg, "-g") or std.mem.eql(u8, arg, "--show-graphic-clustering")) {
            config.show_graphic_clustering = true;
        } else if (std.mem.eql(u8, arg, "-x") or std.mem.eql(u8, arg, "--show-cleaned-figure-regions")) {
            config.show_cleaned_figure_regions = true;
        } else if (std.mem.eql(u8, arg, "-r") or std.mem.eql(u8, arg, "--show-regions")) {
            config.show_regions = true;
        } else if (std.mem.eql(u8, arg, "-c") or std.mem.eql(u8, arg, "--show-captions")) {
            config.show_captions = true;
        } else if (std.mem.eql(u8, arg, "-t") or std.mem.eql(u8, arg, "--show-sections")) {
            config.show_sections = true;
        } else if (arg[0] != '-') {
            config.input_path = arg;
        }
    }

    _ = config.input_path; // validated below via open

    // Parse page list (1-based, comma-separated)
    var pages_to_render = std.AutoHashMap(u32, void).init(allocator);
    defer pages_to_render.deinit();
    if (config.page_list) |pl| {
        var it = std.mem.splitScalar(u8, pl, ',');
        while (it.next()) |num_str| {
            const num = std.fmt.parseUnsigned(u32, std.mem.trim(u8, num_str, " "), 10) catch continue;
            if (num > 0) try pages_to_render.put(num, {});
        }
    }

    // Derive output prefix from input filename if not specified
    const pdf_path = config.input_path;
    const stem = if (config.output_prefix) |p| p else blk: {
        const basename = std.fs.path.basename(pdf_path);
        if (std.mem.endsWith(u8, basename, ".pdf")) {
            break :blk basename[0 .. basename.len - 4];
        }
        break :blk basename;
    };

    // Determine if stem is a directory (ends with / or exists as dir)
    const use_dir = stem.len > 0 and (stem[stem.len - 1] == '/' or stem[stem.len - 1] == std.fs.path.sep);
    var dir_path: []const u8 = undefined;
    var file_prefix: []const u8 = undefined;

    if (use_dir) {
        const clean_stem = stem[0 .. stem.len - 1];
        std.Io.Dir.cwd().createDirPath(io, clean_stem) catch |err| {
            printStderr("Error: failed to create output directory '{s}': {}\n", .{ clean_stem, err });
            std.process.exit(1);
        };
        dir_path = clean_stem;
        const basename = std.fs.path.basename(pdf_path);
        file_prefix = if (std.mem.endsWith(u8, basename, ".pdf")) basename[0 .. basename.len - 4] else basename;
    } else {
        const dir = std.Io.Dir.cwd().openDir(io, stem, .{}) catch null;
        if (dir) |d| {
            d.close(io);
            dir_path = stem;
            const basename = std.fs.path.basename(pdf_path);
            file_prefix = if (std.mem.endsWith(u8, basename, ".pdf")) basename[0 .. basename.len - 4] else basename;
        } else {
            dir_path = "";
            file_prefix = stem;
        }
    }

    // Show all steps by default unless specific flags given
    if (!config.show_extractions and !config.show_graphic_clustering and
        !config.show_cleaned_figure_regions and !config.show_regions and
        !config.show_captions and !config.show_sections)
    {
        config.show_all_steps = true;
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
    const ext_config = extractor.ExtractorConfig{};
    const result = extractor.getFiguresWithDebugData(allocator, ctx, doc, ext_config) catch |err| {
        printStderr("Error: extraction failed: {}\n", .{err});
        std.process.exit(1);
    };

    // If -x is requested, render figures at display DPI for cleaned region comparison
    var cleaned_regions = std.AutoHashMap(u32, std.ArrayList(Box)).init(allocator);
    defer {
        var it = cleaned_regions.valueIterator();
        while (it.next()) |v| v.deinit(allocator);
        cleaned_regions.deinit();
    }
    if (config.show_all_steps or config.show_cleaned_figure_regions) {
        const render_config = extractor.ExtractorConfig{ .dpi = config.display_dpi, .clean_rasterized_figure_regions = true };
        const rasterized = extractor.getRasterizedFigures(allocator, ctx, doc, render_config) catch null;
        if (rasterized) |rast| {
            for (rast.figures) |rf| {
                const entry = try cleaned_regions.getOrPutValue(rf.figure.page, std.ArrayList(Box).empty);
                // Scale image_region from DPI coordinates back to PDF coordinates (72 DPI)
                const scl = 72.0 / @as(f64, @floatFromInt(config.display_dpi));
                try entry.value_ptr.append(allocator, rf.image_region.scale(scl));
            }
        }
    }

    // Render each page
    for (result.debug_pages) |dp| {
        const page_num = dp.page_number + 1;

        if (pages_to_render.count() > 0 and !pages_to_render.contains(page_num)) continue;
        if (page_num > page_count) continue;

        printStderr("Rendering page {d}/{d}...\n", .{ page_num, page_count });

        const mu_page = c.fz_load_page(ctx, doc, @intCast(page_num - 1));
        if (mu_page == null) {
            printStderr("  Warning: failed to load page {d}\n", .{page_num});
            continue;
        }
        defer c.fz_drop_page(ctx, mu_page);

        const scale = @as(f64, @floatFromInt(config.display_dpi)) / 72.0;
        const ctm = c.fz_scale(@floatCast(scale), @floatCast(scale));
        const pixmap = c.fz_new_pixmap_from_page(ctx, mu_page, ctm, c.fz_device_rgb(ctx), 0);
        if (pixmap == null) {
            printStderr("  Warning: failed to render page {d}\n", .{page_num});
            continue;
        }
        defer c.fz_drop_pixmap(ctx, pixmap);

        const scl = scale;

        // ---- Layer: Graphic Clustering (-g) ----
        if (config.show_all_steps or config.show_graphic_clustering) {
            // Raw graphic elements (dashed green)
            for (dp.raw_graphics) |g| {
                drawDashedRect(ctx, pixmap, g.scale(scl), Colors.graphics, 1);
            }
            // Clustered groups (dark green, thick)
            for (dp.graphics) |g| {
                image_output.drawRect(ctx, pixmap, g.scale(scl), Colors.graphics_cluster, 4);
            }
        }

        // ---- Layer: Text and Graphic Extraction (-e) ----
        if (config.show_all_steps or config.show_extractions) {
            // All graphics (green)
            for (dp.raw_graphics) |g| {
                image_output.drawRect(ctx, pixmap, g.scale(scl), Colors.graphics, 1);
            }
            for (dp.non_figure_graphics) |g| {
                image_output.drawRect(ctx, pixmap, g.scale(scl), Colors.graphics, 1);
            }
            // Paragraph boundaries (blue)
            for (dp.paragraphs) |p| {
                image_output.drawRect(ctx, pixmap, p.boundary.scale(scl), Colors.paragraph, 2);
            }
            // Text line boundaries (red)
            for (dp.paragraphs) |p| {
                for (p.lines) |l| {
                    image_output.drawRect(ctx, pixmap, l.boundary.scale(scl), Colors.text_line, 1);
                }
            }
            // Non-figure content (black)
            const all_content = try concatBoxes(allocator, &.{ dp.body_text, dp.other_text }, dp.non_figure_graphics);
            defer allocator.free(all_content);
            for (all_content) |b| {
                image_output.drawFilledRect(ctx, pixmap, b.scale(scl), Colors.non_figure_content);
            }
        }

        // ---- Layer: Caption Locations (-c) ----
        if (config.show_all_steps or config.show_captions) {
            // Caption boundaries (red)
            for (dp.captions) |cap| {
                image_output.drawRect(ctx, pixmap, cap.boundary().scale(scl), Colors.caption, 2);
            }
            // Graphic elements (green)
            for (dp.graphics) |g| {
                image_output.drawRect(ctx, pixmap, g.scale(scl), Colors.graphics, 1);
            }
            // Paragraph boundaries (blue)
            for (dp.paragraphs) |p| {
                image_output.drawRect(ctx, pixmap, p.boundary.scale(scl), Colors.paragraph, 1);
            }
        }

        // ---- Layer: Region Classification (-r) ----
        if (config.show_all_steps or config.show_regions) {
            // Non-figure content (black, filled)
            for (dp.body_text) |p| {
                image_output.drawFilledRect(ctx, pixmap, p.boundary.scale(scl), Colors.non_figure_content);
            }
            // Other/potential-figure text (red, thin)
            for (dp.other_text) |p| {
                image_output.drawRect(ctx, pixmap, p.boundary.scale(scl), Colors.other_text, 1);
            }
            // Captions (red, filled)
            for (dp.captions) |cap| {
                image_output.drawFilledRect(ctx, pixmap, cap.boundary().scale(scl), Colors.caption);
            }
            // Graphics (green)
            for (dp.graphics) |g| {
                image_output.drawRect(ctx, pixmap, g.scale(scl), Colors.graphics, 1);
            }
        }

        // ---- Layer: Figures (always shown) ----
        // -s: green figure regions + blue caption boundaries
        // Always: red figure regions + blue caption filled
        for (dp.figures) |fig| {
            const rb = fig.region_boundary.scale(scl);
            const cb = fig.caption_boundary.scale(scl);
            if (config.show_all_steps) {
                image_output.drawRect(ctx, pixmap, rb, Colors.figure_region, 2); // Green (Scala)
                image_output.drawRect(ctx, pixmap, cb, Colors.caption_joint, 2); // Blue (Scala)
                // Joint container around figure+caption
                const joint = Box.init(
                    @min(rb.x1, cb.x1),
                    @min(rb.y1, cb.y1),
                    @max(rb.x2, cb.x2),
                    @max(rb.y2, cb.y2),
                );
                image_output.drawRect(ctx, pixmap, joint, Colors.caption_joint, 2);
            } else {
                image_output.drawRect(ctx, pixmap, rb, Colors.figure_region, 3); // Red (compact)
                image_output.drawFilledRect(ctx, pixmap, cb, Colors.caption); // Blue filled
            }
        }

        // ---- Layer: Cleaned Figures (-x) ----
        if (config.show_all_steps or config.show_cleaned_figure_regions) {
            // Original figure region boundaries (green)
            for (dp.figures) |fig| {
                image_output.drawRect(ctx, pixmap, fig.region_boundary.scale(scl), Colors.figure_region_original, 2);
            }
            // Cleaned figure regions (black dashed)
            if (cleaned_regions.get(dp.page_number)) |clean_list| {
                for (clean_list.items) |clean_box| {
                    drawDashedRect(ctx, pixmap, clean_box.scale(scl), Colors.cleaned_figure, 2);
                }
            }
        }

        // ---- Layer: Sections (-t) ----
        if (config.show_all_steps or config.show_sections) {
            // Paragraph boundaries (blue)
            for (dp.paragraphs) |p| {
                image_output.drawRect(ctx, pixmap, p.boundary.scale(scl), Colors.paragraph, 2);
            }
            // Section title boundaries (red)
            for (dp.section_titles) |st| {
                image_output.drawRect(ctx, pixmap, st.boundary.scale(scl), Colors.section_title, 2);
            }
        }

        // Save to file
        var path_buf: [512]u8 = undefined;
        const filename = if (dir_path.len > 0)
            try std.fmt.bufPrint(&path_buf, "{s}/{s}_page_{d}.png", .{ dir_path, file_prefix, page_num })
        else
            try std.fmt.bufPrint(&path_buf, "{s}_page_{d}.png", .{ file_prefix, page_num });
        try image_output.savePixmapAsPng(ctx, pixmap, filename);
        printStderr("  Saved {s}\n", .{filename});
    }

    printStderr("Done. {d} figures found across {d} pages.\n", .{ result.figures.len, result.debug_pages.len });
}

fn drawDashedRect(ctx: *c.fz_context, pixmap: *c.fz_pixmap, box: Box, color: Rgba, thickness: u32) void {
    const w: i32 = c.fz_pixmap_width(ctx, pixmap);
    const h: i32 = c.fz_pixmap_height(ctx, pixmap);
    const stride: usize = @intCast(c.fz_pixmap_stride(ctx, pixmap));
    const samples = c.fz_pixmap_samples(ctx, pixmap);

    const x1: i32 = @intFromFloat(@round(box.x1));
    const y1: i32 = @intFromFloat(@round(box.y1));
    const x2: i32 = @intFromFloat(@round(box.x2));
    const y2: i32 = @intFromFloat(@round(box.y2));
    const t: i32 = @intCast(thickness);

    const dash_len: i32 = 8;
    const gap_len: i32 = 4;

    // Top edge
    drawDashedHLine(samples, stride, x1, x2, y1, w, h, color, t, dash_len, gap_len);
    // Bottom edge
    drawDashedHLine(samples, stride, x1, x2, y2 - 1, w, h, color, t, dash_len, gap_len);
    // Left edge
    drawDashedVLine(samples, stride, x1, y1, y2, w, h, color, t, dash_len, gap_len);
    // Right edge
    drawDashedVLine(samples, stride, x2 - 1, y1, y2, w, h, color, t, dash_len, gap_len);
}

fn drawDashedHLine(
    samples: [*]u8, stride: usize,
    x1: i32, x2: i32, y: i32,
    width: i32, height: i32,
    color: Rgba, thickness: i32,
    dash_len: i32, gap_len: i32,
) void {
    if (y < 0 or y >= height) return;
    const sx = @max(0, x1);
    const ex = @min(x2, width);
    var x: i32 = sx;
    var in_dash = true;
    var seg_remaining: i32 = dash_len;
    while (x < ex) : (x += 1) {
        if (seg_remaining == 0) {
            in_dash = !in_dash;
            seg_remaining = if (in_dash) dash_len else gap_len;
        }
        if (in_dash) {
            var dy: i32 = 0;
            while (dy < thickness) : (dy += 1) {
                const py = y + dy;
                if (py < 0 or py >= height) continue;
                const idx = @as(usize, @intCast(py)) * stride + @as(usize, @intCast(x)) * 4;
                samples[idx] = color.r;
                samples[idx + 1] = color.g;
                samples[idx + 2] = color.b;
                samples[idx + 3] = color.a;
            }
        }
        seg_remaining -= 1;
    }
}

fn drawDashedVLine(
    samples: [*]u8, stride: usize,
    x: i32, y1: i32, y2: i32,
    width: i32, height: i32,
    color: Rgba, thickness: i32,
    dash_len: i32, gap_len: i32,
) void {
    if (x < 0 or x >= width) return;
    const sy = @max(0, y1);
    const ey = @min(y2, height);
    var y: i32 = sy;
    var in_dash = true;
    var seg_remaining: i32 = dash_len;
    while (y < ey) : (y += 1) {
        if (seg_remaining == 0) {
            in_dash = !in_dash;
            seg_remaining = if (in_dash) dash_len else gap_len;
        }
        if (in_dash) {
            var dx: i32 = 0;
            while (dx < thickness) : (dx += 1) {
                const px = x + dx;
                if (px < 0 or px >= width) continue;
                const idx = @as(usize, @intCast(y)) * stride + @as(usize, @intCast(px)) * 4;
                samples[idx] = color.r;
                samples[idx + 1] = color.g;
                samples[idx + 2] = color.b;
                samples[idx + 3] = color.a;
            }
        }
        seg_remaining -= 1;
    }
}

fn concatBoxes(allocator: std.mem.Allocator, text_groups: []const []const Paragraph, graphics: []const Box) ![]const Box {
    var count: usize = 0;
    for (text_groups) |group| {
        count += group.len;
    }
    count += graphics.len;

    var result = try allocator.alloc(Box, count);
    var idx: usize = 0;
    for (text_groups) |group| {
        for (group) |p| {
            result[idx] = p.boundary;
            idx += 1;
        }
    }
    for (graphics) |g| {
        result[idx] = g;
        idx += 1;
    }
    return result;
}

fn printUsage() void {
    std.debug.print(
        \\Usage: pdffigures2 visualize <input.pdf> [options]
        \\
        \\Options:
        \\  -s, --show-steps                  Show all intermediate steps
        \\  -g, --show-graphic-clustering     Show graphical elements found and how they were clustered
        \\  -x, --show-cleaned-figure-regions Shows figure regions after being post-processed using the
        \\                                      rasterized PDF at the given DPI
        \\  -e, --show-extractions            Show the bounding boxes of the text and graphics that were extracted
        \\  -r, --show-regions                Show the different regions the PDF was broken into
        \\  -c, --show-captions               Show the location of the captions
        \\  -t, --show-sections               Show the location of sections and paragraphs
        \\  -d, --display-dpi <dpi>           DPI to display figures at (default: 55)
        \\  -p, --pages <pages>               Pages to extract from (defaults to all), 1 is the first page
        \\  -o <prefix>                        Output filename prefix or directory (default: input stem)
        \\  -h, --help                         Show this help
        \\
        \\Layer colors (matching Scala VisualLogger):
        \\  Green          = Figure extraction / graphic elements
        \\  Blue           = Captions / paragraphs
        \\  Red            = Text lines / section titles / other text
        \\  Black          = Non-figure content / cleaned figure regions
        \\  Dark green     = Clustered graphic groups
        \\  Yellow         = Other/potential-figure text
        \\
    , .{});
}

fn printStderr(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}