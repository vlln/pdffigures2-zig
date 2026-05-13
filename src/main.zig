const std = @import("std");
const c = @import("mupdf.zig");
const extractor = @import("extractor.zig");
const cli_batch = @import("cli/batch.zig");
const cli_visualize = @import("cli/visualize.zig");
test { _ = @import("e2e_test.zig"); }

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var args_iter = std.process.Args.Iterator.init(init.minimal.args);
    const prog_name = args_iter.next() orelse "pdffigures2";
    const first_arg = args_iter.next();

    if (first_arg == null) {
        try printStderr(io, "Usage: {s} <pdf-file>       Extract figures from a single PDF\n", .{prog_name});
        try printStderr(io, "       {s} batch <args>     Batch process PDFs\n", .{prog_name});
        try printStderr(io, "       {s} visualize <args> Visual debug with annotated PNGs\n", .{prog_name});
        try printStderr(io, "       {s} dump <pdf> [pg]  Dump raw extraction data\n", .{prog_name});
        std.process.exit(1);
    }

    const cmd = first_arg.?;

    if (std.mem.eql(u8, cmd, "batch")) {
        var batch_args: std.ArrayList([]const u8) = .empty;
        while (args_iter.next()) |a| {
            try batch_args.append(init.arena.allocator(), a);
        }
        return cli_batch.run(io, init.arena.allocator(), batch_args.items);
    } else if (std.mem.eql(u8, cmd, "visualize")) {
        var viz_args: std.ArrayList([]const u8) = .empty;
        while (args_iter.next()) |a| {
            try viz_args.append(init.arena.allocator(), a);
        }
        return cli_visualize.run(io, init.arena.allocator(), viz_args.items);
    } else if (std.mem.eql(u8, cmd, "dump")) {
        return dumpDebug(io, init.arena.allocator(), &args_iter);
    } else if (std.mem.eql(u8, cmd, "-h") or std.mem.eql(u8, cmd, "--help")) {
        try printStderr(io, "Usage: {s} <pdf-file>       Extract figures from a single PDF\n", .{prog_name});
        try printStderr(io, "       {s} batch -h         Batch processing help\n", .{prog_name});
        try printStderr(io, "       {s} visualize -h     Visualization help\n", .{prog_name});
        return;
    }

    // Default: single-file mode (first arg is the PDF path)
    const pdf_path = cmd;
    const extra = args_iter.next();
    if (extra) |ext| {
        if (std.mem.eql(u8, ext, "-h") or std.mem.eql(u8, ext, "--help")) {
            try printStderr(io, "Usage: {s} <pdf-file>\n", .{prog_name});
            try printStderr(io, "  Extracts figures from a PDF and outputs JSON to stdout.\n", .{});
            return;
        }
    }

    // Create MuPDF context
    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) {
        try printStderr(io, "Error: failed to create MuPDF context\n", .{});
        std.process.exit(1);
    }
    defer c.fz_drop_context(ctx);

    c.fz_register_document_handlers(ctx);

    // Open document
    const doc = c.fz_open_document(ctx, pdf_path);
    if (doc == null) {
        try printStderr(io, "Error: failed to open {s}\n", .{pdf_path});
        std.process.exit(1);
    }
    defer c.fz_drop_document(ctx, doc);

    const page_count = c.fz_count_pages(ctx, doc);
    try printStderr(io, "Pages: {d}\n", .{page_count});

    // Run extraction
    const config = extractor.ExtractorConfig{};
    const json_str = extractor.getFiguresJson(init.arena.allocator(), ctx, doc, config) catch |err| {
        try printStderr(io, "Error: extraction failed: {}\n", .{err});
        std.process.exit(1);
    };

    // Output JSON
    try printStdout(io, "{s}\n", .{json_str});
}

