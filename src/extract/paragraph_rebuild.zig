// Paragraph rebuilding: merges PDFBox-split paragraphs back together.
// Direct translation of ParagraphRebuilder.scala.

const std = @import("std");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const page = @import("../page.zig");
const PageWithClassifiedText = page.PageWithClassifiedText;
const ClassifiedText = page.ClassifiedText;
const layout = @import("../layout.zig");
const DocumentLayout = layout.DocumentLayout;

const MaxIndentSize: f64 = 20;
const MinIndentSize: f64 = 3;
const MinLineContinuationXDist: f64 = 15;
const MinLineContinuationVerticalOverlap: f64 = 0.8;
const TextAlignmentTolerance: f64 = 2.0;
const LineSpacingPadding: f64 = 0.5;

/// Rebuild paragraphs on a page by merging those that appear to be continuations.
pub fn rebuildParagraphs(
    arena: std.mem.Allocator,
    page_with_text: PageWithClassifiedText,
    doc_layout: DocumentLayout,
) !PageWithClassifiedText {
    const merged = try mergeSortedParagraphs(arena, page_with_text.paragraphs, doc_layout.median_line_spacing);
    return PageWithClassifiedText.init(page_with_text.page_number, merged, page_with_text.classified_text);
}

/// Merges paragraphs that appear to be part of the same paragraph.
fn mergeSortedParagraphs(
    arena: std.mem.Allocator,
    paragraphs: []const Paragraph,
    median_line_spacing: f64,
) ![]const Paragraph {
    if (paragraphs.len == 0) return &.{};

    var result = std.ArrayList(Paragraph).empty;
    var on_paragraph = paragraphs[0];

    for (paragraphs[1..]) |para| {
        const should_merge = blk: {
            const continues_reading_order = on_paragraph.span().end == para.span().start - 1;
            const cur_bb = on_paragraph.boundary;
            const y_dist = para.boundary.y1 - cur_bb.y2;
            const below_line = y_dist > -4 and y_dist < median_line_spacing + LineSpacingPadding and
                cur_bb.horizontallyAligned(para.boundary, 0);

            const left_aligned = @abs(cur_bb.x1 - para.boundary.x1) < TextAlignmentTolerance;
            const right_aligned = @abs(cur_bb.x2 - para.boundary.x2) < TextAlignmentTolerance;
            const indent = para.lines[0].boundary.x1 - cur_bb.x1;
            const indented = indent > MinIndentSize and indent < MaxIndentSize;
            const prev_line_indented = -indent > MinIndentSize and -indent < MaxIndentSize;

            const x_dist = para.boundary.x1 - cur_bb.x2;
            const vertical_overlap = @min(cur_bb.y2, para.boundary.y2) -
                @max(cur_bb.y1, para.boundary.y1);
            const vertically_aligned = x_dist < MinLineContinuationXDist and
                vertical_overlap / @min(para.boundary.height(), cur_bb.height()) >
                MinLineContinuationVerticalOverlap;

            break :blk continues_reading_order and (vertically_aligned or
                below_line and ((!indented and left_aligned) or (prev_line_indented and right_aligned)));
        };

        if (should_merge) {
            // Merge: concatenate lines
            const merged_lines = try arena.alloc(paragraph.Line, on_paragraph.lines.len + para.lines.len);
            @memcpy(merged_lines[0..on_paragraph.lines.len], on_paragraph.lines);
            @memcpy(merged_lines[on_paragraph.lines.len..], para.lines);
            on_paragraph = Paragraph.init(merged_lines);
        } else {
            try result.append(arena, on_paragraph);
            on_paragraph = para;
        }
    }
    try result.append(arena, on_paragraph);

    return result.items;
}

test {
    _ = Box;
}

test "rebuildParagraphs empty" {
    const ct = ClassifiedText{};
    const page_with_text = PageWithClassifiedText.init(1, &.{}, ct);
    var dl = DocumentLayout{
        .two_columns = false,
        .font_fractions = std.StringHashMap(f64).init(std.testing.allocator),
        .standard_font_size = null,
        .average_font_size = 12,
        .average_word_spacing = 2.5,
        .trust_left_margin = true,
        .left_margins = std.AutoHashMap(i32, f64).init(std.testing.allocator),
        .median_line_spacing = 14,
        .standard_width_bucketed = null,
    };
    defer dl.font_fractions.deinit();
    defer dl.left_margins.deinit();
    const result = try rebuildParagraphs(std.testing.allocator, page_with_text, dl);
    try std.testing.expectEqual(@as(u32, 1), result.page_number);
    try std.testing.expectEqual(@as(usize, 0), result.paragraphs.len);
}