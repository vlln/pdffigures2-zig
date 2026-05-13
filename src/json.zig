// JSON serialization for output types (Figure, Caption, etc.).
// Direct translation of JsonProtocol.scala.
// Uses std.json.stringify for serialization.

const std = @import("std");
const figure = @import("figure.zig");
const Figure = figure.Figure;
const Caption = figure.Caption;
const Box = @import("box.zig").Box;

/// Serializable representation of a Figure for JSON output.
pub const FigureJson = struct {
    name: []const u8,
    figType: []const u8,
    page: u32,
    caption: []const u8,
    captionBoundary: BoxJson,
    regionBoundary: BoxJson,
    imageText: []const []const u8,
};

/// Serializable representation of a regionless caption for JSON output.
pub const RegionlessCaptionJson = struct {
    name: []const u8,
    figType: []const u8,
    page: u32,
    text: []const u8,
    boundary: BoxJson,
};

/// Serializable representation of a Box for JSON output.
pub const BoxJson = struct {
    x1: f64,
    y1: f64,
    x2: f64,
    y2: f64,
};

/// Top-level JSON output matching Scala's format.
pub const FiguresDocumentJson = struct {
    figures: []const FigureJson,
    @"regionless-captions": []const RegionlessCaptionJson,
};

/// Convert a Figure to its JSON-serializable form.
pub fn figureToJson(fig: Figure) FigureJson {
    return .{
        .name = fig.name,
        .figType = @tagName(fig.fig_type),
        .page = fig.page,
        .caption = fig.caption,
        .captionBoundary = boxToJson(fig.caption_boundary),
        .regionBoundary = boxToJson(fig.region_boundary),
        .imageText = fig.image_text,
    };
}

/// Convert a failed Caption to its JSON-serializable form.
pub fn captionToJson(cap: Caption) RegionlessCaptionJson {
    return .{
        .name = cap.name,
        .figType = @tagName(cap.fig_type),
        .page = cap.page,
        .text = cap.text,
        .boundary = boxToJson(cap.boundary),
    };
}

/// Convert a Box to its JSON-serializable form.
pub fn boxToJson(b: Box) BoxJson {
    return .{ .x1 = b.x1, .y1 = b.y1, .x2 = b.x2, .y2 = b.y2 };
}

/// Serialize figures and failed captions to a JSON string matching Scala format.
pub fn figuresDocumentToJson(
    allocator: std.mem.Allocator,
    figures: []const Figure,
    failed_captions: []const Caption,
) ![]const u8 {
    var json_figs: std.ArrayList(FigureJson) = .empty;
    defer json_figs.deinit(allocator);
    for (figures) |fig| {
        try json_figs.append(allocator, figureToJson(fig));
    }

    var json_caps: std.ArrayList(RegionlessCaptionJson) = .empty;
    defer json_caps.deinit(allocator);
    for (failed_captions) |cap| {
        try json_caps.append(allocator, captionToJson(cap));
    }

    const doc = FiguresDocumentJson{
        .figures = json_figs.items,
        .@"regionless-captions" = json_caps.items,
    };
    return std.json.Stringify.valueAlloc(allocator, doc, .{});
}

/// Serialize figures only (legacy flat array format, used only for tests).
pub fn figuresToJson(allocator: std.mem.Allocator, figures: []const Figure) ![]const u8 {
    var json_figs: std.ArrayList(FigureJson) = .empty;
    defer json_figs.deinit(allocator);
    for (figures) |fig| {
        try json_figs.append(allocator, figureToJson(fig));
    }
    return std.json.Stringify.valueAlloc(allocator, json_figs.items, .{});
}

test "boxToJson" {
    const b = Box.init(1, 2, 3, 4);
    const bj = boxToJson(b);
    try std.testing.expectEqual(@as(f64, 1), bj.x1);
    try std.testing.expectEqual(@as(f64, 4), bj.y2);
}

test "figureToJson" {
    const fig = Figure{
        .name = "1",
        .fig_type = figure.FigureType.Figure,
        .page = 1,
        .caption = "Test caption",
        .caption_boundary = Box.init(0, 0, 10, 10),
        .region_boundary = Box.init(0, 0, 100, 100),
        .image_text = &.{},
    };
    const fj = figureToJson(fig);
    try std.testing.expectEqualStrings("1", fj.name);
    try std.testing.expectEqualStrings("Figure", fj.figType);
}

test "captionToJson" {
    const cap = Caption{
        .name = "2",
        .fig_type = figure.FigureType.Table,
        .page = 3,
        .text = "Table caption",
        .boundary = Box.init(10, 20, 30, 40),
    };
    const cj = captionToJson(cap);
    try std.testing.expectEqualStrings("2", cj.name);
    try std.testing.expectEqualStrings("Table", cj.figType);
    try std.testing.expectEqualStrings("Table caption", cj.text);
    try std.testing.expectEqual(@as(f64, 10), cj.boundary.x1);
}

test "figuresDocumentToJson" {
    const fig = Figure{
        .name = "1",
        .fig_type = figure.FigureType.Figure,
        .page = 1,
        .caption = "Test",
        .caption_boundary = Box.init(0, 0, 10, 10),
        .region_boundary = Box.init(0, 0, 100, 100),
        .image_text = &.{},
    };
    const cap = Caption{
        .name = "A",
        .fig_type = figure.FigureType.Figure,
        .page = 2,
        .text = "No region",
        .boundary = Box.init(5, 5, 15, 15),
    };
    const json_str = try figuresDocumentToJson(std.testing.allocator, &.{fig}, &.{cap});
    defer std.testing.allocator.free(json_str);
    try std.testing.expect(std.mem.containsAtLeast(u8, json_str, 1, "figures"));
    try std.testing.expect(std.mem.containsAtLeast(u8, json_str, 1, "regionless-captions"));
    try std.testing.expect(std.mem.containsAtLeast(u8, json_str, 1, "No region"));
}