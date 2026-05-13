// Text hierarchy: Word → Line → Paragraph + TextSpan.
// Direct translation of Paragraph.scala.

const std = @import("std");
const box = @import("box.zig");
const Box = box.Box;

/// Span of text denoted by starting and ending line number, inclusive.
pub const TextSpan = struct {
    start: u32,
    end: u32,

    pub fn init(start: u32, end: u32) TextSpan {
        std.debug.assert(end >= start);
        return .{ .start = start, .end = end };
    }

    pub fn compare(self: TextSpan, other: TextSpan) std.math.Order {
        return std.math.order(self.start, other.start);
    }
};

/// A single word with its text, boundary, and character positions.
pub const Word = struct {
    text: []const u8,
    boundary: Box,
    // In MuPDF, each char has: codepoint (i32), quad (fz_quad), size (f64), font_name ([]const u8)
    // We store font_name and font_size per word for downstream use
    font_name: ?[]const u8,
    font_size: ?f64,
};

/// A line of words, with a line number and boundary box.
pub const Line = struct {
    words: []const Word,
    boundary: Box,
    line_number: u32,

    pub fn init(words: []const Word, line_number: u32) Line {
        var boundaries = std.ArrayList(Box).empty;
        defer boundaries.deinit(std.heap.page_allocator);
        for (words) |w| {
            boundaries.append(std.heap.page_allocator, w.boundary) catch unreachable;
        }
        return .{
            .words = words,
            .boundary = Box.container(boundaries.items),
            .line_number = line_number,
        };
    }

    pub fn text() []const u8 {
        // Returns all words joined by spaces - caller must free
        // For simple use, iterate words directly
        return "";
    }

    /// Check if this line is horizontal (no vertical text).
    pub fn isHorizontal(self: Line) bool {
        // In the original: words.flatMap(_.positions).forall(_.getDir == 0)
        // We don't have TextPosition, so check if all words have normal bounds
        return self.boundary.width() > self.boundary.height() or self.words.len == 1;
    }
};

/// A paragraph of lines, with a boundary box.
pub const Paragraph = struct {
    lines: []const Line,
    boundary: Box,

    pub fn init(lines: []const Line) Paragraph {
        std.debug.assert(lines.len > 0);
        var boundaries = std.ArrayList(Box).empty;
        defer boundaries.deinit(std.heap.page_allocator);
        for (lines) |l| {
            boundaries.append(std.heap.page_allocator, l.boundary) catch unreachable;
        }
        return .{
            .lines = lines,
            .boundary = Box.container(boundaries.items),
        };
    }

    /// Starting line number of this paragraph.
    pub fn startLineNumber(self: Paragraph) u32 {
        return self.lines[0].line_number;
    }

    /// TextSpan covering all lines in this paragraph.
    pub fn span(self: Paragraph) TextSpan {
        return TextSpan.init(self.lines[0].line_number, self.lines[self.lines.len - 1].line_number);
    }

    pub fn text() []const u8 {
        // Joined text of all lines
        return "";
    }
};

/// Regex for unprintable characters (control, format, private use, unassigned).
const unprintable_regex_str = "[\\x00-\\x1f\\x7f-\\x9f]";

