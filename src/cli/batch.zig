// Batch CLI: multi-threaded batch processing of PDF directories.
// Direct translation of FigureExtractorBatchCli.scala.

const std = @import("std");
const c = @import("../mupdf.zig");
const extractor = @import("../extractor.zig");
const Figure = @import("../figure.zig").Figure;
const Caption = @import("../figure.zig").Caption;
const RasterizedFigure = @import("../figure.zig").RasterizedFigure;
const SavedFigure = @import("../figure.zig").SavedFigure;
const json = @import("../json.zig");
const image_output = @import("../image_output.zig");

const AllowedFormats = [_][]const u8{ "png", "jpeg", "jpg", "pnm", "pam", "pbm", "pkm", "psd" };

const SharedState = struct {
    completed: std.atomic.Value(u32) = std.atomic.Value(u32).init(0),
    total: u32,
    total_files: std.atomic.Value(u32) = std.atomic.Value(u32).init(0),
    total_figures: std.atomic.Value(u32) = std.atomic.Value(u32).init(0),
    total_pages: std.atomic.Value(u32) = std.atomic.Value(u32).init(0),
    total_errors: std.atomic.Value(u32) = std.atomic.Value(u32).init(0),
};

const WorkerArg = struct {
    io: std.Io,
    allocator: std.mem.Allocator,
    files: []const []const u8,
    dpi: u32,
    figure_data_prefix: ?[]const u8,
    figure_image_prefix: ?[]const u8,
    full_text_prefix: ?[]const u8,
    figure_format: []const u8,
    save_regionless_captions: bool,
    ignore_errors: bool,
    quiet: bool,
    shared: *SharedState,
    thread_id: u32,
};

