// Figure, Caption, RasterizedFigure, SavedFigure types.
// Direct translation of Figure.scala.

const std = @import("std");
const box = @import("box.zig");
const Box = box.Box;
const paragraph = @import("paragraph.zig");
const Paragraph = paragraph.Paragraph;

pub const FigureType = enum {
    Table,
    Figure,

    pub fn toString(self: FigureType) []const u8 {
        return switch (self) {
            .Table => "Table",
            .Figure => "Figure",
        };
    }
};

pub const CaptionParagraph = struct {
    name: []const u8,
    fig_type: FigureType,
    page: u32,
    paragraph: Paragraph,

    pub fn init(name: []const u8, fig_type: FigureType, page: u32, para: Paragraph) CaptionParagraph {
        return .{ .name = name, .fig_type = fig_type, .page = page, .paragraph = para };
    }

    pub fn boundary(self: CaptionParagraph) Box {
        return self.paragraph.boundary;
    }

    pub fn startLineNumber(self: CaptionParagraph) u32 {
        return self.paragraph.startLineNumber();
    }

    pub fn text(self: CaptionParagraph, allocator: std.mem.Allocator) ![]const u8 {
        return paragraph.convertToNormalizedString(self.paragraph, allocator);
    }
};

pub const Caption = struct {
    name: []const u8,
    fig_type: FigureType,
    page: u32,
    text: []const u8,
    boundary: Box,

    pub fn fromCaptionParagraph(cp: CaptionParagraph, allocator: std.mem.Allocator) !Caption {
        const text = try cp.text(allocator);
        return .{
            .name = cp.name,
            .fig_type = cp.fig_type,
            .page = cp.page,
            .text = text,
            .boundary = cp.boundary(),
        };
    }
};

pub const Figure = struct {
    name: []const u8,
    fig_type: FigureType,
    page: u32,
    caption: []const u8,
    image_text: []const []const u8,
    caption_boundary: Box,
    region_boundary: Box,
};

/// Figure rendered to a pixel buffer.
/// `image_region` specifies exact integer pixel coordinates the image occupies within the page
/// if the page was rendered at `dpi`.
pub const RasterizedFigure = struct {
    figure: Figure,
    image_region: Box,
    image_data: []u8, // RGBA pixel data
    image_width: u32,
    image_height: u32,
    dpi: u32,

    pub fn init(
        figure: Figure,
        image_region: Box,
        image_data: []u8,
        image_width: u32,
        image_height: u32,
        dpi: u32,
    ) RasterizedFigure {
        // image_region must have integer coordinates
        std.debug.assert(image_region.x1 == @floor(image_region.x1));
        std.debug.assert(image_region.y1 == @floor(image_region.y1));
        std.debug.assert(image_region.x2 == @floor(image_region.x2));
        std.debug.assert(image_region.y2 == @floor(image_region.y2));
        return .{
            .figure = figure,
            .image_region = image_region,
            .image_data = image_data,
            .image_width = image_width,
            .image_height = image_height,
            .dpi = dpi,
        };
    }
};

/// Figure that has been saved to a URL/path.
pub const SavedFigure = struct {
    name: []const u8,
    fig_type: FigureType,
    page: u32,
    caption: []const u8,
    image_text: []const []const u8,
    caption_boundary: Box,
    region_boundary: Box,
    render_url: []const u8,
    render_dpi: u32,

    pub fn fromRasterized(figure: RasterizedFigure, render_url: []const u8) SavedFigure {
        const fig = figure.figure;
        return .{
            .name = fig.name,
            .fig_type = fig.fig_type,
            .page = fig.page,
            .caption = fig.caption,
            .image_text = fig.image_text,
            .caption_boundary = fig.caption_boundary,
            .region_boundary = figure.image_region.scale(72.0 / @as(f64, @floatFromInt(figure.dpi))),
            .render_url = render_url,
            .render_dpi = figure.dpi,
        };
    }

    pub fn fromFigure(figure: Figure, render_url: []const u8, render_dpi: u32) SavedFigure {
        return .{
            .name = figure.name,
            .fig_type = figure.fig_type,
            .page = figure.page,
            .caption = figure.caption,
            .image_text = figure.image_text,
            .caption_boundary = figure.caption_boundary,
            .region_boundary = figure.region_boundary,
            .render_url = render_url,
            .render_dpi = render_dpi,
        };
    }
};

pub const FiguresInDocument = struct {
    figures: []const Figure,
    failed_captions: []const Caption,
};

pub const RasterizedFiguresInDocument = struct {
    figures: []const RasterizedFigure,
    failed_captions: []const Caption,
};

// ---- Tests ----

test "FigureType toString" {
    try std.testing.expectEqualStrings("Figure", FigureType.Figure.toString());
    try std.testing.expectEqualStrings("Table", FigureType.Table.toString());
}

test "SavedFigure fromRasterized" {
    const fig = Figure{
        .name = "1",
        .fig_type = .Figure,
        .page = 0,
        .caption = "Test caption",
        .image_text = &[_][]const u8{},
        .caption_boundary = Box.init(0, 0, 100, 20),
        .region_boundary = Box.init(0, 20, 100, 200),
    };
    const rf = RasterizedFigure{
        .figure = fig,
        .image_region = Box.init(0, 0, 200, 400),
        .image_data = &[_]u8{},
        .image_width = 200,
        .image_height = 400,
        .dpi = 144,
    };
    const sf = SavedFigure.fromRasterized(rf, "output.png");
    try std.testing.expectEqualStrings("1", sf.name);
    try std.testing.expectEqualStrings("output.png", sf.render_url);
    try std.testing.expectEqual(@as(u32, 144), sf.render_dpi);
}