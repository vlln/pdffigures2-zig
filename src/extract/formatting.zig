// Formatting text extraction: identifies and strips headers, page numbers, abstracts.
// Direct translation of FormattingTextExtractor.scala.
//
// Regex patterns are implemented as simple string matching functions
// since Zig's std lib doesn't include regex.

const std = @import("std");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const Line = paragraph.Line;
const Word = paragraph.Word;
const TextSpan = paragraph.TextSpan;
const page = @import("../page.zig");
const PageWithClassifiedText = page.PageWithClassifiedText;
const ClassifiedText = page.ClassifiedText;
const PageWithText = page.PageWithText;

// ---- Regex equivalents (simple string matching) ----

/// Matches `^(Abstract|ABSTRACT)(((—|-)[a-zA-Z]*)|.)?$`
fn matchesAbstract(word: []const u8) bool {
    if (word.len < 8) return false;
    if (!std.mem.startsWith(u8, word, "Abstract") and !std.mem.startsWith(u8, word, "ABSTRACT"))
        return false;

    const rest = if (word.len > 8) word[8..] else "";
    if (rest.len == 0) return true;
    if (rest.len == 1) return true;

    // Check for em-dash (UTF-8: E2 80 94) or hyphen followed by letters
    if (std.mem.startsWith(u8, rest, "\xe2\x80\x94") or rest[0] == '-') {
        const after_dash = if (rest[0] == '-') rest[1..] else rest[3..];
        return after_dash.len > 0 and allAlpha(after_dash);
    }

    return false;
}

fn allAlpha(s: []const u8) bool {
    for (s) |c| if (!std.ascii.isAlphabetic(c)) return false;
    return true;
}

/// Matches `[1-9][0-9]*`
fn matchesPageNumber(s: []const u8) bool {
    if (s.len == 0) return false;
    if (s[0] < '1' or s[0] > '9') return false;
    for (s[1..]) |c| {
        if (c < '0' or c > '9') return false;
    }
    return true;
}

/// Build the text of a line by joining all word texts with spaces.
fn lineText(line: Line, allocator: std.mem.Allocator) ![]const u8 {
    var buf = std.ArrayList(u8).empty;
    for (line.words, 0..) |word, i| {
        try buf.appendSlice(allocator, word.text);
        if (i < line.words.len - 1) {
            try buf.append(allocator, ' ');
        }
    }
    return buf.toOwnedSlice(allocator);
}

/// Build normalized paragraph text (with dehyphenation).
fn paragraphText(para: Paragraph, allocator: std.mem.Allocator) ![]const u8 {
    return paragraph.convertToNormalizedString(para, allocator);
}

// ---- Abstract detection ----

/// Selects any paragraphs that appear to be part of an abstract on the page.
fn selectAbstract(page_text: PageWithText, allocator: std.mem.Allocator) ![]const Paragraph {
    const paragraphs_list = page_text.paragraphs;
    var abstract_start = std.ArrayList(Paragraph).empty;

    for (paragraphs_list) |p| {
        if (p.lines.len > 0 and p.lines[0].words.len > 0) {
            if (matchesAbstract(p.lines[0].words[0].text)) {
                try abstract_start.append(allocator, p);
            }
        }
    }

    if (abstract_start.items.len == 1) {
        const abstract_para = abstract_start.items[0];
        const just_title = abstract_para.lines.len == 1 and
            abstract_para.lines[0].words.len == 1;

        if (just_title) {
            const title_center = abstract_para.boundary.xCenter();
            var abstract_body = std.ArrayList(Paragraph).empty;

            for (paragraphs_list) |p| {
                const y_dist_from_abstract = p.boundary.y1 - abstract_para.boundary.y2;
                const centered = @abs(p.boundary.xCenter() - title_center) < 1;
                const below = y_dist_from_abstract < 20 and y_dist_from_abstract > 3;
                if (p.startLineNumber() != abstract_para.startLineNumber() and centered and below) {
                    try abstract_body.append(allocator, p);
                }
            }

            if (abstract_body.items.len == 1) {
                const result = try allocator.alloc(Paragraph, 2);
                result[0] = abstract_para;
                result[1] = abstract_body.items[0];
                return result;
            } else {
                const result = try allocator.alloc(Paragraph, 1);
                result[0] = abstract_para;
                return result;
            }
        } else {
            const result = try allocator.alloc(Paragraph, 1);
            result[0] = abstract_para;
            return result;
        }
    }

    return &.{};
}