const FileResult = struct {
    figures: u32,
    pages: u32,
};

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: [][]const u8) !void {
    var input_paths: std.ArrayList([]const u8) = .empty;
    defer input_paths.deinit(allocator);

    var figure_data_prefix: ?[]const u8 = null;
    var figure_image_prefix: ?[]const u8 = null;
    var full_text_prefix: ?[]const u8 = null;
    var stats_path: ?[]const u8 = null;
    var dpi: u32 = 150;
    var threads: u32 = @intCast(@max(1, std.Thread.getCpuCount() catch 1));
    var ignore_errors = false;
    var quiet = false;
    var save_regionless_captions = false;
    var figure_format: []const u8 = "png";

    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            printUsage();
            return;
        } else if (std.mem.eql(u8, arg, "-d") or std.mem.eql(u8, arg, "--figure-data-prefix")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            figure_data_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-m") or std.mem.eql(u8, arg, "--figure-prefix")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            figure_image_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-g") or std.mem.eql(u8, arg, "--full-text-prefix")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            full_text_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-f") or std.mem.eql(u8, arg, "--figure-format")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            figure_format = args[i];
        } else if (std.mem.eql(u8, arg, "-s") or std.mem.eql(u8, arg, "--save-stats")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            stats_path = args[i];
        } else if (std.mem.eql(u8, arg, "-i") or std.mem.eql(u8, arg, "--dpi")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            dpi = try std.fmt.parseUnsigned(u32, args[i], 10);
        } else if (std.mem.eql(u8, arg, "-t") or std.mem.eql(u8, arg, "--threads")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            threads = try std.fmt.parseUnsigned(u32, args[i], 10);
            if (threads == 0) threads = @intCast(@max(1, std.Thread.getCpuCount() catch 1));
        } else if (std.mem.eql(u8, arg, "-e") or std.mem.eql(u8, arg, "--ignore-error")) {
            ignore_errors = true;
        } else if (std.mem.eql(u8, arg, "-q") or std.mem.eql(u8, arg, "--quiet")) {
            quiet = true;
        } else if (std.mem.eql(u8, arg, "-c") or std.mem.eql(u8, arg, "--save-regionless-captions")) {
            save_regionless_captions = true;
        } else if (arg[0] != '-') {
            try input_paths.append(allocator, arg);
        }
    }

    if (input_paths.items.len == 0) {
        printStderr("Error: no input paths specified\n", .{});
        printUsage();
        std.process.exit(1);
    }

    // Validate format
    var format_valid = false;
    for (AllowedFormats) |f| {
        if (std.ascii.eqlIgnoreCase(f, figure_format)) {
            format_valid = true;
            break;
        }
    }
    if (!format_valid) {
        printStderr("Error: unsupported format '{s}'. Allowed: {s}\n", .{ figure_format, "png, jpeg, pnm, pam, pbm, pkm, psd" });
        std.process.exit(1);
    }

    // Collect all PDF files from input paths (files and directories)
    var pdf_files: std.ArrayList([]const u8) = .empty;
    defer pdf_files.deinit(allocator);

    for (input_paths.items) |path| {
        const dir = std.Io.Dir.cwd().openDir(io, path, .{}) catch null;
        if (dir) |d| {
            d.close(io);
            // Directory: walk for PDFs
            try walkPdfs(io, allocator, &pdf_files, path);
        } else if (std.mem.endsWith(u8, path, ".pdf")) {
            try pdf_files.append(allocator, try allocator.dupe(u8, path));
        } else {
            printStderr("Warning: skipping non-PDF file: {s}\n", .{path});
        }
    }

    if (pdf_files.items.len == 0) {
        printStderr("Error: no PDF files found\n", .{});
        std.process.exit(1);
    }

    if (!quiet) {
        printStderr("Found {d} PDF files. Processing with {d} threads at {d} DPI...\n", .{ pdf_files.items.len, threads, dpi });
    }

    const num_threads = @min(threads, @as(u32, @intCast(pdf_files.items.len)));
    const chunk_size = (pdf_files.items.len + num_threads - 1) / num_threads;

    var shared = SharedState{ .total = @intCast(pdf_files.items.len) };

    var thread_pool = try allocator.alloc(std.Thread, num_threads);
    defer allocator.free(thread_pool);

    var worker_args = try allocator.alloc(WorkerArg, num_threads);
    defer allocator.free(worker_args);

    for (0..num_threads) |t| {
        const start = t * chunk_size;
        const end = @min(start + chunk_size, pdf_files.items.len);
        if (start >= end) continue;

        worker_args[t] = .{
            .io = io,
            .allocator = allocator,
            .files = pdf_files.items[start..end],
            .dpi = dpi,
            .figure_data_prefix = figure_data_prefix,
            .figure_image_prefix = figure_image_prefix,
            .full_text_prefix = full_text_prefix,
            .figure_format = figure_format,
            .save_regionless_captions = save_regionless_captions,
            .ignore_errors = ignore_errors,
            .quiet = quiet,
            .shared = &shared,
            .thread_id = @intCast(t),
        };

        thread_pool[t] = try std.Thread.spawn(.{}, workerThread, .{&worker_args[t]});
    }

    for (thread_pool[0..num_threads]) |th| {
        th.join();
    }

    const tf = shared.total_files.load(.acquire);
    const tfig = shared.total_figures.load(.acquire);
    const tp = shared.total_pages.load(.acquire);
    const terr = shared.total_errors.load(.acquire);
    printStderr("\n{d}/{d} files processed, {d} figures found, {d} errors\n", .{ tf, pdf_files.items.len, tfig, terr });

    if (stats_path) |sp| {
        var stats_buf: [256]u8 = undefined;
        const stats_json = try std.fmt.bufPrint(&stats_buf,
            \\{{"total_files":{d},"total_figures":{d},"total_pages":{d},"errors":{d}}}
        , .{ tf, tfig, tp, terr });
        try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = sp, .data = stats_json });
        printStderr("Stats saved to {s}\n", .{sp});
    }
}

fn walkPdfs(io: std.Io, allocator: std.mem.Allocator, pdf_files: *std.ArrayList([]const u8), dir_path: []const u8) !void {
    const dir = try std.Io.Dir.cwd().openDir(io, dir_path, .{ .iterate = true });
    defer dir.close(io);

    var iter = std.Io.Dir.iterate(dir);
    var entry = try iter.next(io);
    while (entry) |e| : (entry = try iter.next(io)) {
        const full_path = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ dir_path, e.name });
        if (e.kind == .file and std.mem.endsWith(u8, e.name, ".pdf")) {
            try pdf_files.append(allocator, full_path);
        } else if (e.kind == .directory) {
            try walkPdfs(io, allocator, pdf_files, full_path);
        } else {
            allocator.free(full_path);
        }
    }
}

