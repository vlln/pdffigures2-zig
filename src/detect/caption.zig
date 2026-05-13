// Caption detection: finds lines starting with "Figure 1", "Table 2", etc.
// Direct translation of CaptionDetector.scala.
//
// Regex patterns are implemented as simple string matching functions.

const std = @import("std");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const Line = paragraph.Line;
const Word = paragraph.Word;
const figure = @import("../figure.zig");
const FigureType = figure.FigureType;

const MaxHeightForCaptionLines: f64 = 60;
const MaxDuplicateCaptionNames: usize = 3;
const MaxSamePageDuplicateCaptionNames: usize = 2;

/// A detected caption start within text.
pub const CaptionStart = struct {
    header: []const u8,
    name: []const u8,
    fig_type: FigureType,
    number_syntax: []const u8,
    line: Line,
    next_line: ?Line,
    page: u32,
    paragraph_start: bool,
    line_end: bool,

    pub fn colonMatch(self: CaptionStart) bool {
        return std.mem.eql(u8, self.number_syntax, ":");
    }

    pub fn periodMatch(self: CaptionStart) bool {
        return std.mem.eql(u8, self.number_syntax, ".");
    }

    pub fn allCapsFig(self: CaptionStart) bool {
        return std.mem.startsWith(u8, self.header, "FIG");
    }

    pub fn allCapsTable(self: CaptionStart) bool {
        return std.mem.eql(u8, self.header, "TABLE");
    }

    pub fn figAbbreviated(self: CaptionStart) bool {
        return std.mem.eql(u8, self.header, "Fig.");
    }

    pub fn figId(self: CaptionStart) struct { fig_type: FigureType, name: []const u8 } {
        return .{ .fig_type = self.fig_type, .name = self.name };
    }
};

/// Matches caption start words: Figure., Figure, FIGURE, Table, TABLE, Fig., Fig, FIG., FIG
fn matchesCaptionStart(word: []const u8) bool {
    const starters = [_][]const u8{
        "Figure.", "Figure",  "FIGURE",
        "Table",   "TABLE",
        "Fig.",    "Fig",     "FIG.",    "FIG",
    };
    for (starters) |s| {
        if (std.mem.eql(u8, word, s)) return true;
    }
    return false;
}

/// Matches caption numbers like "1", "2.3", "IV", "1.1", "A.1" with optional trailing ":" or "."
/// Returns true and sets the number text, or false.
fn tryMatchCaptionNumber(input: []const u8) ?struct { number: []const u8, syntax: []const u8 } {
    if (input.len == 0) return null;

    // Strip trailing ":" or "."
    var number = input;
    var syntax: []const u8 = "";

    if (input[input.len - 1] == ':') {
        number = input[0 .. input.len - 1];
        syntax = ":";
    } else if (input[input.len - 1] == '.') {
        number = input[0 .. input.len - 1];
        syntax = ".";
    }

    if (number.len == 0) return null;

    // Check pattern: [1-9][0-9]*  or  [1-9][0-9]*.[1-9][0-9]*  or  [IVX]+  or  [A-D].[1-9][0-9]*
    if (matchesRomanNumeral(number) or matchesDecimalFigureNum(number) or matchesAlphaFigureNum(number)) {
        return .{ .number = number, .syntax = syntax };
    }

    return null;
}

fn matchesRomanNumeral(s: []const u8) bool {
    for (s) |c| {
        if (c != 'I' and c != 'V' and c != 'X') return false;
    }
    return true;
}

fn matchesDecimalFigureNum(s: []const u8) bool {
    if (s.len == 0) return false;
    if (s[0] < '1' or s[0] > '9') return false;
    var has_dot = false;
    for (s, 0..) |c, i| {
        if (c == '.') {
            if (has_dot) return false;
            has_dot = true;
            // Check next char starts a digit
            if (i + 1 >= s.len or s[i + 1] < '1' or s[i + 1] > '9') return false;
        } else if (c < '0' or c > '9') {
            return false;
        }
    }
    return true;
}