// ---- Helper: group paragraphs by identical text ----

fn paragraphsEqual(a: Paragraph, b: Paragraph, allocator: std.mem.Allocator) !bool {
    const ta = try paragraphText(a, allocator);
    defer allocator.free(ta);
    const tb = try paragraphText(b, allocator);
    defer allocator.free(tb);
    return std.mem.eql(u8, ta, tb);
}

// ---- Header detection ----

fn selectHeaderCandidates(
    arena: std.mem.Allocator,
    _: []const PageWithText,
    candidates: []const ?Paragraph,
    min_consistent_headers: usize,
) ![]?Paragraph {
    // Count non-null candidates
    var non_empty = std.ArrayList(Paragraph).empty;
    for (candidates) |c| {
        if (c) |p| try non_empty.append(arena, p);
    }

    if (non_empty.items.len >= min_consistent_headers) {
        // Check for identical text
        // Find the most common paragraph text
        var texts = std.StringHashMap(usize).init(arena);
        for (non_empty.items) |p| {
            const text = try paragraphText(p, arena);
            const entry = try texts.getOrPutValue(text, 0);
            entry.value_ptr.* += 1;
        }

        var most_common_text: ?[]const u8 = null;
        var most_common_count: usize = 0;
        var text_it = texts.iterator();
        while (text_it.next()) |entry| {
            if (entry.value_ptr.* > most_common_count) {
                most_common_count = entry.value_ptr.*;
                most_common_text = entry.key_ptr.*;
            }
        }

        if (most_common_count >= min_consistent_headers) {
            const result = try arena.alloc(?Paragraph, candidates.len);
            for (candidates, 0..) |c, i| {
                if (c) |p| {
                    const text = try paragraphText(p, arena);
                    defer arena.free(text);
                    if (std.mem.eql(u8, text, most_common_text.?)) {
                        result[i] = p;
                    } else {
                        result[i] = null;
                    }
                } else {
                    result[i] = null;
                }
            }
            return result;
        } else {
            // Fall back on height-based matching
            const Interval = struct {
                y1: f64,
                y2: f64,
                fn intersects(self: @This(), other: @This(), tol: f64) bool {
                    return @abs(other.y1 - self.y1) < tol and @abs(other.y2 - self.y2) < tol;
                }
            };

            var heights = std.ArrayList(Interval).empty;
            for (non_empty.items) |p| {
                try heights.append(arena, .{ .y1 = p.boundary.y1, .y2 = p.boundary.y2 });
            }

            var common_height: ?Interval = null;
            for (heights.items) |interval| {
                var count: usize = 0;
                for (heights.items) |h| {
                    if (h.intersects(interval, 1.0)) count += 1;
                }
                if (count >= min_consistent_headers) {
                    common_height = interval;
                    break;
                }
            }

            if (common_height) |ch| {
                const result = try arena.alloc(?Paragraph, candidates.len);
                for (candidates, 0..) |c, i| {
                    if (c) |p| {
                        const interval = Interval{ .y1 = p.boundary.y1, .y2 = p.boundary.y2 };
                        if (interval.intersects(ch, 1)) {
                            result[i] = p;
                        } else {
                            result[i] = null;
                        }
                    } else {
                        result[i] = null;
                    }
                }
                return result;
            }
        }
    }

    // Not enough consistent headers — return all nulls
    const result = try arena.alloc(?Paragraph, candidates.len);
    @memset(result, null);
    return result;
}

