// Batch CLI: multi-threaded batch processing of PDF directories.
// Direct translation of FigureExtractorBatchCli.scala.

const std = @import("std");
const c = @import("../mupdf.zig");
const extractor = @import("../extractor.zig");
const Figure = @import("../figure.zig").Figure;
const json = @import("../json.zig");

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
    ignore_errors: bool,
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
    var stats_path: ?[]const u8 = null;
    var dpi: u32 = 150;
    var threads: u32 = @intCast(@max(1, std.Thread.getCpuCount() catch 1));
    var ignore_errors = false;

    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            printUsage();
            return;
        } else if (std.mem.eql(u8, arg, "-d")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            figure_data_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-m")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            figure_image_prefix = args[i];
        } else if (std.mem.eql(u8, arg, "-s")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            stats_path = args[i];
        } else if (std.mem.eql(u8, arg, "-i")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            dpi = try std.fmt.parseUnsigned(u32, args[i], 10);
        } else if (std.mem.eql(u8, arg, "-t")) {
            i += 1;
            if (i >= args.len) return error.MissingArgument;
            threads = try std.fmt.parseUnsigned(u32, args[i], 10);
        } else if (std.mem.eql(u8, arg, "-e")) {
            ignore_errors = true;
        } else if (arg[0] != '-') {
            try input_paths.append(allocator, arg);
        }
    }

    if (input_paths.items.len == 0) {
        printStderr("Error: no input paths specified\n", .{});
        printUsage();
        std.process.exit(1);
    }

    // Collect all PDF files from input paths (files only, no directory walking)
    var pdf_files: std.ArrayList([]const u8) = .empty;
    defer pdf_files.deinit(allocator);

    for (input_paths.items) |path| {
        if (std.mem.endsWith(u8, path, ".pdf")) {
            try pdf_files.append(allocator, try allocator.dupe(u8, path));
        } else {
            printStderr("Warning: skipping non-PDF file: {s}\n", .{path});
        }
    }

    if (pdf_files.items.len == 0) {
        printStderr("Error: no PDF files found\n", .{});
        std.process.exit(1);
    }

    printStderr("Found {d} PDF files. Processing with {d} threads at {d} DPI...\n", .{ pdf_files.items.len, threads, dpi });

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
            .ignore_errors = ignore_errors,
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
            std.debug.print("[{d}/{d} t{d}] {s}: OK ({d} figures)\n", .{ completed, arg.shared.total, arg.thread_id, std.fs.path.basename(pdf_path), r.figures });
        } else |err| {
            _ = arg.shared.total_errors.fetchAdd(1, .monotonic);
            std.debug.print("[{d}/{d} t{d}] {s}: {}\n", .{ completed, arg.shared.total, arg.thread_id, std.fs.path.basename(pdf_path), err });
        }
    }
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

    const figures = extractor.getFigures(allocator, ctx, doc, config) catch |err| {
        if (arg.ignore_errors) return .{ .figures = 0, .pages = 0 };
        return err;
    };

    if (arg.figure_data_prefix) |data_prefix| {
        const stem = std.fs.path.basename(pdf_path);
        const stem_no_ext = if (std.mem.endsWith(u8, stem, ".pdf")) stem[0 .. stem.len - 4] else stem;
        var json_buf: [1024]u8 = undefined;
        const json_path = try std.fmt.bufPrint(&json_buf, "{s}{s}.json", .{ data_prefix, stem_no_ext });
        const jstr = try json.figuresDocumentToJson(allocator, figures.figures, figures.failed_captions);
        try std.Io.Dir.cwd().writeFile(arg.io, .{ .sub_path = json_path, .data = jstr });
    }

    return .{ .figures = @intCast(figures.figures.len), .pages = @intCast(page_count) };
}

fn printUsage() void {
    std.debug.print(
        \\Usage: pdffigures2 batch <input...> [options]
        \\
        \\  <input...>  PDF files to process
        \\
        \\Options:
        \\  -d <prefix>  Write per-file figure data JSON to <prefix><stem>.json
        \\  -s <file>    Write aggregate statistics JSON
        \\  -i <dpi>     Render DPI (default: 150)
        \\  -t <N>       Thread count (default: CPU count)
        \\  -e           Ignore errors, continue processing
        \\  -h           Show this help
        \\
    , .{});
}

fn printStderr(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}