fn workerThread(arg: *WorkerArg) void {
    const allocator = arg.allocator;

    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) @panic("Failed to create MuPDF context in worker thread");
    defer c.fz_drop_context(ctx);
    c.fz_register_document_handlers(ctx);

    for (arg.files) |pdf_path| {
        const result = processFile(ctx, allocator, pdf_path, arg);
        const completed = arg.shared.completed.fetchAdd(1, .monotonic) + 1;
        if (result) |r| {
            _ = arg.shared.total_files.fetchAdd(1, .monotonic);
            _ = arg.shared.total_figures.fetchAdd(r.figures, .monotonic);
            _ = arg.shared.total_pages.fetchAdd(r.pages, .monotonic);
            if (!arg.quiet) {
                std.debug.print("[{d}/{d} t{d}] {s}: OK ({d} figures)\n", .{ completed, arg.shared.total, arg.thread_id, std.fs.path.basename(pdf_path), r.figures });
            }
        } else |err| {
            _ = arg.shared.total_errors.fetchAdd(1, .monotonic);
            std.debug.print("[{d}/{d} t{d}] {s}: {}\n", .{ completed, arg.shared.total, arg.thread_id, std.fs.path.basename(pdf_path), err });
        }
    }
}

fn figTypeToString(fig_type: @import("../figure.zig").FigureType) []const u8 {
    return @tagName(fig_type);
}

fn processFile(
    ctx: *c.fz_context,
    allocator: std.mem.Allocator,
    pdf_path: []const u8,
    arg: *WorkerArg,
) !FileResult {
    const doc = c.fz_open_document(ctx, @ptrCast(pdf_path));
    if (doc == null) return error.OpenFailed;
    defer c.fz_drop_document(ctx, doc);

    const page_count = c.fz_count_pages(ctx, doc);
    const config = extractor.ExtractorConfig{ .dpi = arg.dpi };

    const stem = std.fs.path.basename(pdf_path);
    const stem_no_ext = if (std.mem.endsWith(u8, stem, ".pdf")) stem[0 .. stem.len - 4] else stem;

    // Full text prefix path (-g)
    if (arg.full_text_prefix) |text_prefix| {
        const figures = extractor.getFigures(allocator, ctx, doc, config) catch |err| {
            if (arg.ignore_errors) return .{ .figures = 0, .pages = 0 };
            return err;
        };

        var json_buf: [1024]u8 = undefined;
        const json_path = try std.fmt.bufPrint(&json_buf, "{s}{s}.json", .{ text_prefix, stem_no_ext });

        if (arg.figure_image_prefix) |img_prefix| {
            const rasterized = extractor.getRasterizedFigures(allocator, ctx, doc, config) catch |err| {
                if (arg.ignore_errors) return .{ .figures = @intCast(figures.figures.len), .pages = @intCast(page_count) };
                return err;
            };
            const saved = try saveFigures(allocator, ctx, img_prefix, stem_no_ext, arg.figure_format, rasterized.figures);
            const jstr = try json.savedFiguresToJson(allocator, saved);
            try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
            return .{ .figures = @intCast(rasterized.figures.len), .pages = @intCast(page_count) };
        }

        const jstr = try json.figuresToJson(allocator, figures.figures);
        try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
        return .{ .figures = @intCast(figures.figures.len), .pages = @intCast(page_count) };
    }

    // Figure image prefix (-m)
    if (arg.figure_image_prefix) |img_prefix| {
        const rasterized = extractor.getRasterizedFigures(allocator, ctx, doc, config) catch |err| {
            if (arg.ignore_errors) return .{ .figures = 0, .pages = 0 };
            return err;
        };

        const saved = try saveFigures(allocator, ctx, img_prefix, stem_no_ext, arg.figure_format, rasterized.figures);

        if (arg.figure_data_prefix) |data_prefix| {
            var json_buf: [1024]u8 = undefined;
            const json_path = try std.fmt.bufPrint(&json_buf, "{s}{s}.json", .{ data_prefix, stem_no_ext });

            const caps = if (arg.save_regionless_captions) rasterized.failed_captions else &.{};
            if (caps.len > 0) {
                // Object format with regionless-captions
                var figs = std.ArrayList(Figure).empty;
                defer figs.deinit(allocator);
                for (saved) |sf| {
                    try figs.append(allocator, Figure{
                        .name = sf.name,
                        .fig_type = sf.fig_type,
                        .page = sf.page,
                        .caption = sf.caption,
                        .image_text = sf.image_text,
                        .caption_boundary = sf.caption_boundary,
                        .region_boundary = sf.region_boundary,
                    });
                }
                const jstr = try json.figuresDocumentToJson(allocator, figs.items, caps);
                try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
            } else {
                const jstr = try json.savedFiguresToJson(allocator, saved);
                try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
            }
        }

        return .{ .figures = @intCast(rasterized.figures.len), .pages = @intCast(page_count) };
    }

    // Figure data prefix only (-d)
    const figures = extractor.getFigures(allocator, ctx, doc, config) catch |err| {
        if (arg.ignore_errors) return .{ .figures = 0, .pages = 0 };
        return err;
    };

    if (arg.figure_data_prefix) |data_prefix| {
        var json_buf: [1024]u8 = undefined;
        const json_path = try std.fmt.bufPrint(&json_buf, "{s}{s}.json", .{ data_prefix, stem_no_ext });
        const caps = if (arg.save_regionless_captions) figures.failed_captions else &.{};
        if (caps.len > 0) {
            const jstr = try json.figuresDocumentToJson(allocator, figures.figures, caps);
            try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
        } else {
            const jstr = try json.figuresToJson(allocator, figures.figures);
            try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
        }
    }

    return .{ .figures = @intCast(figures.figures.len), .pages = @intCast(page_count) };
}

