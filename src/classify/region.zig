// Region classification: classifies paragraphs as body text vs "other" (potential figure text).
// Direct translation of RegionClassifier.scala.
// Uses a sieve of heuristics applied in priority order.

const std = @import("std");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const Line = paragraph.Line;
const Word = paragraph.Word;
const page = @import("../page.zig");
const PageWithBodyText = page.PageWithBodyText;
const PageWithCaptions = page.PageWithCaptions;
const PageWithGraphics = page.PageWithGraphics;
const ClassifiedText = page.ClassifiedText;
const CaptionParagraph = page.CaptionParagraph;
const layout = @import("../layout.zig");
const DocumentLayout = layout.DocumentLayout;
const figure = @import("../figure.zig");
const Caption = figure.Caption;
const CaptionParagraphType = figure.CaptionParagraph;

// Tagged union for the classifier sieve — each variant encapsulates its parameters
const Classifier = union(enum) {
    graphic_overlaps: []const Box,
    vertical_text,
    spacing: struct {
        standard_font_size: ?f64,
        average_word_spacing: f64,
    },
    line_width: ?f64,
    small_font: ?f64,
    is_title: *const DocumentLayout,
    margins: struct {
        trust_left_margin: bool,
        left_margins: std.AutoHashMap(i32, f64),
    },

    fn classify(self: Classifier, p: Paragraph) ?bool {
        return switch (self) {
            .graphic_overlaps => |graphics| classifyGraphicOverlaps(p, graphics),
            .vertical_text => classifyVerticalText(p),
            .spacing => |s| classifySpacing(p, s.standard_font_size, s.average_word_spacing),
            .line_width => |sw| classifyLineWidth(p, sw),
            .small_font => |sf| classifySmallFont(p, sf),
            .is_title => |dl| classifyIsTitle(p, dl),
            .margins => |m| classifyMargins(p, m.trust_left_margin, m.left_margins),
        };
    }
};

fn classifyGraphicOverlaps(p: Paragraph, graphics: []const Box) ?bool {
    const b = p.boundary;
    for (graphics) |g| {
        if (g.intersectArea(b) / b.area() > 0.20) {
            return false; // Figure text
        }
    }
    return null;
}

fn classifyVerticalText(p: Paragraph) ?bool {
    for (p.lines) |l| {
        if (l.isHorizontal()) return null;
    }
    return false; // All vertical → figure text
}

fn classifySpacing(p: Paragraph, standard_font_size: ?f64, average_word_spacing: f64) ?bool {
    // Calculate word spacing
    var word_spaces: std.ArrayList(f64) = .empty;
    defer word_spaces.deinit(std.heap.page_allocator);

    for (p.lines) |line| {
        if (line.words.len < 2) continue;
        var i: usize = 0;
        while (i < line.words.len - 1) : (i += 1) {
            const space = line.words[i + 1].boundary.x1 - line.words[i].boundary.x2;
            if (space > 0) {
                word_spaces.append(std.heap.page_allocator, space) catch continue;
            }
        }
    }

    if (word_spaces.items.len > 0) {
        var sum: f64 = 0;
        for (word_spaces.items) |s| sum += s;
        const avg = sum / @as(f64, @floatFromInt(word_spaces.items.len));
        if (avg > average_word_spacing + 5) {
            // Check it's not large font (large font is NOT figure text in this context)
            const sf = standard_font_size orelse return false;
            var total: u32 = 0;
            var non_standard: u32 = 0;
            for (p.lines) |line| {
                for (line.words) |word| {
                    if (word.font_size) |fs| {
                        total += 1;
                        if (fs - sf > 1) non_standard += 1;
                    }
                }
            }
            if (total > 0 and @as(f64, @floatFromInt(non_standard)) / @as(f64, @floatFromInt(total)) > 0.95) {
                return null; // Large font, not figure text from spacing perspective
            }
            return false; // Figure text
        }
    }
    return null;
}