fn dumpDebug(io: std.Io, allocator: std.mem.Allocator, args_iter: *std.process.Args.Iterator) !void {
    const pdf_path = args_iter.next() orelse {
        try printStderr(io, "Usage: pdffigures2 dump <pdf> [page]\n", .{});
        std.process.exit(1);
    };
    const page_str = args_iter.next();
    const target_page: ?u32 = if (page_str) |s|
        std.fmt.parseInt(u32, s, 10) catch null
    else
        null;

    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) {
        try printStderr(io, "Error: failed to create MuPDF context\n", .{});
        std.process.exit(1);
    }
    defer c.fz_drop_context(ctx);
    c.fz_register_document_handlers(ctx);

    const doc = c.fz_open_document(ctx, pdf_path);
    if (doc == null) {
        try printStderr(io, "Error: failed to open {s}\n", .{pdf_path});
        std.process.exit(1);
    }
    defer c.fz_drop_document(ctx, doc);

    const config = extractor.ExtractorConfig{};
    const result = extractor.getFiguresWithDebugData(allocator, ctx, doc, config) catch |err| {
        try printStderr(io, "Error: {}\n", .{err});
        std.process.exit(1);
    };

    var stdout_buf: [4096]u8 = undefined;
    var stdout_w: std.Io.File.Writer = .init(.stdout(), io, &stdout_buf);

    try stdout_w.interface.print("{{\n", .{});
    try stdout_w.interface.print("  \"pages\": [\n", .{});

    for (result.debug_pages, 0..) |dp, pi| {
        if (target_page) |tp| {
            if (dp.page_number != tp) continue;
        }

        try stdout_w.interface.print("    {{\n", .{});
        try stdout_w.interface.print("      \"page\": {d},\n", .{dp.page_number});

        // Body text paragraphs
        try stdout_w.interface.print("      \"body_text\": [\n", .{});
        for (dp.body_text, 0..) |p, i| {
            try stdout_w.interface.print("        {{\"box\":[{d:.1},{d:.1},{d:.1},{d:.1}],\"lines\":{d},\"text\":\"", .{
                p.boundary.x1, p.boundary.y1, p.boundary.x2, p.boundary.y2, p.lines.len,
            });
            for (p.lines) |l| {
                for (l.words) |w| {
                    // Escape quotes and backslashes
                    const escaped = w.text;
                    try stdout_w.interface.print("{s} ", .{escaped});
                }
            }
            if (i < dp.body_text.len - 1) {
                try stdout_w.interface.print("\"}},\n", .{});
            } else {
                try stdout_w.interface.print("\"}}\n", .{});
            }
        }
        try stdout_w.interface.print("      ],\n", .{});

        // Other text paragraphs
        try stdout_w.interface.print("      \"other_text\": [\n", .{});
        for (dp.other_text, 0..) |p, i| {
            try stdout_w.interface.print("        {{\"box\":[{d:.1},{d:.1},{d:.1},{d:.1}],\"lines\":{d},\"text\":\"", .{
                p.boundary.x1, p.boundary.y1, p.boundary.x2, p.boundary.y2, p.lines.len,
            });
            for (p.lines) |l| {
                for (l.words) |w| {
                    try stdout_w.interface.print("{s} ", .{w.text});
                }
            }
            if (i < dp.other_text.len - 1) {
                try stdout_w.interface.print("\"}},\n", .{});
            } else {
                try stdout_w.interface.print("\"}}\n", .{});
            }
        }
        try stdout_w.interface.print("      ],\n", .{});

        // Graphics
        try stdout_w.interface.print("      \"graphics\": [\n", .{});
        for (dp.graphics, 0..) |g, i| {
            if (i < dp.graphics.len - 1) {
                try stdout_w.interface.print("        [{d:.1},{d:.1},{d:.1},{d:.1}],\n", .{g.x1, g.y1, g.x2, g.y2});
            } else {
                try stdout_w.interface.print("        [{d:.1},{d:.1},{d:.1},{d:.1}]\n", .{g.x1, g.y1, g.x2, g.y2});
            }
        }
        try stdout_w.interface.print("      ],\n", .{});

        // Non-figure graphics
        try stdout_w.interface.print("      \"non_figure_graphics\": [\n", .{});
        for (dp.non_figure_graphics, 0..) |g, i| {
            if (i < dp.non_figure_graphics.len - 1) {
                try stdout_w.interface.print("        [{d:.1},{d:.1},{d:.1},{d:.1}],\n", .{g.x1, g.y1, g.x2, g.y2});
            } else {
                try stdout_w.interface.print("        [{d:.1},{d:.1},{d:.1},{d:.1}]\n", .{g.x1, g.y1, g.x2, g.y2});
            }
        }
        try stdout_w.interface.print("      ],\n", .{});

        // Captions
        try stdout_w.interface.print("      \"captions\": [\n", .{});
        for (dp.captions, 0..) |cap, i| {
            const cb = cap.boundary();
            try stdout_w.interface.print("        {{\"name\":\"{s}\",\"type\":\"{s}\",\"box\":[{d:.1},{d:.1},{d:.1},{d:.1}]}}", .{
                cap.name, @tagName(cap.fig_type), cb.x1, cb.y1, cb.x2, cb.y2,
            });
            if (i < dp.captions.len - 1) try stdout_w.interface.print(",\n", .{}) else try stdout_w.interface.print("\n", .{});
        }
        try stdout_w.interface.print("      ],\n", .{});

        // Figures found
        try stdout_w.interface.print("      \"figures\": [\n", .{});
        for (dp.figures, 0..) |fig, i| {
            try stdout_w.interface.print("        {{\"name\":\"{s}\",\"caption\":[{d:.1},{d:.1},{d:.1},{d:.1}],\"region\":[{d:.1},{d:.1},{d:.1},{d:.1}]}}", .{
                fig.name,
                fig.caption_boundary.x1, fig.caption_boundary.y1, fig.caption_boundary.x2, fig.caption_boundary.y2,
                fig.region_boundary.x1, fig.region_boundary.y1, fig.region_boundary.x2, fig.region_boundary.y2,
            });
            if (i < dp.figures.len - 1) try stdout_w.interface.print(",\n", .{}) else try stdout_w.interface.print("\n", .{});
        }
        try stdout_w.interface.print("      ]\n", .{});

        try stdout_w.interface.print("    }}", .{});
        if (pi < result.debug_pages.len - 1) try stdout_w.interface.print(",\n", .{}) else try stdout_w.interface.print("\n", .{});
    }

    try stdout_w.interface.print("  ]\n", .{});
    try stdout_w.interface.print("}}\n", .{});
    try stdout_w.flush();
}

fn printStderr(io: std.Io, comptime fmt: []const u8, args: anytype) !void {
    var buf: [256]u8 = undefined;
    var w: std.Io.File.Writer = .init(.stderr(), io, &buf);
    try w.interface.print(fmt, args);
    try w.flush();
}

fn printStdout(io: std.Io, comptime fmt: []const u8, args: anytype) !void {
    var buf: [4096]u8 = undefined;
    var w: std.Io.File.Writer = .init(.stdout(), io, &buf);
    try w.interface.print(fmt, args);
    try w.flush();
}