/// Find header paragraphs across pages.
fn findHeaders(
    arena: std.mem.Allocator,
    text_pages: []const PageWithText,
    min_consistent_headers: usize,
) ![][]const Paragraph {
    const n = text_pages.len;

    // Get two candidate header paragraphs per page
    var first_candidates = try arena.alloc(?Paragraph, n);
    var second_candidates = try arena.alloc(?Paragraph, n);

    for (text_pages, 0..) |text_page, idx| {
        // Filter paragraphs in the top 3 inches (72*3 = 216 points)
        var top_paragraphs = std.ArrayList(Paragraph).empty;
        for (text_page.paragraphs) |p| {
            if (p.boundary.y1 < 72 * 3) {
                try top_paragraphs.append(arena, p);
            }
        }
        // Sort by y1
        std.mem.sort(Paragraph, top_paragraphs.items, {}, struct {
            fn lt(_: void, a: Paragraph, b: Paragraph) bool {
                return a.boundary.y1 < b.boundary.y1;
            }
        }.lt);

        const top2 = if (top_paragraphs.items.len > 2)
            top_paragraphs.items[0..2]
        else
            top_paragraphs.items;

        if (top2.len > 0) {
            const candidate = top2[0];
            var above_other_text = true;
            for (top_paragraphs.items) |p| {
                if (p.startLineNumber() != candidate.startLineNumber() and
                    @abs(candidate.boundary.y2 - p.boundary.y2) <= 3)
                {
                    above_other_text = false;
                }
            }
            const valid = candidate.lines.len <= 3 and above_other_text;
            first_candidates[idx] = if (valid) candidate else null;

            if (top2.len > 1 and first_candidates[idx] != null) {
                const candidate2 = top2[1];
                var above_other_text2 = true;
                const first_cand = first_candidates[idx].?;
                for (top_paragraphs.items) |p| {
                    if (p.startLineNumber() != candidate2.startLineNumber() and
                        p.startLineNumber() != first_cand.startLineNumber() and
                        @abs(candidate2.boundary.y2 - p.boundary.y2) <= 3)
                    {
                        above_other_text2 = false;
                    }
                }
                const valid2 = candidate2.lines.len <= 3 and above_other_text2;
                second_candidates[idx] = if (valid2) candidate2 else null;
            } else {
                second_candidates[idx] = null;
            }
        } else {
            first_candidates[idx] = null;
            second_candidates[idx] = null;
        }
    }

    // Select which headers to use
    const first_headers = try selectHeaderCandidates(arena, text_pages, first_candidates, min_consistent_headers);

    // Prune second candidates where first header was found
    var pruned_second = try arena.alloc(?Paragraph, n);
    for (second_candidates, 0..) |sc, i| {
        if (sc != null and first_headers[i] != null) {
            pruned_second[i] = sc;
        } else {
            pruned_second[i] = null;
        }
    }

    const second_headers = try selectHeaderCandidates(arena, text_pages, pruned_second, min_consistent_headers);

    // Combine headers per page
    var result = std.ArrayList([]const Paragraph).empty;
    for (first_headers, 0..) |fh, i| {
        var combined = std.ArrayList(Paragraph).empty;
        if (fh) |p| try combined.append(arena, p);
        if (second_headers[i]) |p| try combined.append(arena, p);
        try result.append(arena, try arena.dupe(Paragraph, combined.items));
    }

    return result.items;
}

// ---- Page number detection ----

/// Find page numbers in the last line of each page.
fn findPageNumber(
    arena: std.mem.Allocator,
    text_pages: []const PageWithText,
    min_consistent_page_numbers: usize,
) ![]?Line {
    const n = text_pages.len;
    var candidates = try arena.alloc(?Line, n);

    for (text_pages, 0..) |text_page, idx| {
        if (text_page.paragraphs.len > 0) {
            // Find last paragraph by y2
            var last_para = text_page.paragraphs[0];
            for (text_page.paragraphs) |p| {
                if (p.boundary.y2 > last_para.boundary.y2) {
                    last_para = p;
                }
            }
            const last_line = last_para.lines[last_para.lines.len - 1];
            const lt = try lineText(last_line, arena);
            defer arena.free(lt);
            if (matchesPageNumber(lt)) {
                candidates[idx] = last_line;
            } else {
                candidates[idx] = null;
            }
        } else {
            candidates[idx] = null;
        }
    }

    // Count defined candidates
    var defined_count: usize = 0;
    for (candidates) |c| {
        if (c != null) defined_count += 1;
    }

    if (min_consistent_page_numbers <= defined_count) {
        return candidates;
    } else {
        const result = try arena.alloc(?Line, n);
        @memset(result, null);
        return result;
    }
}

// ---- Main entry point ----