fn matchesAlphaFigureNum(s: []const u8) bool {
    if (s.len < 3) return false;
    if (s[0] < 'A' or s[0] > 'D') return false;
    if (s[1] != '.') return false;
    if (s[2] < '1' or s[2] > '9') return false;
    for (s[3..]) |c| {
        if (c < '0' or c > '9') return false;
    }
    return true;
}

// ---- CandidateFilter system ----

/// Tagged union of all candidate filter types.
pub const FilterType = enum {
    colon_only,
    period_only,
    all_caps_fig_only,
    all_caps_table_only,
    abbreviated_fig_only,
    line_end_only,
    figure_has_following_text_only,
    left_aligned,
    left_aligned_figures,
};

pub fn filterAccepts(filter_type: FilterType, cc: *const CaptionStart) bool {
    return switch (filter_type) {
        .colon_only => cc.colonMatch(),
        .period_only => cc.periodMatch(),
        .all_caps_fig_only => cc.allCapsFig() or cc.fig_type == FigureType.Table,
        .all_caps_table_only => cc.allCapsTable() or cc.fig_type == FigureType.Figure,
        .abbreviated_fig_only => cc.figAbbreviated() or cc.fig_type == FigureType.Table,
        .line_end_only => cc.line_end,
        .figure_has_following_text_only => cc.fig_type == FigureType.Table or !cc.line_end,
        .left_aligned => if (cc.next_line) |nl|
            @abs(cc.line.boundary.x1 - nl.boundary.x1) < 1
        else
            true,
        .left_aligned_figures => if (cc.fig_type == FigureType.Table) true else if (cc.next_line) |nl|
            @abs(cc.line.boundary.x1 - nl.boundary.x1) < 1
        else
            true,
    };
}

pub fn filterName(filter_type: FilterType) []const u8 {
    return switch (filter_type) {
        .colon_only => "Colon Only",
        .period_only => "Period Only",
        .all_caps_fig_only => "All Caps Figures Only",
        .all_caps_table_only => "All Caps Table Only",
        .abbreviated_fig_only => "Abbreviated Fig Only",
        .line_end_only => "Line End Only",
        .figure_has_following_text_only => "Figure Following Text",
        .left_aligned => "Left Aligned",
        .left_aligned_figures => "Left Aligned Figures",
    };
}

pub fn defaultFilters() []const FilterType {
    return &.{
        .colon_only,
        .all_caps_fig_only,
        .all_caps_table_only,
        .abbreviated_fig_only,
        .figure_has_following_text_only,
        .period_only,
        .left_aligned,
        .left_aligned_figures,
        .line_end_only,
    };
}

// ---- Main detection logic ----

/// Find all caption candidates across pages.
pub fn findCaptionCandidates(
    arena: std.mem.Allocator,
    pages: anytype,
) !std.ArrayList(CaptionStart) {
    var candidates = std.ArrayList(CaptionStart).empty;

    for (pages) |page| {
        for (page.paragraphs) |para| {
            var paragraph_start = true;
            for (para.lines, 0..) |line, line_num| {
                if (line.words.len == 0) {
                    paragraph_start = false;
                    continue;
                }

                const first_word = line.words[0].text;

                // Handle "Fig ." → "Fig." (PDFBox spacing issue)
                const header_str: []const u8, const word_number: usize = if (line.words.len > 2 and
                    std.mem.eql(u8, line.words[1].text, "."))
                    blk: {
                        break :blk .{ try std.mem.concat(arena, u8, &.{ first_word, "." }), 2 };
                    }
                else
                    .{ first_word, 1 };

                if (matchesCaptionStart(first_word) and line.words.len > 1) {
                    const number_str = line.words[word_number].text;

                    if (tryMatchCaptionNumber(number_str)) |match| {
                        const sane_height = line.boundary.height() < MaxHeightForCaptionLines;
                        if (sane_height) {
                            const fig_type: FigureType = if (header_str[0] == 'F')
                                FigureType.Figure
                            else
                                FigureType.Table;

                            const next_line: ?Line = if (line_num == para.lines.len - 1)
                                null
                            else
                                para.lines[line_num + 1];

                            const line_end = match.syntax.len == 0 or
                                (match.number.len + match.syntax.len == number_str.len and
                                line.words.len == word_number + 1);

                            try candidates.append(arena, CaptionStart{
                                .header = try arena.dupe(u8, header_str),
                                .name = try arena.dupe(u8, match.number),
                                .fig_type = fig_type,
                                .number_syntax = try arena.dupe(u8, match.syntax),
                                .line = line,
                                .next_line = next_line,
                                .page = page.page_number,
                                .paragraph_start = paragraph_start,
                                .line_end = line_end,
                            });
                        }
                    }
                }
                paragraph_start = false;
            }
        }
    }

    return candidates;
}