fn saveFigures(
    allocator: std.mem.Allocator,
    ctx: *c.fz_context,
    prefix: []const u8,
    stem_no_ext: []const u8,
    format: []const u8,
    figures: []const RasterizedFigure,
) ![]const SavedFigure {
    var name_counts = std.StringHashMap(u32).init(allocator);
    defer name_counts.deinit();

    var saved = std.ArrayList(SavedFigure).empty;

    for (figures) |rf| {
        const fig_name = try std.fmt.allocPrint(allocator, "{s}{s}", .{ figTypeToString(rf.figure.fig_type), rf.figure.name });
        defer allocator.free(fig_name);

        const count_entry = try name_counts.getOrPutValue(fig_name, 1);
        const id = count_entry.value_ptr.*;
        count_entry.value_ptr.* += 1;

        const render_url = try std.fmt.allocPrint(allocator, "{s}-{s}-{d}.{s}", .{ stem_no_ext, fig_name, id, format });

        var path_buf: [512]u8 = undefined;
        const img_path = try std.fmt.bufPrint(&path_buf, "{s}{s}", .{ prefix, render_url });
        try image_output.saveRgbDataAsFormat(ctx, rf.image_data, rf.image_width, rf.image_height, img_path, format);

        try saved.append(allocator, SavedFigure.fromRasterized(rf, render_url));
    }

    return saved.items;
}

fn printUsage() void {
    std.debug.print(
        \\Usage: pdffigures2 batch <input...> [options]
        \\
        \\  <input...>  PDF files or directories containing PDFs
        \\
        \\Options:
        \\  -i, --dpi <dpi>                    DPI to save the figures in (default: 150)
        \\  -s, --save-stats <file>            Save the errors and timing information to the given file in JSON format
        \\  -t, --threads <N>                  Number of threads to use, 0 means use system default
        \\  -e, --ignore-error                 Don't stop on errors
        \\  -q, --quiet                        Switches logging to errors only
        \\  -d, --figure-data-prefix <prefix>  Save JSON figure data to '<prefix><stem>.json'
        \\  -c, --save-regionless-captions     Include captions for which no figure regions were found in the JSON data
        \\  -g, --full-text-prefix <prefix>    Save the document and figures into '<prefix><stem>.json'
        \\  -m, --figure-prefix <prefix>       Save figures as '<prefix><stem>-<Type><Name>-<id>.<fmt>'
        \\  -f, --figure-format <format>       Format to save figures in (default: png)
        \\  -h, --help                         Show this help
        \\
        \\Supported formats: png, jpeg, pnm, pam, pbm, pkm, psd
        \\
    , .{});
}

fn printStderr(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}