/// Normalizes a word: remove unprintable chars, handle special Unicode ranges.
/// Translation of Paragraph.normalizeWord from Scala.
pub fn normalizeWord(word: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    // Handle the special codepoint ranges: 0xFB00-0xFDFF and 0xFE70-0xFEFF
    // These are typographic ligatures and Arabic presentation forms
    var result = std.ArrayList(u8).empty;
    errdefer result.deinit(allocator);

    const bytes = word;
    var i: usize = 0;
    while (i < bytes.len) {
        const cp_len = std.unicode.utf8ByteSequenceLength(bytes[i]) catch 1;
        const end = @min(i + cp_len, bytes.len);
        const byte_slice = bytes[i..end];

        // Try to decode as codepoint
        const cp = std.unicode.utf8Decode(byte_slice) catch {
            try result.appendSlice(allocator, byte_slice);
            i += 1;
            continue;
        };

        const c = @as(u21, @intCast(cp));

        // Handle special normalization ranges
        if ((c >= 0xFB00 and c <= 0xFDFF) or (c >= 0xFE70 and c <= 0xFEFF)) {
            // Arabic ligature 0xFDF2 → لله
            if (c == 0xFDF2 and i > 0 and
                (bytes[i - cp_len] == 0x0627 or bytes[i - cp_len] == 0xFE8D))
            {
                try result.appendSlice(allocator, "لله");
            } else {
                // Apply NFKC via a simple mapping for known ligatures
                // Full NFKC normalization requires ICU, so we handle common cases
                switch (c) {
                    // Latin ligatures: fi, fl, ffi, ffl, st, etc.
                    0xFB00 => try result.appendSlice(allocator, "ff"), // ﬀ → ff
                    0xFB01 => try result.appendSlice(allocator, "fi"), // ﬁ → fi
                    0xFB02 => try result.appendSlice(allocator, "fl"), // ﬂ → fl
                    0xFB03 => try result.appendSlice(allocator, "ffi"), // ﬃ → ffi
                    0xFB04 => try result.appendSlice(allocator, "ffl"), // ﬄ → ffl
                    0xFB05 => try result.appendSlice(allocator, "ft"), // ﬅ → ft
                    0xFB06 => try result.appendSlice(allocator, "st"), // ﬆ → st
                    // Pass through anything we don't recognize
                    else => try result.appendSlice(allocator, byte_slice),
                }
            }
        } else if (c <= 0x1F or (c >= 0x7F and c <= 0x9F)) {
            // Skip control characters
        } else {
            try result.appendSlice(allocator, byte_slice);
        }
        i += cp_len;
    }

    return result.toOwnedSlice(allocator);
}

/// Converts a paragraph to a normalized string, handling dehyphenation.
/// Translation of Paragraph.convertToNormalizedString from Scala.
pub fn convertToNormalizedString(paragraph: Paragraph, allocator: std.mem.Allocator) ![]const u8 {
    var result = std.ArrayList(u8).empty;

    // Normalize each line's words
    for (paragraph.lines, 0..) |line, line_idx| {
        for (line.words, 0..) |word, word_idx| {
            const normalized = try normalizeWord(word.text, allocator);
            defer allocator.free(normalized);
            try result.appendSlice(allocator, normalized);
            if (word_idx < line.words.len - 1) {
                try result.append(allocator, ' ');
            }
        }

        if (line_idx < paragraph.lines.len - 1) {
            // Dehyphenation: if the last word of this line ends with '-'
            const last_word = line.words[line.words.len - 1];
            if (last_word.text.len > 1 and
                last_word.text[last_word.text.len - 1] == '-' and
                hasLetter(last_word.text))
            {
                // Drop the hyphen and join without space
                _ = result.pop(); // remove the space we would add
                // Remove the trailing '-' we already added
                while (result.items.len > 0 and result.items[result.items.len - 1] == '-') {
                    _ = result.pop();
                }
            } else {
                try result.append(allocator, ' ');
            }
        }
    }

    return result.toOwnedSlice(allocator);
}

fn hasLetter(s: []const u8) bool {
    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) return true;
    }
    return false;
}