/// Custom hash context for FigId (needed because Zig 0.17 autoHash rejects slices).
const FigIdContext = struct {
    pub fn hash(_: @This(), key: FigId) u32 {
        var h = std.hash.Wyhash.init(0);
        h.update(std.mem.asBytes(&key.fig_type));
        h.update(key.name);
        return @truncate(h.final());
    }
    pub fn eql(_: @This(), a: FigId, b: FigId) bool {
        return a.fig_type == b.fig_type and std.mem.eql(u8, a.name, b.name);
    }
};

const FigId = struct { fig_type: FigureType, name: []const u8 };
const FigIdHashMap = std.HashMap(FigId, Group, FigIdContext, 80);

const Group = struct { items: std.ArrayList(CaptionStart) };

/// Select the best caption candidates by applying filters to remove false positives.
pub fn selectCaptionCandidates(
    arena: std.mem.Allocator,
    candidates: []const CaptionStart,
    filters: []const FilterType,
) !std.ArrayList(CaptionStart) {
    var grouped = FigIdHashMap.init(arena);
    defer {
        var it = grouped.valueIterator();
        while (it.next()) |g| g.items.deinit(arena);
        grouped.deinit();
    }

    for (candidates) |c| {
        const key = FigId{ .fig_type = c.fig_type, .name = c.name };
        const entry = try grouped.getOrPutValue(key, .{ .items = std.ArrayList(CaptionStart).empty });
        try entry.value_ptr.items.append(arena, c);
    }

    var removed_any = true;
    while (removed_any and hasDuplicates(&grouped)) {
        var filter_to_use: ?FilterType = null;

        for (filters) |filter| {
            var filter_removes_any = false;
            var filter_removes_group = false;

            var git = grouped.valueIterator();
            while (git.next()) |g| {
                var all_rejected = true;
                for (g.items.items) |*cc| {
                    if (!filterAccepts(filter, cc)) {
                        filter_removes_any = true;
                    } else {
                        all_rejected = false;
                    }
                }
                if (all_rejected and g.items.items.len > 0) {
                    filter_removes_group = true;
                }
            }

            if (filter_removes_any and !filter_removes_group) {
                filter_to_use = filter;
                break;
            }
        }

        if (filter_to_use) |ftu| {
            var new_grouped = FigIdHashMap.init(arena);
            var kit = grouped.iterator();
            while (kit.next()) |entry| {
                const key = entry.key_ptr.*;
                const g = entry.value_ptr;
                var filtered = std.ArrayList(CaptionStart).empty;
                for (g.items.items) |*cc| {
                    if (filterAccepts(ftu, cc)) {
                        try filtered.append(arena, cc.*);
                    }
                }
                if (filtered.items.len > 0) {
                    try new_grouped.put(key, .{ .items = filtered });
                }
            }
            var it = grouped.valueIterator();
            while (it.next()) |g| g.items.deinit(arena);
            grouped.deinit();
            grouped = new_grouped;
        } else {
            removed_any = false;
            var new_grouped = FigIdHashMap.init(arena);
            var kit = grouped.iterator();
            while (kit.next()) |entry| {
                const key = entry.key_ptr.*;
                const g = entry.value_ptr;
                var filtered = std.ArrayList(CaptionStart).empty;
                for (g.items.items) |*cc| {
                    if (cc.paragraph_start) {
                        try filtered.append(arena, cc.*);
                    }
                }
                if (filtered.items.len > 0) {
                    try new_grouped.put(key, .{ .items = filtered });
                    if (filtered.items.len < g.items.items.len) removed_any = true;
                } else {
                    try new_grouped.put(key, .{ .items = try g.items.clone(arena) });
                }
            }
            var it = grouped.valueIterator();
            while (it.next()) |g| g.items.deinit(arena);
            grouped.deinit();
            grouped = new_grouped;
        }
    }

    // Drop groups that are too large (>3 total or >2 on a page)
    var result = std.ArrayList(CaptionStart).empty;
    var rit = grouped.valueIterator();
    while (rit.next()) |g| {
        if (g.items.items.len > MaxDuplicateCaptionNames) continue;

        // Check per-page duplicate limit
        var page_counts = std.AutoHashMap(u32, usize).init(arena);
        defer page_counts.deinit();
        for (g.items.items) |cc| {
            const pc = try page_counts.getOrPutValue(cc.page, 0);
            pc.value_ptr.* += 1;
        }
        var max_on_page: usize = 0;
        var pit = page_counts.valueIterator();
        while (pit.next()) |c| max_on_page = @max(max_on_page, c.*);
        if (max_on_page > MaxSamePageDuplicateCaptionNames) continue;

        try result.appendSlice(arena, g.items.items);
    }

    return result;
}