fn classifyLineWidth(p: Paragraph, standard_width: ?f64) ?bool {
    const sw = standard_width orelse return null;
    if (p.lines.len > 2 and @abs(p.boundary.width() - sw) < layout.LineWidthBucketSize) {
        return true; // Body text
    }
    return null;
}

fn classifySmallFont(p: Paragraph, standard_font_size: ?f64) ?bool {
    const sf = standard_font_size orelse return null;
    var total: u32 = 0;
    var small: u32 = 0;
    for (p.lines) |line| {
        for (line.words) |word| {
            if (word.font_size) |fs| {
                total += 1;
                if (sf - fs > 0.1) small += 1;
            }
        }
    }
    if (total > 0 and @as(f64, @floatFromInt(small)) / @as(f64, @floatFromInt(total)) > 0.95) {
        return false; // Figure text
    }
    return null;
}

const TextAlignmentTolerance = 2.0;
const MinSharedMargin = 0.1;

fn isAlignedOrCentered(boundary: Box, dl: *const DocumentLayout) bool {
    const is_center = if (dl.standard_width_bucketed) |sw| blk: {
        const x1 = boundary.xCenter() - sw / TextAlignmentTolerance;
        const x1_floor: i32 = @intFromFloat(@floor(x1));
        const x1_ceil: i32 = @intFromFloat(@ceil(x1));
        var margin_count: f64 = 0;
        if (dl.left_margins.get(x1_floor)) |f| margin_count += f;
        if (dl.left_margins.get(x1_ceil)) |f| margin_count += f;
        break :blk margin_count > MinSharedMargin;
    } else false;

    const left_aligned = if (dl.trust_left_margin) blk: {
        const x1_floor: i32 = @intFromFloat(@floor(boundary.x1));
        const x1_ceil: i32 = @intFromFloat(@ceil(boundary.x1));
        var margin_count: f64 = 0;
        if (dl.left_margins.get(x1_floor)) |f| margin_count += f;
        if (dl.left_margins.get(x1_ceil)) |f| margin_count += f;
        break :blk margin_count > MinSharedMargin;
    } else false;

    return left_aligned or is_center;
}

fn matchesNumberRegex(text: []const u8) bool {
    if (text.len == 0) return false;
    if (text[0] < '1' or text[0] > '9') return false;
    var i: usize = 1;
    while (i < text.len) : (i += 1) {
        const c = text[i];
        if (c == '.') {
            i += 1;
            if (i >= text.len) return true;
            if (text[i] < '1' or text[i] > '9') return false;
        } else if (c >= '0' and c <= '9') {
            continue;
        } else {
            return false;
        }
    }
    return true;
}

fn matchesRomanNumeralRegex(text: []const u8) bool {
    if (text.len == 0) return false;
    for (text) |c| {
        if (c == 'I' or c == 'V' or c == 'X') continue;
        if (c == '.') continue;
        return false;
    }
    return text[0] == 'I' or text[0] == 'V' or text[0] == 'X';
}

fn matchesLetterNumberRegex(text: []const u8) bool {
    if (text.len < 2) return false;
    if (!std.ascii.isUpper(text[0])) return false;
    if (text[1] == '.') return true;
    var i: usize = 1;
    while (i < text.len) : (i += 1) {
        const c = text[i];
        if (c >= '1' and c <= '9') continue;
        if (c == '.') continue;
        return false;
    }
    return true;
}

fn matchesAppendixRegex(text: []const u8) bool {
    if (text.len < 8) return false;
    const lower = blk: {
        var buf: [16]u8 = undefined;
        const n = @min(text.len, buf.len);
        for (text[0..n], 0..) |c, j| {
            buf[j] = std.ascii.toLower(c);
        }
        break :blk buf[0..n];
    };
    return std.mem.startsWith(u8, lower, "appendix");
}