/// Removes lines whose line numbers are inside `segments` from `paragraphs`.
/// Translation of Paragraph.removeSpans from Scala.
pub fn removeSpans(
    allocator: std.mem.Allocator,
    segments: []const TextSpan,
    paragraphs: []const Paragraph,
) !std.ArrayList(Paragraph) {
    var result = std.ArrayList(Paragraph).empty;

    if (segments.len == 0) {
        try result.appendSlice(allocator, paragraphs);
        return result;
    }

    // Sort segments
    const sorted_segments = try allocator.alloc(TextSpan, segments.len);
    defer allocator.free(sorted_segments);
    @memcpy(sorted_segments, segments);
    std.mem.sort(TextSpan, sorted_segments, {}, struct {
        fn lt(_: void, a: TextSpan, b: TextSpan) bool {
            return a.start < b.start;
        }
    }.lt);

    var para_iter: usize = 0;

    for (sorted_segments) |seg| {
        const start = seg.start;
        const end = seg.end;

        // Advance to the paragraph containing `start`
        while (para_iter < paragraphs.len and
            (paragraphs[para_iter].lines.len == 0 or
                paragraphs[para_iter].lines[paragraphs[para_iter].lines.len - 1].line_number < start))
        {
            try result.append(allocator, paragraphs[para_iter]);
            para_iter += 1;
        }
        if (para_iter >= paragraphs.len) break;

        const cur_para = paragraphs[para_iter];
        // Split lines before start
        var lines_before = std.ArrayList(Line).empty;
        defer lines_before.deinit(allocator);
        var lines_after = std.ArrayList(Line).empty;
        defer lines_after.deinit(allocator);

        var reached_start = false;
        for (cur_para.lines) |line| {
            if (!reached_start and line.line_number < start) {
                try lines_before.append(allocator, line);
            } else if (line.line_number > end) {
                reached_start = true;
                try lines_after.append(allocator, line);
            } else {
                reached_start = true;
                // Skip lines in the span
            }
        }

        if (lines_before.items.len > 0) {
            const lines_copy = try allocator.dupe(Line, lines_before.items);
            try result.append(allocator, Paragraph.init(lines_copy));
        }

        // Skip to past the end
        while (para_iter < paragraphs.len and
            paragraphs[para_iter].lines.len > 0 and
            paragraphs[para_iter].lines[paragraphs[para_iter].lines.len - 1].line_number < end)
        {
            para_iter += 1;
        }

        if (para_iter < paragraphs.len) {
            // If we still have lines after at the current paragraph
            const remaining = if (lines_after.items.len > 0)
                lines_after.items
            else
                paragraphs[para_iter].lines;

            if (remaining.len > 0) {
                // Dupe if remaining comes from lines_after (which will be freed by defer)
                const remaining_copy = if (lines_after.items.len > 0)
                    try allocator.dupe(Line, remaining)
                else
                    remaining;
                try result.append(allocator, Paragraph.init(remaining_copy));
            }
            para_iter += 1;
        }
    }

    // Append remaining paragraphs
    while (para_iter < paragraphs.len) : (para_iter += 1) {
        try result.append(allocator, paragraphs[para_iter]);
    }

    return result;
}

// ---- Tests ----

test "TextSpan basics" {
    const span = TextSpan.init(0, 5);
    try std.testing.expectEqual(@as(u32, 0), span.start);
    try std.testing.expectEqual(@as(u32, 5), span.end);
}

test "normalizeWord basic" {
    const allocator = std.testing.allocator;
    const result = try normalizeWord("hello", allocator);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("hello", result);
}

test "normalizeWord ligature fi" {
    const allocator = std.testing.allocator;
    const fi_ligature = "\u{FB01}"; // ﬁ
    const result = try normalizeWord(fi_ligature, allocator);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("fi", result);
}

test "normalizeWord ligature fl" {
    const allocator = std.testing.allocator;
    const fl_ligature = "\u{FB02}"; // ﬂ
    const result = try normalizeWord(fl_ligature, allocator);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("fl", result);
}

test "Paragraph span" {
    const allocator = std.testing.allocator;
    const word = Word{ .text = "test", .boundary = Box.init(0, 0, 10, 10), .font_name = null, .font_size = null };
    const words = [_]Word{word};
    const line = Line.init(&words, 5);
    const lines = [_]Line{line};
    const para = Paragraph.init(&lines);
    const span = para.span();
    try std.testing.expectEqual(@as(u32, 5), span.start);
    try std.testing.expectEqual(@as(u32, 5), span.end);

    _ = allocator;
}

test "removeSpans empty" {
    const allocator = std.testing.allocator;
    const para1 = Paragraph{
        .lines = &[_]Line{},
        .boundary = Box.init(0, 0, 10, 10),
    };
    const paragraphs = [_]Paragraph{para1};
    const segments = [_]TextSpan{};
    var result = try removeSpans(allocator, &segments, &paragraphs);
    defer result.deinit(allocator);
    try std.testing.expectEqual(@as(usize, 1), result.items.len);
}