fn hasDuplicates(grouped: *FigIdHashMap) bool {
    var it = grouped.valueIterator();
    while (it.next()) |g| {
        if (g.items.items.len > 1) return true;
    }
    return false;
}

// ---- Tests ----

test "matchesCaptionStart" {
    try std.testing.expect(matchesCaptionStart("Figure"));
    try std.testing.expect(matchesCaptionStart("FIGURE"));
    try std.testing.expect(matchesCaptionStart("Table"));
    try std.testing.expect(matchesCaptionStart("Fig."));
    try std.testing.expect(!matchesCaptionStart("Introduction"));
}

test "tryMatchCaptionNumber" {
    {
        const m = tryMatchCaptionNumber("1:").?;
        try std.testing.expectEqualStrings("1", m.number);
        try std.testing.expectEqualStrings(":", m.syntax);
    }
    {
        const m = tryMatchCaptionNumber("2.3").?;
        try std.testing.expectEqualStrings("2.3", m.number);
    }
    {
        const m = tryMatchCaptionNumber("IV.").?;
        try std.testing.expectEqualStrings("IV", m.number);
        try std.testing.expectEqualStrings(".", m.syntax);
    }
    try std.testing.expect(tryMatchCaptionNumber("abc") == null);
}

test "CaptionStart properties" {
    const word = Word{ .text = "Figure", .boundary = Box.init(0, 0, 10, 10), .font_name = null, .font_size = null };
    const line = Line{ .words = &.{word}, .boundary = Box.init(0, 0, 10, 10), .line_number = 0 };
    const cs = CaptionStart{
        .header = "Figure",
        .name = "1",
        .fig_type = FigureType.Figure,
        .number_syntax = ":",
        .line = line,
        .next_line = null,
        .page = 1,
        .paragraph_start = true,
        .line_end = true,
    };
    try std.testing.expect(cs.colonMatch());
    try std.testing.expect(!cs.periodMatch());
    try std.testing.expect(!cs.allCapsFig());
}