fn isPrefixed(line: Line) bool {
    if (line.words.len == 1) return false;
    const first = line.words[0].text;
    return matchesNumberRegex(first) or
        matchesRomanNumeralRegex(first) or
        matchesLetterNumberRegex(first) or
        matchesAppendixRegex(first);
}

fn isTitleStartText(line: Line) bool {
    if (line.words.len == 0) return false;
    const text = line.words[0].text;
    if (text.len <= 1) return false;
    return std.ascii.isUpper(text[0]) or isPrefixed(line);
}

fn isTitleStyle(line: Line, dl: *const DocumentLayout) bool {
    var total_words: u32 = 0;
    var non_standard_font: u32 = 0;
    var small_font_count: u32 = 0;
    var common_font_name: ?[]const u8 = null;
    var same_font = true;

    for (line.words) |word| {
        total_words += 1;
        if (word.font_name) |fnm| {
            if (common_font_name) |cfn| {
                if (!std.mem.eql(u8, fnm, cfn)) same_font = false;
            } else {
                common_font_name = fnm;
            }
            if (dl.font_fractions.get(fnm)) |frac| {
                if (frac < 0.1) non_standard_font += 1;
            } else {
                non_standard_font += 1;
            }
        }
        if (word.font_size) |fs| {
            if (dl.standard_font_size) |sf| {
                if (sf < 20 and fs < sf - 1.0) small_font_count += 1;
            }
        }
    }

    const trust_font_size = dl.standard_font_size != null and dl.standard_font_size.? < 20;
    const small_font = trust_font_size and small_font_count > total_words / 2;

    var has_lowercase = false;
    for (line.words) |word| {
        for (word.text) |c| {
            if (std.ascii.isLower(c)) {
                has_lowercase = true;
                break;
            }
        }
        if (has_lowercase) break;
    }
    const is_all_caps = !has_lowercase;

    return same_font and (!small_font and non_standard_font > total_words / 2 or is_all_caps);
}

fn classifyIsTitle(p: Paragraph, dl: *const DocumentLayout) ?bool {
    if (p.lines.len > 3) return null;
    if (!isAlignedOrCentered(p.boundary, dl)) return null;
    if (!isTitleStartText(p.lines[0])) return null;
    for (p.lines) |line| {
        if (!isTitleStyle(line, dl)) return null;
    }
    return true; // Title → body text
}

fn classifyMargins(p: Paragraph, trust_left_margin: bool, left_margins: std.AutoHashMap(i32, f64)) ?bool {
    const area = p.boundary.area();
    if (!trust_left_margin) {
        return area > 7000;
    }
    // Check if the paragraph is aligned with common left margins
    const x1 = p.boundary.x1;
    const x1_floor: i32 = @intFromFloat(@floor(x1));
    const x1_ceil: i32 = @intFromFloat(@ceil(x1));

    var margin_count: f64 = 0;
    if (left_margins.get(x1_floor)) |f| margin_count += f;
    if (left_margins.get(x1_ceil)) |f| margin_count += f;

    if (margin_count > 0.18 and area > 100) {
        return true; // Body text
    }
    return area > 7000;
}