/// Extract formatting text (headers, page numbers, abstracts) from text pages.
pub fn extractFormattingText(
    arena: std.mem.Allocator,
    text_pages: []const PageWithText,
) ![]PageWithClassifiedText {
    const n = text_pages.len;

    // Min consistent pages
    const min_consistent_pages = n - (if (n < 3) @as(usize, 0) else if (n < 5) @as(usize, 1) else @as(usize, 2));

    // Find headers and page numbers
    const headers = try findHeaders(arena, text_pages, min_consistent_pages);
    const page_numbers = try findPageNumber(arena, text_pages, min_consistent_pages);

    // Look for an abstract in the first two pages
    var abstract_page_num: ?u32 = null;
    var abstract_text: []const Paragraph = &.{};

    const first_two_pages = if (n > 2) @min(n, 2) else n;
    for (0..@as(usize, @intCast(first_two_pages))) |i| {
        const abs = try selectAbstract(text_pages[i], arena);
        if (abs.len > 0) {
            abstract_page_num = @intCast(text_pages[i].page_number);
            abstract_text = abs;
            break;
        }
    }

    // Build classified pages
    var result = std.ArrayList(PageWithClassifiedText).empty;

    for (text_pages, 0..) |text_page, idx| {
        if (abstract_page_num != null and abstract_page_num.? > text_page.page_number) {
            // Cover page before abstract
            const ct = ClassifiedText{ .formatting_text = text_page.paragraphs };
            try result.append(arena, PageWithClassifiedText.init(
                text_page.page_number,
                &.{},
                ct,
            ));
        } else {
            // Build page number paragraph
            var page_number_para: ?Paragraph = null;
            if (page_numbers[idx]) |pn| {
                const pn_word: Word = .{ .text = "", .boundary = pn.boundary, .font_name = null, .font_size = null };
                const pn_line = Line{ .words = &.{pn_word}, .boundary = pn.boundary, .line_number = pn.line_number };
                const lines = [_]Line{pn_line};
                page_number_para = Paragraph.init(&lines);
            }

            // Gather locations to remove
            var to_remove = std.ArrayList(TextSpan).empty;

            for (headers[idx]) |h| {
                try to_remove.append(arena, h.span());
            }

            if (page_number_para) |pnp| {
                try to_remove.append(arena, pnp.span());
            }

            // Abstract text on this page
            var this_page_abstract: []const Paragraph = &.{};
            if (abstract_page_num != null and abstract_page_num.? == text_page.page_number) {
                this_page_abstract = abstract_text;
            }

            for (this_page_abstract) |ap| {
                try to_remove.append(arena, ap.span());
            }

            // Text above abstract
            var above_abstract_paragraphs = std.ArrayList(Paragraph).empty;
            if (this_page_abstract.len > 0) {
                var abstract_min_y1: f64 = std.math.floatMax(f64);
                for (this_page_abstract) |ap| {
                    abstract_min_y1 = @min(abstract_min_y1, ap.boundary.y1);
                }

                var already_removed = std.ArrayList(u32).empty;
                for (headers[idx]) |h| {
                    try already_removed.append(arena, h.startLineNumber());
                }
                for (this_page_abstract) |ap| {
                    try already_removed.append(arena, ap.startLineNumber());
                }
                // Sort for contains check
                std.mem.sort(u32, already_removed.items, {}, struct {
                    fn lt(_: void, a: u32, b: u32) bool { return a < b; }
                }.lt);

                for (text_page.paragraphs) |p| {
                    const already_removed_check = for (already_removed.items) |ar| {
                        if (ar == p.startLineNumber()) break true;
                    } else false;

                    if (p.boundary.y2 < abstract_min_y1 and !already_removed_check) {
                        try above_abstract_paragraphs.append(arena, p);
                    }
                }

                for (above_abstract_paragraphs.items) |aap| {
                    try to_remove.append(arena, aap.span());
                }
            }

            // Strip text
            var stripped_result = try paragraph.removeSpans(arena, to_remove.items, text_page.paragraphs);
            defer stripped_result.deinit(arena);

            // Build formatting text list
            var formatting_text = std.ArrayList(Paragraph).empty;
            if (page_number_para) |pnp| try formatting_text.append(arena, pnp);
            try formatting_text.appendSlice(arena, above_abstract_paragraphs.items);

            const ft_slice = try arena.dupe(Paragraph, formatting_text.items);
            const hdrs_slice = try arena.dupe(Paragraph, headers[idx]);

            const ct = ClassifiedText{
                .page_headers = hdrs_slice,
                .formatting_text = ft_slice,
                .abstract_text = this_page_abstract,
            };

            try result.append(arena, PageWithClassifiedText.init(
                text_page.page_number,
                try arena.dupe(Paragraph, stripped_result.items),
                ct,
            ));
        }
    }

    return result.items;
}

test {
    _ = Box;
}