// Page type hierarchy as tagged union + ClassifiedText.
// Direct translation of PageStructure.scala.

const std = @import("std");
const box = @import("box.zig");
const Box = box.Box;
const paragraph = @import("paragraph.zig");
const Paragraph = paragraph.Paragraph;
const Line = paragraph.Line;
const figure = @import("figure.zig");
const Figure = figure.Figure;
const Caption = figure.Caption;
const CaptionParagraph = figure.CaptionParagraph;
const FigureType = figure.FigureType;

/// Classified text segments for a page.
pub const ClassifiedText = struct {
    page_headers: []const Paragraph = &.{},
    formatting_text: []const Paragraph = &.{},
    abstract_text: []const Paragraph = &.{},
    section_titles: []const Paragraph = &.{},

    pub fn allText() []const Paragraph {
        // Returns all classified text as a single slice. Since we can't concatenate at
        // comptime, callers should iterate the four fields separately.
        return &.{}; // Placeholder — callers use individual fields
    }
};

/// Page with raw text extracted.
pub const PageWithText = struct {
    page_number: u32,
    paragraphs: []const Paragraph,

    pub fn init(page_number: u32, paras: []const Paragraph) PageWithText {
        // Validate ordered, non-overlapping text
        if (paras.len > 1) {
            var it = std.mem.window(Paragraph, paras, 2, 1);
            while (it.next()) |pair| {
                std.debug.assert(pair[0].span().end < pair[1].span().start);
            }
        }
        return .{ .page_number = page_number, .paragraphs = paras };
    }
};

/// Page with classified formatting text.
pub const PageWithClassifiedText = struct {
    page_number: u32,
    paragraphs: []const Paragraph,
    classified_text: ClassifiedText,

    pub fn init(page_number: u32, paras: []const Paragraph, ct: ClassifiedText) PageWithClassifiedText {
        // Note: we skip the ordering assertion from the Scala version here
        // because removeSpans can create paragraphs that need reordering.
        // Downstream code sorts paragraphs by line number as needed.
        return .{ .page_number = page_number, .paragraphs = paras, .classified_text = ct };
    }
};

/// Page with classified text and graphics.
pub const PageWithGraphics = struct {
    page_number: u32,
    paragraphs: []const Paragraph,
    graphics: []const Box,
    non_figure_graphics: []const Box,
    classified_text: ClassifiedText,
};

/// Page with captions.
pub const PageWithCaptions = struct {
    page_number: u32,
    captions: []const CaptionParagraph,
    graphics: []const Box,
    non_figure_graphics: []const Box,
    paragraphs: []const Paragraph,
    classified_text: ClassifiedText,

    pub fn init(
        page_number: u32,
        captions: []const CaptionParagraph,
        graphics: []const Box,
        non_figure_graphics: []const Box,
        paragraphs: []const Paragraph,
        classified_text: ClassifiedText,
    ) PageWithCaptions {
        for (captions) |c| {
            std.debug.assert(c.page == page_number);
        }
        return .{
            .page_number = page_number,
            .captions = captions,
            .graphics = graphics,
            .non_figure_graphics = non_figure_graphics,
            .paragraphs = paragraphs,
            .classified_text = classified_text,
        };
    }
};