/// Split a paragraph into smaller paragraphs that don't intersect captions.
fn splitAroundCaptions(
    allocator: std.mem.Allocator,
    p: Paragraph,
    captions: []const CaptionParagraphType,
) ![]const Paragraph {
    var intersects_caption = false;
    var caption_boundaries = std.ArrayList(Box).empty;

    for (captions) |c| {
        if (p.boundary.intersects(c.boundary(), -2)) {
            intersects_caption = true;
            try caption_boundaries.append(allocator, c.boundary());
        }
    }

    if (!intersects_caption) {
        var result = try allocator.alloc(Paragraph, 1);
        result[0] = p;
        return result;
    }

    const cap_boxes = caption_boundaries.items;

    // If all lines intersect captions, can't split
    var all_intersect = true;
    for (p.lines) |l| {
        if (!l.boundary.intersectsAny(cap_boxes, 1.0)) {
            all_intersect = false;
            break;
        }
    }
    if (all_intersect) {
        var result = try allocator.alloc(Paragraph, 1);
        result[0] = p;
        return result;
    }

    // Build split paragraphs: groups of consecutive lines that don't intersect captions
    var split_paras = std.ArrayList(Paragraph).empty;

    var new_lines = std.ArrayList(Line).empty;
    try new_lines.append(allocator, p.lines[0]);
    var new_box = p.lines[0].boundary;

    for (p.lines[1..]) |next| {
        const combined_box = new_box.containerBox(next.boundary);
        if (combined_box.intersectsAny(cap_boxes, 1.0)) {
            if (new_lines.items.len > 0) {
                try split_paras.append(allocator, Paragraph.init(try new_lines.toOwnedSlice(allocator)));
            }
            new_lines = std.ArrayList(Line).empty;
            try new_lines.append(allocator, next);
            new_box = next.boundary;
        } else {
            new_box = combined_box;
            try new_lines.append(allocator, next);
        }
    }
    if (new_lines.items.len > 0) {
        try split_paras.append(allocator, Paragraph.init(try new_lines.toOwnedSlice(allocator)));
    }

    return split_paras.items;
}

/// Split full-width paragraphs into column-specific paragraphs on two-column pages.
/// MuPDF sometimes creates paragraphs spanning both columns, while PDFBox creates
/// separate paragraphs per column. This difference causes figure proposal failures
/// when full-width body text blocks captions in both columns.
fn splitColumnSpanningParagraphs(
    allocator: std.mem.Allocator,
    paragraphs: []const Paragraph,
    doc_layout: DocumentLayout,
) ![]const Paragraph {
    if (!doc_layout.two_columns) return paragraphs;

    // Compute column center from all paragraph boxes
    var all_boxes = std.ArrayList(Box).empty;
    defer all_boxes.deinit(allocator);
    for (paragraphs) |p| {
        try all_boxes.append(allocator, p.boundary);
    }
    if (all_boxes.items.len == 0) return paragraphs;
    const text_center = Box.container(all_boxes.items).xCenter();

    var result = std.ArrayList(Paragraph).empty;
    for (paragraphs) |p| {
        if (p.boundary.x1 < text_center and p.boundary.x2 > text_center) {
            // This paragraph spans both columns, try to split it
            var left_lines = std.ArrayList(Line).empty;
            var right_lines = std.ArrayList(Line).empty;
            for (p.lines) |l| {
                if (l.boundary.xCenter() < text_center) {
                    try left_lines.append(allocator, l);
                } else {
                    try right_lines.append(allocator, l);
                }
            }
            if (left_lines.items.len > 0) {
                try result.append(allocator, Paragraph.init(try left_lines.toOwnedSlice(allocator)));
            }
            if (right_lines.items.len > 0) {
                try result.append(allocator, Paragraph.init(try right_lines.toOwnedSlice(allocator)));
            }
            if (left_lines.items.len == 0 and right_lines.items.len == 0) {
                try result.append(allocator, p);
            }
        } else {
            try result.append(allocator, p);
        }
    }
    return result.items;
}

