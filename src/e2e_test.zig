const std = @import("std");
const c = @import("mupdf.zig");
const extractor = @import("extractor.zig");

test "e2e paper.pdf" {
    const allocator = std.testing.allocator;

    const pdf_path = "/home/vlln/agent-space/repro-test/010/repro-data/01_plan/resources/paper.pdf";

    // Create MuPDF context
    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) return error.MupdfContextFailed;
    defer c.fz_drop_context(ctx);

    c.fz_register_document_handlers(ctx);

    const doc = c.fz_open_document(ctx, pdf_path);
    if (doc == null) {
        std.debug.print("Skipping e2e: PDF not found at {s}\n", .{pdf_path});
        return;
    }
    defer c.fz_drop_document(ctx, doc);

    const page_count = c.fz_count_pages(ctx, doc);
    std.debug.print("paper.pdf: {d} pages\n", .{page_count});

    const config = extractor.ExtractorConfig{};
    const json_str = extractor.getFiguresJson(allocator, ctx, doc, config) catch |err| {
        std.debug.print("Extraction failed: {}\n", .{err});
        return err;
    };

    std.debug.print("paper.pdf: Extracted JSON ({d} bytes)\n", .{json_str.len});
}

test "e2e paper008.pdf" {
    const allocator = std.testing.allocator;

    const pdf_path = "/home/vlln/agent-space/repro-test/008/repro-data/01_plan/resources/paper.pdf";

    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) return error.MupdfContextFailed;
    defer c.fz_drop_context(ctx);

    c.fz_register_document_handlers(ctx);

    const doc = c.fz_open_document(ctx, pdf_path);
    if (doc == null) {
        std.debug.print("跳过: PDF 未找到 {s}\n", .{pdf_path});
        return;
    }
    defer c.fz_drop_document(ctx, doc);

    const page_count = c.fz_count_pages(ctx, doc);
    std.debug.print("\n=== paper008.pdf: {d} 页 ===\n", .{page_count});

    const config = extractor.ExtractorConfig{};
    const json_str = extractor.getFiguresJson(allocator, ctx, doc, config) catch |err| {
        std.debug.print("提取失败: {}\n", .{err});
        return err;
    };

    std.debug.print("JSON 输出 ({d} 字节):\n{s}\n", .{ json_str.len, json_str });
}

test "e2e MOESM1_ESM.pdf" {
    const allocator = std.testing.allocator;

    const pdf_path = "/home/vlln/agent-space/repro-test/010/repro-data/01_plan/resources/MOESM1_ESM.pdf";

    const ctx = c.fz_new_context(null, null, 256 << 20);
    if (ctx == null) return error.MupdfContextFailed;
    defer c.fz_drop_context(ctx);

    c.fz_register_document_handlers(ctx);

    const doc = c.fz_open_document(ctx, pdf_path);
    if (doc == null) {
        std.debug.print("Skipping e2e: PDF not found at {s}\n", .{pdf_path});
        return;
    }
    defer c.fz_drop_document(ctx, doc);

    const page_count = c.fz_count_pages(ctx, doc);
    std.debug.print("MOESM1_ESM.pdf: {d} pages\n", .{page_count});

    const config = extractor.ExtractorConfig{};
    const json_str = extractor.getFiguresJson(allocator, ctx, doc, config) catch |err| {
        std.debug.print("Extraction failed: {}\n", .{err});
        return err;
    };

    std.debug.print("MOESM1_ESM.pdf: Extracted JSON ({d} bytes)\n", .{json_str.len});
}