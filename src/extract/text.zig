// Text extraction using MuPDF's fz_stext_page.
// Direct translation of TextExtractor.scala.
//
// MuPDF already structures text into blocks→lines→chars.
// We group chars into Word→Line→Paragraph matching the Scala output.

const std = @import("std");
const c = @import("../mupdf.zig");

const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Word = paragraph.Word;
const Line = paragraph.Line;
const Paragraph = paragraph.Paragraph;
const PageWithText = @import("../page.zig").PageWithText;

/// For vertical text, ensure the minimum width is fixed to this value.
const MinVerticalTextWidth: f64 = 2.0;

/// Min height for which to clip the height of text.
const MinHeightToClipText: f64 = 40.0;

/// Height to clip overly tall text to.
const HeightToClipTextTo: f64 = 10.0;

/// Minimum horizontal gap (as fraction of font size) to split characters into separate words.
/// Handles table data where PDF producers use absolute positioning instead of space characters.
const MinWordGapFraction: f64 = 2.0;
const MinWordGapAbsolute: f64 = 4.0;
const DefaultFontSizeForGap: f64 = 8.0;

/// Returns true if codepoint is a whitespace or control character.
/// Matches Java's Character.isWhitespace + Character.isISOControl,
/// which the Scala reference uses to split words.
fn isSeparator(codepoint: u21) bool {
    return switch (codepoint) {
        // ASCII control (including tab, newline, return)
        0x0000...0x001F => true,
        // DEL + C1 control chars
        0x007F...0x009F => true,
        // ASCII space
        ' ' => true,
        // Unicode whitespace (Java Character.isWhitespace)
        0x1680 => true, // OGHAM SPACE MARK
        0x2000...0x200A => true, // EN QUAD..HAIR SPACE
        0x2028 => true, // LINE SEPARATOR
        0x2029 => true, // PARAGRAPH SEPARATOR
        0x202F => true, // NARROW NO-BREAK SPACE
        0x205F => true, // MEDIUM MATHEMATICAL SPACE
        0x3000 => true, // IDEOGRAPHIC SPACE
        // Non-breaking spaces (Java Character.isSpaceChar)
        0x00A0 => true, // NO-BREAK SPACE
        else => false,
    };
}