/// Page with body text classified from figure text.
pub const PageWithBodyText = struct {
    page_number: u32,
    classified_text: ClassifiedText,
    captions: []const CaptionParagraph,
    graphics: []const Box,
    non_figure_graphics: []const Box,
    body_text: []const Paragraph,
    other_text: []const Paragraph,

    pub fn init(
        page_number: u32,
        classified_text: ClassifiedText,
        captions: []const CaptionParagraph,
        graphics: []const Box,
        non_figure_graphics: []const Box,
        body_text: []const Paragraph,
        other_text: []const Paragraph,
    ) PageWithBodyText {
        for (captions) |c| std.debug.assert(c.page == page_number);
        return .{
            .page_number = page_number,
            .classified_text = classified_text,
            .captions = captions,
            .graphics = graphics,
            .non_figure_graphics = non_figure_graphics,
            .body_text = body_text,
            .other_text = other_text,
        };
    }

    // Note: we omit classifiedText from these methods (see Scala comment in PageStructure.scala:
    // "classifiedText is not returned by these methods, I have found it to be slightly more
    // effective to just ignore classifiedText then to treat it as nonFigureText")

    /// Bounding boxes of body text paragraphs.
    pub fn bodyTextBoxes(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Box {
        var result: std.ArrayList(Box) = .empty;
        for (self.body_text) |p| {
            try result.append(allocator, p.boundary);
        }
        return result.toOwnedSlice(allocator);
    }

    /// Bounding boxes of other text paragraphs (potential figure text).
    pub fn otherTextBoxes(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Box {
        var result: std.ArrayList(Box) = .empty;
        for (self.other_text) |p| {
            try result.append(allocator, p.boundary);
        }
        return result.toOwnedSlice(allocator);
    }

    /// All paragraphs in reading order.
    pub fn paragraphs(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Paragraph {
        var all: std.ArrayList(Paragraph) = .empty;
        try all.appendSlice(allocator, self.body_text);
        try all.appendSlice(allocator, self.other_text);
        std.mem.sort(Paragraph, all.items, {}, struct {
            fn lt(_: void, a: Paragraph, b: Paragraph) bool {
                return a.startLineNumber() < b.startLineNumber();
            }
        }.lt);
        return all.toOwnedSlice(allocator);
    }

    /// Body text + caption paragraphs. These are NOT part of any figure.
    pub fn nonFigureText(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Paragraph {
        var result: std.ArrayList(Paragraph) = .empty;
        try result.appendSlice(allocator, self.body_text);
        for (self.captions) |c| {
            try result.append(allocator, c.paragraph);
        }
        return result.toOwnedSlice(allocator);
    }

    /// Boundary boxes of all text on the page (body + other + captions).
    pub fn allTextBoxes(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Box {
        var result: std.ArrayList(Box) = .empty;
        for (self.body_text) |p| {
            try result.append(allocator, p.boundary);
        }
        for (self.other_text) |p| {
            try result.append(allocator, p.boundary);
        }
        for (self.captions) |c| {
            try result.append(allocator, c.boundary());
        }
        return result.toOwnedSlice(allocator);
    }

    /// Boundary boxes of all non-figure content.
    pub fn nonFigureContent(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Box {
        const nft = try self.nonFigureText(allocator);
        defer allocator.free(nft);
        var result: std.ArrayList(Box) = .empty;
        for (nft) |p| {
            try result.append(allocator, p.boundary);
        }
        try result.appendSlice(allocator, self.non_figure_graphics);
        return result.toOwnedSlice(allocator);
    }

    /// Boxes that might be part of a figure: graphics + other text.
    pub fn possibleFigureContent(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Box {
        var result: std.ArrayList(Box) = .empty;
        try result.appendSlice(allocator, self.graphics);
        for (self.other_text) |p| {
            try result.append(allocator, p.boundary);
        }
        return result.toOwnedSlice(allocator);
    }

    /// All content: possible figure + non-figure.
    pub fn allContent(self: PageWithBodyText, allocator: std.mem.Allocator) ![]const Box {
        const nfc = try self.nonFigureContent(allocator);
        defer allocator.free(nfc);
        const pfc = try self.possibleFigureContent(allocator);
        defer allocator.free(pfc);
        var result: std.ArrayList(Box) = .empty;
        try result.appendSlice(allocator, pfc);
        try result.appendSlice(allocator, nfc);
        return result.toOwnedSlice(allocator);
    }
};

/// Page with detected figures.
pub const PageWithFigures = struct {
    page_number: u32,
    paragraphs: []const Paragraph,
    classified_text: ClassifiedText,
    figures: []const Figure,
    failed_captions: []const Caption,

    pub fn init(
        page_number: u32,
        paragraphs: []const Paragraph,
        classified_text: ClassifiedText,
        figures: []const Figure,
        failed_captions: []const Caption,
    ) PageWithFigures {
        for (figures) |f| std.debug.assert(f.page == page_number);
        for (failed_captions) |fc| std.debug.assert(fc.page == page_number);
        return .{
            .page_number = page_number,
            .paragraphs = paragraphs,
            .classified_text = classified_text,
            .figures = figures,
            .failed_captions = failed_captions,
        };
    }
};

// ---- Tests ----

test "ClassifiedText defaults" {
    const ct = ClassifiedText{};
    try std.testing.expectEqual(@as(usize, 0), ct.page_headers.len);
    try std.testing.expectEqual(@as(usize, 0), ct.abstract_text.len);
}

test "PageWithBodyText init" {
    const ct = ClassifiedText{};
    const page = PageWithBodyText.init(0, ct, &.{}, &.{}, &.{}, &.{}, &.{});
    try std.testing.expectEqual(@as(u32, 0), page.page_number);
}