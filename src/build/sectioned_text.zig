// Sectioned text builder: organizes document text into logical sections.
// Direct translation of SectionedTextBuilder.scala.
// Currently a skeleton — full implementation pending.

const std = @import("std");
const Box = @import("../box.zig").Box;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const page = @import("../page.zig");
const ClassifiedText = page.ClassifiedText;

/// A section of a document with title and body paragraphs.
pub const DocumentSection = struct {
    title: ?[]const Paragraph,
    paragraphs: []const Paragraph,
};

/// A full document with sections and abstract.
pub const Document = struct {
    sections: []const DocumentSection,
    abstract_text: []const Paragraph,
};

/// Build sectioned text from classified pages.
pub fn buildSectionedText(
    arena: std.mem.Allocator,
    pages: []const struct {
        page_number: u32,
        classified_text: ClassifiedText,
        paragraphs: []const Paragraph,
    },
) !Document {
    _ = arena;
    _ = pages;
    return Document{ .sections = &.{}, .abstract_text = &.{} };
}

test {
    _ = Box;
}