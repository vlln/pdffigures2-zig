// Caption builder: expands caption-start lines into full caption paragraphs.
// Direct translation of CaptionBuilder.scala.
//
// Font-based heuristics are simplified since font_name is not yet populated from MuPDF.

const std = @import("std");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const Line = paragraph.Line;
const Word = paragraph.Word;
const TextSpan = paragraph.TextSpan;
const figure = @import("../figure.zig");
const FigureType = figure.FigureType;
const CaptionParagraph = figure.CaptionParagraph;
const page = @import("../page.zig");
const PageWithCaptions = page.PageWithCaptions;
const ClassifiedText = page.ClassifiedText;
const caption_detector = @import("caption.zig");
const CaptionStart = caption_detector.CaptionStart;

const AlignmentTolerance: f64 = 2.0;
const GraphicIntersectTolerance: f64 = -2.0;
const LargeParagraphNumberOfLines: f64 = 5.0;
const MedianSpacingPadding: f64 = 0.2;
const MaxAdditionalSpacing: f64 = 2.0;
const LineContinuationMaxYDifference: f64 = 3.0;
const LineContinuationMaxXDifference: f64 = 12.0;
const MinYDistBetweenLines: f64 = -40;
const LeftEdgeDifferenceTolerance: f64 = 30;

/// Build captions from caption start candidates.
pub fn buildCaptions(
    arena: std.mem.Allocator,
    candidates: []const CaptionStart,
    page_text: PageWithGraphics,
    median_line_spacing: f64,
) !PageWithCaptions {
    if (candidates.len == 0) {
        return PageWithCaptions.init(
            page_text.page_number,
            &.{},
            page_text.graphics,
            page_text.non_figure_graphics,
            page_text.paragraphs,
            page_text.classified_text,
        );
    }

    const safe_line_spacing = median_line_spacing + MedianSpacingPadding;

    // Collect caption start line numbers
    var caption_start_locations = std.ArrayList(u32).empty;
    for (candidates) |c| {
        try caption_start_locations.append(arena, c.line.line_number);
    }

    // Build each caption
    var captions = std.ArrayList(CaptionParagraph).empty;
    for (candidates) |c| {
        const cp = try buildCaption(
            arena,
            c,
            caption_start_locations.items,
            page_text.paragraphs,
            page_text.graphics,
            safe_line_spacing,
        );
        try captions.append(arena, cp);
    }

    // Remove caption text from paragraphs
    var caption_spans = std.ArrayList(TextSpan).empty;
    for (captions.items) |cp| {
        try caption_spans.append(arena, cp.paragraph.span());
    }

    var stripped_result = try paragraph.removeSpans(arena, caption_spans.items, page_text.paragraphs);
    defer stripped_result.deinit(arena);

    return PageWithCaptions.init(
        page_text.page_number,
        try arena.dupe(CaptionParagraph, captions.items),
        page_text.graphics,
        page_text.non_figure_graphics,
        try arena.dupe(Paragraph, stripped_result.items),
        page_text.classified_text,
    );
}

/// In-progress caption builder state.
const CaptionState = struct {
    lines: std.ArrayListUnmanaged(Line),
    boundary: Box,
    centered: bool,

    fn lastLineRightAligned(self: CaptionState) bool {
        return @abs(self.boundary.x2 - self.lines.items[self.lines.items.len - 1].boundary.x2) < 2.0;
    }

    fn addLine(self: *CaptionState, arena: std.mem.Allocator, line: Line, new_boundary: Box) !void {
        self.boundary = new_boundary;
        self.centered = self.centered and
            @abs(line.boundary.xCenter() - new_boundary.xCenter()) < 2.0;
        try self.lines.append(arena, line);
    }
};

