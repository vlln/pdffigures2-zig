// Document-level layout statistics.
// Direct translation of DocumentLayout.scala.

const std = @import("std");
const box = @import("box.zig");
const Box = box.Box;
const paragraph = @import("paragraph.zig");
const Paragraph = paragraph.Paragraph;
const Line = paragraph.Line;
const Word = paragraph.Word;
const page = @import("page.zig");
const PageWithText = page.PageWithText;
const PageWithClassifiedText = page.PageWithClassifiedText;

pub const LineWidthBucketSize: f64 = 2.0;
const TwoColumnMaxUsageDifference: f64 = 0.40;
const TwoColumnMaxXDifference: f64 = 0.40;
const MinCommonLineWidthUse: f64 = 0.4;
const TrustMarginsTwoColumnThreshold: f64 = 0.65;
const TrustMarginsOneColumnThreshold: f64 = 0.55;
const TrustMarginsNumMarginsToCount: usize = 3;

/// A (value, weight) pair used for weighted median computation.
pub const WeightedValue = struct { value: f64, weight: u32 };

/// A margin entry for two-column detection.
pub const MarginItem = struct { x: i32, count: u32 };

/// Document-wide layout statistics consumed by downstream classifiers.
pub const DocumentLayout = struct {
    two_columns: bool,
    font_fractions: std.StringHashMap(f64),
    standard_font_size: ?f64, // most common font size, if >50% of chars
    average_font_size: f64,
    average_word_spacing: f64,
    trust_left_margin: bool,
    left_margins: std.AutoHashMap(i32, f64), // x-coordinate → fraction of words
    median_line_spacing: f64,
    standard_width_bucketed: ?f64,

    pub fn deinit(self: *DocumentLayout) void {
        self.font_fractions.deinit();
        self.left_margins.deinit();
    }
};

/// Computes the weighted median: given (value, weight) pairs, returns the value
/// such that total weight above and below are as balanced as possible.
pub fn weightedMedian(inputs: []const WeightedValue) f64 {
    std.debug.assert(inputs.len > 0);

    // Copy and sort by value
    const allocator = std.heap.page_allocator;
    const sorted = allocator.alloc(WeightedValue, inputs.len) catch @panic("OOM");
    defer allocator.free(sorted);
    @memcpy(sorted, inputs);
    std.mem.sort(WeightedValue, sorted, {}, struct {
        fn lt(_: void, a: WeightedValue, b: WeightedValue) bool {
            return a.value < b.value;
        }
    }.lt);

    var removed_from_start: u32 = 0;
    var removed_from_end: u32 = 0;
    var lo: usize = 0;
    var hi: usize = sorted.len - 1;

    while (lo < hi) {
        if (removed_from_end + sorted[hi].weight < removed_from_start + sorted[lo].weight) {
            removed_from_end += sorted[hi].weight;
            hi -= 1;
        } else {
            removed_from_start += sorted[lo].weight;
            lo += 1;
        }
    }
    return sorted[lo].value;
}

/// Helper type for building DocumentLayout from pages.
/// Use `buildLayout()` to create from text pages.