/// Extract structured text from a MuPDF document.
/// Returns a list of PageWithText, one per page.
pub fn extractText(arena: std.mem.Allocator, ctx: *c.fz_context, doc: *c.fz_document) ![]PageWithText {
    const page_count: i32 = c.fz_count_pages(@ptrCast(ctx), @ptrCast(doc));
    var pages = std.ArrayList(PageWithText).empty;

    const stext_options = c.fz_stext_options{
        .flags = c.FZ_STEXT_PRESERVE_WHITESPACE | c.FZ_STEXT_MEDIABOX_CLIP,
        .scale = 1.0,
    };

    var page_num: i32 = 0;
    while (page_num < page_count) : (page_num += 1) {
        const stext_page = c.fz_new_stext_page_from_page_number(
            @ptrCast(ctx),
            @ptrCast(doc),
            page_num,
            &stext_options,
        );
        defer c.fz_drop_stext_page(@ptrCast(ctx), stext_page);

        // Build paragraphs from the structured text page
        var paragraphs = std.ArrayList(Paragraph).empty;
        var on_line: u32 = 0;

        var block: ?*c.fz_stext_block = @ptrCast(@alignCast(stext_page.*.first_block));
        while (block) |blk| : (block = @ptrCast(@alignCast(blk.*.next))) {
            if (blk.*.type != c.FZ_STEXT_BLOCK_TEXT) continue;

            var lines_in_block = std.ArrayList(Line).empty;

            var line: ?*c.fz_stext_line = @ptrCast(@alignCast(blk.*.u.t.first_line));
            while (line) |ln| : (line = @ptrCast(@alignCast(ln.*.next))) {
                const stext_line = ln.*;

                // Process vertical text lines too, but note the wmode
                if (stext_line.wmode != 0) {
                    // Vertical text — group chars into words with MinVerticalTextWidth handling
                }

                var words_in_line = std.ArrayList(Word).empty;

                // Group chars into words: split on space/control characters
                var string_buf: std.ArrayList(u8) = .empty;
                var min_x: f64 = std.math.floatMax(f64);
                var min_y: f64 = std.math.floatMax(f64);
                var max_x: f64 = -std.math.floatMax(f64);
                var max_y: f64 = -std.math.floatMax(f64);
                var word_font_name: ?[]const u8 = null;
                var word_font_size: ?f64 = null;

                var prev_char_max_x: ?f64 = null;

                var char_node: ?*c.fz_stext_char = @ptrCast(@alignCast(stext_line.first_char));
                while (char_node) |ch| : (char_node = @ptrCast(@alignCast(ch.*.next))) {
                    const codepoint: u21 = @intCast(ch.*.c);

                    // Compute character bounding box from quad
                    const q = ch.*.quad;
                    const char_min_x: f64 = @floatCast(@min(@min(q.ul.x, q.ur.x), @min(q.ll.x, q.lr.x)));
                    const char_min_y: f64 = @floatCast(@min(@min(q.ul.y, q.ur.y), @min(q.ll.y, q.lr.y)));
                    const char_max_x: f64 = @floatCast(@max(@max(q.ul.x, q.ur.x), @max(q.ll.x, q.lr.x)));
                    const char_max_y: f64 = @floatCast(@max(@max(q.ul.y, q.ur.y), @max(q.ll.y, q.lr.y)));

                    // Gap-based word splitting for table data with absolute positioning
                    if (string_buf.items.len > 0 and !isSeparator(codepoint)) {
                        if (prev_char_max_x) |prev_x| {
                            const gap = char_min_x - prev_x;
                            if (gap > 0) {
                                const fs = word_font_size orelse DefaultFontSizeForGap;
                                const threshold = @max(fs * MinWordGapFraction, MinWordGapAbsolute);
                                if (gap > threshold) {
                                    const word = try finishWord(
                                        arena,
                                        string_buf.items,
                                        min_x, min_y, max_x, max_y,
                                        stext_line.wmode != 0,
                                        word_font_name,
                                        word_font_size,
                                    );
                                    try words_in_line.append(arena, word);
                                    string_buf.clearAndFree(arena);
                                    string_buf = .empty;
                                    min_x = std.math.floatMax(f64);
                                    min_y = std.math.floatMax(f64);
                                    max_x = -std.math.floatMax(f64);
                                    max_y = -std.math.floatMax(f64);
                                    word_font_name = null;
                                    word_font_size = null;
                                }
                            }
                        }
                    }

                    // Check if this is a separator character
                    if (isSeparator(codepoint)) {
                        // Finish current word
                        if (string_buf.items.len > 0) {
                            const word = try finishWord(
                                arena,
                                string_buf.items,
                                min_x, min_y, max_x, max_y,
                                stext_line.wmode != 0,
                                word_font_name,
                                word_font_size,
                            );
                            try words_in_line.append(arena, word);
                            string_buf.clearAndFree(arena);
                            string_buf = .empty;
                            min_x = std.math.floatMax(f64);
                            min_y = std.math.floatMax(f64);
                            max_x = -std.math.floatMax(f64);
                            max_y = -std.math.floatMax(f64);
                            word_font_name = null;
                            word_font_size = null;
                        }
                    } else {
                        // Add char to current word
                        var utf8_buf: [4]u8 = undefined;
                        const utf8_len = std.unicode.utf8Encode(codepoint, &utf8_buf) catch 1;
                        try string_buf.appendSlice(arena, utf8_buf[0..utf8_len]);

                        // Capture font info from first char
                        if (string_buf.items.len == utf8_len) {
                            if (ch.*.font) |font| {
                                word_font_name = try arena.dupe(u8, std.mem.span(c.fz_font_name(ctx, font)));
                                word_font_size = @floatCast(ch.*.size);
                            }
                        }

                        // Clip height if abnormally large
                        const char_height = char_max_y - char_min_y;
                        const effective_min_y = if (char_height > MinHeightToClipText)
                            char_max_y - HeightToClipTextTo
                        else
                            char_min_y;

                        min_x = @min(min_x, char_min_x);
                        min_y = @min(min_y, effective_min_y);
                        max_x = @max(max_x, char_max_x);
                        max_y = @max(max_y, char_max_y);

                        prev_char_max_x = char_max_x;
                    }
                }

                // Finish last word in the line
                if (string_buf.items.len > 0) {
                    const word = try finishWord(
                        arena,
                        string_buf.items,
                        min_x, min_y, max_x, max_y,
                        stext_line.wmode != 0,
                        word_font_name,
                        word_font_size,
                    );
                    try words_in_line.append(arena, word);
                }
                string_buf.deinit(arena);

                // Create Line from words
                if (words_in_line.items.len > 0) {
                    var word_boxes = std.ArrayList(Box).empty;
                    for (words_in_line.items) |w| {
                        try word_boxes.append(arena, w.boundary);
                    }
                    const line_box = Box.container(word_boxes.items);
                    const new_line = Line{
                        .words = try arena.dupe(Word, words_in_line.items),
                        .boundary = line_box,
                        .line_number = on_line,
                    };
                    try lines_in_block.append(arena, new_line);
                    on_line += 1;
                }
            }

            // Create Paragraph from lines
            if (lines_in_block.items.len > 0) {
                const lines_slice = try arena.dupe(Line, lines_in_block.items);
                const para = Paragraph.init(lines_slice);
                try paragraphs.append(arena, para);
            }
        }

        const paras_slice = try arena.dupe(Paragraph, paragraphs.items);
        try pages.append(arena, PageWithText.init(@intCast(page_num), paras_slice));
    }

    return pages.items;
}

/// Finish building a Word from accumulated text and position data.
fn finishWord(
    arena: std.mem.Allocator,
    text: []const u8,
    min_x: f64,
    min_y: f64,
    max_x: f64,
    max_y: f64,
    is_vertical: bool,
    font_name: ?[]const u8,
    font_size: ?f64,
) !Word {
    const text_copy = try arena.dupe(u8, text);

    const boundary = if (is_vertical and min_x == max_x)
        Box.init(min_x - MinVerticalTextWidth, min_y, max_x, max_y)
    else if (min_x <= max_x and min_y <= max_y)
        Box.init(min_x, min_y, max_x, max_y)
    else
        Box.init(0, 0, 1, 1); // fallback for degenerate case

    return Word{
        .text = text_copy,
        .boundary = boundary,
        .font_name = if (font_name) |n| try arena.dupe(u8, n) else null,
        .font_size = font_size,
    };
}

test {
    _ = c;
}