/// Build a single caption from a CaptionStart.
fn buildCaption(
    arena: std.mem.Allocator,
    candidate: CaptionStart,
    caption_locations: []const u32,
    paragraphs: []const Paragraph,
    graphics_locations: []const Box,
    safe_line_spacing: f64,
) !CaptionParagraph {
    // Flatten: (line, paragraph) pairs
    const LineWithPara = struct { line: Line, para: Paragraph };
    var all_lines = std.ArrayList(LineWithPara).empty;
    for (paragraphs) |p| {
        for (p.lines) |l| {
            try all_lines.append(arena, .{ .line = l, .para = p });
        }
    }

    // Find lines starting at or after the caption
    var start_idx: usize = 0;
    while (start_idx < all_lines.items.len and
        all_lines.items[start_idx].line.line_number < candidate.line.line_number) : (start_idx += 1) {}

    if (start_idx >= all_lines.items.len) {
        // Shouldn't happen; return minimal caption
        const lines = [_]Line{candidate.line};
        const para = Paragraph.init(&lines);
        return CaptionParagraph.init(candidate.name, candidate.fig_type, candidate.page, para);
    }

    const starting_line = all_lines.items[start_idx].line;
    var state = CaptionState{
        .lines = .empty,
        .boundary = starting_line.boundary,
        .centered = true,
    };
    try state.lines.append(arena, starting_line);

    // Graphics to avoid (those that don't intersect the caption's start)
    var graphics_to_avoid = std.ArrayList(Box).empty;
    for (graphics_locations) |g| {
        if (!g.intersects(state.boundary, GraphicIntersectTolerance)) {
            try graphics_to_avoid.append(arena, g);
        }
    }

    // Expand caption: consume following lines as long as they appear to be part of the caption
    var i: usize = start_idx + 1;
    while (i < all_lines.items.len) {
        const lp = all_lines.items[i];
        const line_bb = lp.line.boundary;
        const current_boundary = state.boundary;
        const proposed_bb = current_boundary.containerBox(line_bb);
        const y_dist = line_bb.y1 - current_boundary.y2;
        const first_line = state.lines.items.len == 1;
        const first_line_after_single_line_header = first_line and candidate.line_end;

        // Check if any graphics to avoid intersect the proposed bounds
        var graphics_intersect = false;
        for (graphics_to_avoid.items) |ga| {
            if (ga.intersects(proposed_bb, GraphicIntersectTolerance)) {
                graphics_intersect = true;
                break;
            }
        }

        // Check if this line starts a new caption
        var is_new_caption = false;
        for (caption_locations) |cl| {
            if (lp.line.line_number == cl) {
                is_new_caption = true;
                break;
            }
        }

        const use_line: bool = if (y_dist < MinYDistBetweenLines or
            y_dist > safe_line_spacing + MaxAdditionalSpacing)
            false
        else if (graphics_intersect or is_new_caption)
            false
        else if (y_dist < LineContinuationMaxYDifference and
            state.lines.items[state.lines.items.len - 1].boundary.x2 - line_bb.x1 < LineContinuationMaxXDifference)
            true
        else if (y_dist < safe_line_spacing and y_dist > -5.0 and
            @abs(current_boundary.x1 - line_bb.x1) < AlignmentTolerance)
            true
        else blk: {
            const centered = @abs(line_bb.xCenter() - current_boundary.xCenter()) < AlignmentTolerance;
            const overlaps_horizontal = line_bb.x1 < current_boundary.x2 and
                line_bb.x2 > current_boundary.x1 and
                (current_boundary.x1 - proposed_bb.x1 < LeftEdgeDifferenceTolerance or
                first_line_after_single_line_header);
            const starting_large_paragraph = lp.line.line_number == lp.para.lines[0].line_number and
                @as(f64, @floatFromInt(lp.para.lines.len)) >= LargeParagraphNumberOfLines;
            const breaks_justification = !state.lastLineRightAligned() and !(state.centered and centered);

            break :blk overlaps_horizontal and !starting_large_paragraph and !breaks_justification;
        };

        if (use_line) {
            try state.addLine(arena, lp.line, proposed_bb);
            i += 1;
        } else {
            break;
        }
    }

    // Prune caption paragraph: clip y1 to first word's y1, y2 to last word's y2
    var pruned_bb = state.boundary;
    if (state.lines.items.len > 0 and state.lines.items[0].words.len > 0) {
        pruned_bb.y1 = state.lines.items[0].words[0].boundary.y1;
    }
    if (state.lines.items.len > 0) {
        const last_line = state.lines.items[state.lines.items.len - 1];
        if (last_line.words.len > 0) {
            pruned_bb.y2 = last_line.words[last_line.words.len - 1].boundary.y2;
        }
    }

    const lines_slice = try arena.dupe(Line, state.lines.items);
    const para = Paragraph{ .lines = lines_slice, .boundary = pruned_bb };

    return CaptionParagraph.init(candidate.name, candidate.fig_type, candidate.page, para);
}

// PageWithGraphics used by buildCaptions; defined in page.zig but we reference it here
const PageWithGraphics = page.PageWithGraphics;

test {
    _ = Box;
}