/// Build a DocumentLayout from text pages. Returns null if insufficient data.
pub fn buildLayout(
    arena: std.mem.Allocator,
    text_pages: []const PageWithClassifiedText,
) ?DocumentLayout {
    var total_word_spacing: f64 = 0;
    var total_word_spaces: u32 = 0;
    var left_margins_raw = std.AutoHashMap(i32, u32).init(arena);
    defer left_margins_raw.deinit();
    var font_counts = std.StringHashMap(u32).init(arena);
    defer font_counts.deinit();
    var line_widths = std.AutoHashMap(i64, u32).init(arena);
    defer line_widths.deinit();
    var font_size_counts = std.AutoHashMap(i64, u32).init(arena);
    defer font_size_counts.deinit();
    var line_spacings = std.ArrayList(WeightedValue).empty;

    // Track page dimensions for two-column detection
    var max_page_x2: f64 = 0;
    var min_page_x1: f64 = std.math.floatMax(f64);

    for (text_pages) |text_page| {
        var prev_line_bb: ?Box = null;
        for (text_page.paragraphs) |para| {
            // Track page bounds from paragraph boundaries
            if (para.boundary.x2 > max_page_x2) max_page_x2 = para.boundary.x2;
            if (para.boundary.x1 < min_page_x1) min_page_x1 = para.boundary.x1;

            for (para.lines) |line| {
                if (!line.isHorizontal()) continue;

                const weight: u32 = @intCast(line.words.len);
                const x1_rounded: i32 = @intFromFloat(@round(line.boundary.x1));
                const entry = left_margins_raw.getOrPutValue(x1_rounded, 0) catch continue;
                entry.value_ptr.* += weight;

                if (prev_line_bb) |prev_bb| {
                    const space = line.boundary.y1 - prev_bb.y2;
                    if (prev_bb.x1 < line.boundary.x2 and
                        prev_bb.x2 > line.boundary.x1 and
                        space > 0)
                    {
                        line_spacings.append(arena, .{ .value = space, .weight = weight }) catch continue;
                    }
                }

                const w = line.boundary.width();
                const lower_bucket: i64 = @intFromFloat(@floor(w / LineWidthBucketSize) * LineWidthBucketSize);
                const upper_bucket: i64 = @intFromFloat(@ceil(w / LineWidthBucketSize) * LineWidthBucketSize);
                const le = line_widths.getOrPutValue(lower_bucket, 0) catch continue;
                le.value_ptr.* += weight;
                const ue = line_widths.getOrPutValue(upper_bucket, 0) catch continue;
                ue.value_ptr.* += weight;

                prev_line_bb = line.boundary;

                var prev_word: ?Word = null;
                for (line.words) |word| {
                    if (prev_word) |pw| {
                        const spacing = word.boundary.x1 - pw.boundary.x2;
                        if (spacing > 0) {
                            total_word_spacing += spacing;
                            total_word_spaces += 1;
                        }
                    }

                    // Font tracking via font_name
                    if (word.font_name) |fnm| {
                        const fe = font_counts.getOrPutValue(fnm, 0) catch continue;
                        fe.value_ptr.* += 1;
                    }

                    // Font size tracking
                    if (word.font_size) |fs| {
                        const fs_int: i64 = @intFromFloat(fs * 10); // decipoints for precision
                        const fse = font_size_counts.getOrPutValue(fs_int, 0) catch continue;
                        fse.value_ptr.* += 1;
                    }

                    prev_word = word;
                }
            }
        }
    }

    const total_font_uses: u32 = blk: {
        var sum: u32 = 0;
        var it = font_counts.valueIterator();
        while (it.next()) |v| sum += v.*;
        break :blk sum;
    };
    const total_lines: u32 = blk: {
        var sum: u32 = 0;
        var it = line_widths.valueIterator();
        while (it.next()) |v| sum += v.*;
        break :blk @intCast(sum / 2);
    };

    if (total_word_spaces == 0 or total_font_uses == 0 or line_spacings.items.len == 0 or total_lines == 0) {
        return null; // Not enough info
    }

    // Standard font size: most common if >50%
    var most_common_fs: f64 = 0;
    var most_common_fs_count: u32 = 0;
    var fs_it = font_size_counts.iterator();
    while (fs_it.next()) |entry| {
        const k = entry.key_ptr.*;
        const v = entry.value_ptr.*;
        if (v > most_common_fs_count) {
            most_common_fs_count = v;
            most_common_fs = @as(f64, @floatFromInt(k)) / 10.0;
        }
    }
    const standard_font_size: ?f64 = if (most_common_fs_count > total_font_uses / 2) most_common_fs else null;

    // Average font size
    var weighted_fs_sum: f64 = 0;
    var fs_it2 = font_size_counts.iterator();
    while (fs_it2.next()) |entry| {
        const k = entry.key_ptr.*;
        const v = entry.value_ptr.*;
        weighted_fs_sum += @as(f64, @floatFromInt(k)) / 10.0 * @as(f64, @floatFromInt(v));
    }
    const average_font_size: f64 = weighted_fs_sum / @as(f64, @floatFromInt(total_font_uses));

    // Median line spacing
    const median_line_spacing: f64 = weightedMedian(line_spacings.items);

    // Standard line width
    var most_common_width: f64 = 0;
    var most_common_width_count: u32 = 0;
    var lw_it = line_widths.iterator();
    while (lw_it.next()) |entry| {
        const k = entry.key_ptr.*;
        const v = entry.value_ptr.*;
        if (v > most_common_width_count) {
            most_common_width_count = v;
            most_common_width = @floatFromInt(k);
        }
    }

    // Two-column detection
    // Get top 2 left margins by count
    var margin_items = std.ArrayList(MarginItem).empty;
    var lmr_it = left_margins_raw.iterator();
    while (lmr_it.next()) |entry| {
        margin_items.append(arena, .{ .x = entry.key_ptr.*, .count = entry.value_ptr.* }) catch continue;
    }
    std.mem.sort(MarginItem, margin_items.items, {}, struct {
        fn lt(_: void, a: MarginItem, b: MarginItem) bool {
            return a.count > b.count; // descending
        }
    }.lt);

    const estimated_page_width: f64 = if (max_page_x2 > min_page_x1) max_page_x2 - min_page_x1 else 612;
    const two_column: bool = if (margin_items.items.len >= 2)
        blk: {
            const most = margin_items.items[0];
            const second = margin_items.items[1];
            const total: f64 = @floatFromInt(most.count + second.count);
            const diff: f64 = @abs(@as(f64, @floatFromInt(most.count - second.count))) / total;
            break :blk diff < TwoColumnMaxUsageDifference and
                @abs(@as(f64, @floatFromInt(most.x - second.x))) > TwoColumnMaxXDifference * estimated_page_width;
        }
    else
        false;

    // Font fractions
    var font_fractions = std.StringHashMap(f64).init(arena);
    var fc_it = font_counts.iterator();
    while (fc_it.next()) |entry| {
        const name = entry.key_ptr.*;
        const count = entry.value_ptr.*;
        font_fractions.put(name, @as(f64, @floatFromInt(count)) / @as(f64, @floatFromInt(total_font_uses))) catch continue;
    }

    // Left margin fractions
    const total_margin_count: u32 = blk: {
        var sum: u32 = 0;
        var lmr_it2 = left_margins_raw.valueIterator();
        while (lmr_it2.next()) |v| sum += v.*;
        break :blk sum;
    };

    // Trust left margins?
    const trust_margins: bool = if (two_column) blk: {
        var words_in_top: f64 = 0;
        const n = @min(margin_items.items.len, TrustMarginsNumMarginsToCount * 2);
        for (margin_items.items[0..n]) |item| {
            words_in_top += @floatFromInt(item.count);
        }
        break :blk words_in_top / @as(f64, @floatFromInt(total_margin_count)) > TrustMarginsTwoColumnThreshold;
    } else blk: {
        var words_in_top: f64 = 0;
        const n = @min(margin_items.items.len, TrustMarginsNumMarginsToCount);
        for (margin_items.items[0..n]) |item| {
            words_in_top += @floatFromInt(item.count);
        }
        break :blk words_in_top / @as(f64, @floatFromInt(total_margin_count)) > TrustMarginsOneColumnThreshold;
    };

    var left_margins = std.AutoHashMap(i32, f64).init(arena);
    for (margin_items.items) |item| {
        const frac = @as(f64, @floatFromInt(item.count)) / @as(f64, @floatFromInt(total_margin_count));
        left_margins.put( item.x, frac) catch continue;
    }

    // Standard width bucketed
    const swb: ?f64 = blk: {
        const thr: u32 = @intFromFloat(@as(f64, @floatFromInt(total_lines)) * MinCommonLineWidthUse);
        if (most_common_width_count > thr) break :blk most_common_width;
        break :blk null;
    };

    return DocumentLayout{
        .two_columns = two_column,
        .font_fractions = font_fractions,
        .standard_font_size = standard_font_size,
        .average_font_size = average_font_size,
        .average_word_spacing = total_word_spacing / @as(f64, @floatFromInt(total_word_spaces)),
        .trust_left_margin = trust_margins,
        .left_margins = left_margins,
        .median_line_spacing = median_line_spacing,
        .standard_width_bucketed = swb,
    };
}

// ---- Tests ----

test "weightedMedian single" {
    const inputs = [_]WeightedValue{
        .{ .value = 5.0, .weight = 1 },
    };
    try std.testing.expectEqual(@as(f64, 5.0), weightedMedian(&inputs));
}

test "weightedMedian two" {
    const inputs = [_]WeightedValue{
        .{ .value = 1.0, .weight = 5 },
        .{ .value = 2.0, .weight = 1 },
    };
    try std.testing.expectEqual(@as(f64, 1.0), weightedMedian(&inputs));
}

test "weightedMedian balanced" {
    const inputs = [_]WeightedValue{
        .{ .value = 1.0, .weight = 2 },
        .{ .value = 2.0, .weight = 2 },
        .{ .value = 3.0, .weight = 2 },
    };
    try std.testing.expectEqual(@as(f64, 2.0), weightedMedian(&inputs));
}