/// Classify paragraphs on a page into body text and "other" text.
pub fn classifyRegions(
    allocator: std.mem.Allocator,
    page_captions: PageWithCaptions,
    doc_layout: DocumentLayout,
) !PageWithBodyText {
    // Split full-width paragraphs that span both columns
    const column_paras = try splitColumnSpanningParagraphs(allocator, page_captions.paragraphs, doc_layout);
    if (doc_layout.two_columns and column_paras.len != page_captions.paragraphs.len) {}

    // Split paragraphs around captions
    var separated_paras = std.ArrayList(Paragraph).empty;
    for (column_paras) |p| {
        const splits = try splitAroundCaptions(allocator, p, page_captions.captions);
        try separated_paras.appendSlice(allocator, splits);
    }

    // Build classifier sieve
    const sieve = [_]Classifier{
        .{ .graphic_overlaps = page_captions.graphics },
        .vertical_text,
        .{ .spacing = .{ .standard_font_size = doc_layout.standard_font_size, .average_word_spacing = doc_layout.average_word_spacing } },
        .{ .line_width = doc_layout.standard_width_bucketed },
        .{ .small_font = doc_layout.standard_font_size },
        .{ .is_title = &doc_layout },
        .{ .margins = .{ .trust_left_margin = doc_layout.trust_left_margin, .left_margins = doc_layout.left_margins } },
    };

    var body_text = std.ArrayList(Paragraph).empty;
    var other_text = std.ArrayList(Paragraph).empty;

    for (separated_paras.items) |para| {
        var is_body: bool = true; // Default to body text
        for (sieve) |classifier| {
            if (classifier.classify(para)) |result| {
                is_body = result;
                break;
            }
        }
        if (is_body) {
            try body_text.append(allocator, para);
        } else {
            try other_text.append(allocator, para);
        }
    }

    // Detect graphics that contain captions (figure bounding boxes)
    var figures_bbox_graphics = std.ArrayList(Box).empty;
    var rest_graphics = std.ArrayList(Box).empty;

    for (page_captions.graphics) |graphic_region| {
        var contains_caption = false;
        for (page_captions.captions) |c| {
            if (graphic_region.contains(c.boundary(), 1.0) and
                graphic_region.intersectArea(c.boundary()) / graphic_region.area() < 0.50)
            {
                contains_caption = true;
                break;
            }
        }
        if (contains_caption) {
            var paragraph_overlaps = false;
            for (page_captions.paragraphs) |para| {
                if (!graphic_region.contains(para.boundary, 1.0) and
                    para.boundary.intersects(graphic_region, 1.0))
                {
                    paragraph_overlaps = true;
                    break;
                }
            }
            if (!paragraph_overlaps) {
                try figures_bbox_graphics.append(allocator, graphic_region);
                continue;
            }
        }
        try rest_graphics.append(allocator, graphic_region);
    }

    // Create figure bounding box borders
    var figure_borders = std.ArrayList(Box).empty;
    for (figures_bbox_graphics.items) |box| {
        try figure_borders.appendSlice(allocator, &.{
            Box.init(box.x1, box.y1, box.x1, box.y2),
            Box.init(box.x2, box.y1, box.x2, box.y2),
            Box.init(box.x1, box.y1, box.x2, box.y1),
            Box.init(box.x1, box.y2, box.x2, box.y2),
        });
    }

    // Crop figure bounding graphics slightly
    var cropped_figure_graphics = std.ArrayList(Box).empty;
    for (figures_bbox_graphics.items) |box| {
        try cropped_figure_graphics.append(allocator, Box.init(
            box.x1 + 3,
            box.y1 + 3,
            box.x2 - 3,
            box.y2 - 3,
        ));
    }

    // Combine: rest graphics + cropped figure graphics (matching Scala)
    var final_graphics = std.ArrayList(Box).empty;
    try final_graphics.appendSlice(allocator, rest_graphics.items);
    try final_graphics.appendSlice(allocator, cropped_figure_graphics.items);

    var final_non_figure = std.ArrayList(Box).empty;
    try final_non_figure.appendSlice(allocator, page_captions.non_figure_graphics);
    try final_non_figure.appendSlice(allocator, figure_borders.items);

    return PageWithBodyText.init(
        page_captions.page_number,
        page_captions.classified_text,
        page_captions.captions,
        final_graphics.items,
        final_non_figure.items,
        body_text.items,
        other_text.items,
    );
}

test "classifyVerticalText non-vertical" {
    const word = Word{ .text = "test", .boundary = Box.init(0, 0, 20, 10), .font_name = null, .font_size = null };
    const line = Line.init(&.{word}, 0);
    const p = Paragraph.init(&.{line});
    try std.testing.expectEqual(@as(?bool, null), classifyVerticalText(p));
}