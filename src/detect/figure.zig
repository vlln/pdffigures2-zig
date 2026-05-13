// Figure detection: proposes figure regions around captions and scores them.
// Direct translation of FigureDetector.scala.
// Proposes candidate figure regions in four directions around each caption,
// then uses Cartesian product search with scoring to select the best non-overlapping set.

const std = @import("std");
const Box = @import("../box.zig").Box;
const figure = @import("../figure.zig");
const Figure = figure.Figure;
const Caption = figure.Caption;
const CaptionParagraph = figure.CaptionParagraph;
const FigureType = figure.FigureType;
const paragraph = @import("../paragraph.zig");
const Paragraph = paragraph.Paragraph;
const page = @import("../page.zig");
const PageWithBodyText = page.PageWithBodyText;
const PageWithFigures = page.PageWithFigures;
const ClassifiedText = page.ClassifiedText;
const layout = @import("../layout.zig");
const DocumentLayout = layout.DocumentLayout;

// ---- Constants ----

const MinProposalHeight: f64 = 15;
const MinProposalWidth: f64 = 20;

const ClipRegionMinGraphicSize: f64 = 5000;
const ClipRegionLargeTextSize: f64 = 3000;
const ClipRegionMaxTextDistance: f64 = 4;
const ClipRegionMaxLargeTextDistance: f64 = 10;
const ClipRegionMaxGraphicDistance: f64 = 20;

const LeftRightFigurePenalty: f64 = 0.75;
const SplitDifferentTypesPenalty: f64 = 0.75;
const SplitSameTypesPenalty: f64 = 0.5;
const SplitWhitespaceBonus: f64 = 2;
const LargeGraphicThreshold: f64 = 2000;
const ContainsGraphicBonus: f64 = 0.1;
const ContainsLargeGraphicBonus: f64 = 0.15;

const SplitVerticalRegionMinHeightFraction: f64 = 4;

const cutFilterIntervalMin: f64 = 0.1;
const cutFilterIntervalMax: f64 = 0.9;
const boundaryFilterMinDistance: f64 = 30;

// ---- Types ----

const ProposalDirection = enum { up, left, down, right };

const Proposal = struct {
    region: Box,
    caption: CaptionParagraph,
    dir: ProposalDirection,
    split_with: ?struct { caption: CaptionParagraph, white_space: Box } = null,
};

// ---- Helpers ----

fn boxAlignment(box1: Box, box2: Box) struct { h: i32, v: i32 } {
    const h: i32 = if (box1.x2 < box2.x1) @as(i32, -1)
        else if (box1.x1 > box2.x2) @as(i32, 1)
        else 0;
    const v: i32 = if (box1.y2 < box2.y1) @as(i32, -1)
        else if (box1.y1 > box2.y2) @as(i32, 1)
        else 0;
    return .{ .h = h, .v = v };
}

fn boxExpandLR(box: Box, boxes: []const Box, bounds: Box) Box {
    var x1 = bounds.x1;
    var x2 = bounds.x2;
    for (boxes) |box2| {
        const alignment = boxAlignment(box, box2);
        if (alignment.v == 0) {
            // box and box2 horizontally aligned
            if (alignment.h == 1) {
                // box2 is to the right of box
                x1 = @max(x1, box2.x2);
            } else if (alignment.h == -1) {
                // box2 is to the left of box
                x2 = @min(x2, box2.x1);
            }
        }
    }
    return Box.init(x1, box.y1, x2, box.y2);
}

fn boxExpandUD(box: Box, boxes: []const Box, bounds: Box) Box {
    var y1 = bounds.y1;
    var y2 = bounds.y2;
    for (boxes) |box2| {
        const alignment = boxAlignment(box, box2);
        if (alignment.h == 0) {
            // box and box2 vertically aligned
            if (alignment.v == 1) {
                // box2 is below box
                y1 = @max(y1, box2.y2);
            } else if (alignment.v == -1) {
                // box2 is above box
                y2 = @min(y2, box2.y1);
            }
        }
    }
    return Box.init(box.x1, y1, box.x2, y2);
}

fn inCutInterval(d: f64) bool {
    return d >= cutFilterIntervalMin and d <= cutFilterIntervalMax;
}

fn boxOnBoundary(box: Box) bool {
    return box.x1 <= boundaryFilterMinDistance or box.y1 <= boundaryFilterMinDistance;
}

fn boxCutsFigure(box: Box, possible_figure_content: []const Box, page_center: ?f64, caption_box: Box) bool {
    for (possible_figure_content) |fig| {
        // Skip tiny items (individual axis labels, legend markers) that MuPDF
        // extracts as separate text boxes. These shouldn't gate figure proposals.
        if (fig.area() < 200) continue;
        // On two-column pages, skip items that span both columns when the proposal
        // is confined to one column. Without this, header decorations and full-width
        // content that MuPDF captures as graphics/other_text cause false rejections.
        if (page_center) |pc| {
            const box_spans_center = box.x1 < pc and box.x2 > pc;
            const fig_spans_center = fig.x1 < pc and fig.x2 > pc;
            if (fig_spans_center and !box_spans_center) continue;
        }
        // Skip items that intersect the caption boundary — these are decorative
        // elements (lines, borders) adjacent to the caption text, not content
        // cutting through the figure region.
        if (fig.intersects(caption_box, 0)) continue;
        const ratio = fig.intersectArea(box) / fig.area();
        if (inCutInterval(ratio)) {
            return true;
        }
    }
    return false;
}

/// Find the center column boundary for two-column pages.
fn findCenterColumn(allocator: std.mem.Allocator, page_body: *const PageWithBodyText) !struct { x1: f64, x2: f64 } {
    const all_text_boxes = try page_body.allTextBoxes(allocator);
    defer allocator.free(all_text_boxes);
    const text_center = Box.container(all_text_boxes).xCenter();

    var left_x2: f64 = text_center;
    for (page_body.body_text) |p| {
        if (p.boundary.x2 < text_center and p.boundary.x2 > left_x2) {
            left_x2 = p.boundary.x2;
        }
    }

    var right_x1: f64 = text_center;
    for (page_body.body_text) |p| {
        if (p.boundary.x1 > text_center and p.boundary.x1 < right_x1) {
            right_x1 = p.boundary.x1;
        }
    }

    const cx1 = if (@abs(left_x2 - text_center) < 10) left_x2 else text_center;
    const cx2 = if (@abs(right_x1 - text_center) < 10) right_x1 else text_center;
    return .{ .x1 = cx1, .x2 = cx2 };
}

/// Try to split a region horizontally at whitespace gaps.
fn splitRegionHorizontally(
    proposal_region: Box,
    content: []const Box,
    allocator: std.mem.Allocator,
) !?struct { upper: Box, lower: Box, whitespace: Box } {
    // Find content that intersects the proposal
    var intersects = std.ArrayList(Box).empty;
    for (content) |c| {
        if (c.intersects(proposal_region, 1.0)) {
            intersects.append(allocator, c) catch continue;
        }
    }

    var empty_blocks = try Box.findEmptyHorizontalBlocks(allocator, proposal_region, intersects.items);
    defer empty_blocks.deinit(allocator);

    var largest: ?Box = null;
    var largest_area: f64 = 0;

    for (empty_blocks.items) |e| {
        if ((e.y1 - proposal_region.y1) > proposal_region.height() / SplitVerticalRegionMinHeightFraction and
            (proposal_region.y2 - e.y2) > proposal_region.height() / SplitVerticalRegionMinHeightFraction and
            e.height() > 2)
        {
            if (e.area() > largest_area) {
                largest = e;
                largest_area = e.area();
            }
        }
    }

    const gap = largest orelse return null;

    const upper = Box.crop(
        Box.init(proposal_region.x1, proposal_region.y1, proposal_region.x2, gap.y1),
        intersects.items,
        -1,
    ) orelse return null;
    const lower = Box.crop(
        Box.init(proposal_region.x1, gap.y2, proposal_region.x2, proposal_region.y2),
        intersects.items,
        -1,
    ) orelse return null;

    if (upper.height() > MinProposalHeight and lower.height() > MinProposalHeight) {
        return .{ .upper = upper, .lower = lower, .whitespace = gap };
    }
    return null;
}

/// Crop a proposal region so it doesn't cross a column center.
fn cropToCenter(caption: Box, proposal: Box, in_center: []const Box, center: f64) Box {
    const caption_crosses = caption.x2 > center and caption.x1 <= center;
    const proposal_crosses = proposal.x2 > center and proposal.x1 < center;
    if (proposal_crosses and !caption_crosses) {
        // Check nothing important crosses the center
        var has_center_content = false;
        for (in_center) |c| {
            if (proposal.contains(c, 0)) {
                has_center_content = true;
                break;
            }
        }
        if (!has_center_content) {
            return if (caption.x1 > center)
                Box.init(center, proposal.y1, proposal.x2, proposal.y2)
            else
                Box.init(proposal.x1, proposal.y1, center, proposal.y2);
        }
    }
    return proposal;
}

/// Clip upward region to cluster around significant graphics.
fn clipUpwardRegion(
    caption: Box,
    region: Box,
    graphics: []const Box,
    other_text: []const Paragraph,
) Box {
    _ = caption;
    const gpa = std.heap.page_allocator;

    var contained_graphics: std.ArrayList(Box) = .empty;
    defer contained_graphics.deinit(gpa);

    for (graphics) |g| {
        if (region.intersectArea(g) / g.area() > 0.95) {
            contained_graphics.append(gpa, g) catch continue;
        }
    }

    var significant: std.ArrayList(Box) = .empty;
    defer significant.deinit(gpa);
    var non_sig: std.ArrayList(Box) = .empty;
    defer non_sig.deinit(gpa);

    for (contained_graphics.items) |g| {
        if (g.area() > ClipRegionMinGraphicSize) {
            significant.append(gpa, g) catch continue;
        } else {
            non_sig.append(gpa, g) catch continue;
        }
    }

    if (significant.items.len == 0) return region;

    var cluster = Box.container(significant.items);
    var remaining_graphics: std.ArrayList(Box) = .empty;
    {
        for (non_sig.items) |g| {
            remaining_graphics.append(gpa, g) catch continue;
        }
    }
    var remaining_text: std.ArrayList(Paragraph) = .empty;
    defer remaining_text.deinit(gpa);
    for (other_text) |p| {
        if (region.intersects(p.boundary, 1.0)) {
            remaining_text.append(gpa, p) catch continue;
        }
    }

    var done = false;
    while (!done) {
        var in_cluster_boxes: std.ArrayList(Box) = .empty;
        defer in_cluster_boxes.deinit(gpa);

        var new_remaining_text: std.ArrayList(Paragraph) = .empty;
        for (remaining_text.items) |p| {
            const y_dist = cluster.y1 - p.boundary.y2;
            const inside = if (p.boundary.area() < ClipRegionLargeTextSize)
                y_dist < ClipRegionMaxLargeTextDistance
            else
                y_dist < ClipRegionMaxTextDistance;
            if (inside) {
                in_cluster_boxes.append(gpa, p.boundary) catch continue;
            } else {
                new_remaining_text.append(gpa, p) catch continue;
            }
        }
        remaining_text.deinit(gpa);
        remaining_text = new_remaining_text;

        var new_remaining_graphics: std.ArrayList(Box) = .empty;
        for (remaining_graphics.items) |g| {
            const y_dist = cluster.y1 - g.y2;
            if (y_dist < ClipRegionMaxGraphicDistance) {
                in_cluster_boxes.append(gpa, g) catch continue;
            } else {
                new_remaining_graphics.append(gpa, g) catch continue;
            }
        }
        remaining_graphics.deinit(gpa);
        remaining_graphics = new_remaining_graphics;

        if (in_cluster_boxes.items.len > 0) {
            var all: std.ArrayList(Box) = .empty;
            defer all.deinit(gpa);
            all.append(gpa, cluster) catch continue;
            all.appendSlice(gpa, in_cluster_boxes.items) catch continue;
            cluster = Box.container(all.items).intersectRegion(region) orelse region;
        } else {
            done = true;
        }
    }

    return cluster;
}

/// Score a proposal.
fn scoreProposal(
    proposal: Proposal,
    graphics: []const Box,
    other_text_boxes: []const Box,
    scored_proposals: []const Proposal,
    bounds: Box,
) ?f64 {
    const boundary = proposal.region;
    // Check overlap with already-scored proposals
    for (scored_proposals) |p| {
        if (p.region.intersects(boundary, -2)) return null;
    }

    var area_score = boundary.area() / bounds.area();

    for (graphics) |g| {
        if (boundary.contains(g, 0)) {
            area_score += ContainsGraphicBonus;
            if (g.area() > LargeGraphicThreshold) {
                area_score += ContainsLargeGraphicBonus;
            }
        }
    }

    if (proposal.split_with) |sw| {
        area_score += sw.white_space.area() * SplitWhitespaceBonus / bounds.area();
        if (sw.caption.fig_type != proposal.caption.fig_type) {
            area_score *= SplitDifferentTypesPenalty;
        } else {
            area_score *= SplitSameTypesPenalty;
        }
    } else if (proposal.dir == .left or proposal.dir == .right) {
        area_score *= LeftRightFigurePenalty;
    }

    _ = other_text_boxes;
    return area_score;
}

/// Build proposals for each caption on the page.
fn buildProposals(
    allocator: std.mem.Allocator,
    page_body: *const PageWithBodyText,
    doc_layout: *const DocumentLayout,
) ![][]const Proposal {
    const non_figure_content = try page_body.nonFigureContent(allocator);
    const possible_figure_content = try page_body.possibleFigureContent(allocator);

    var all_content = std.ArrayList(Box).empty;
    try all_content.appendSlice(allocator, non_figure_content);
    try all_content.appendSlice(allocator, possible_figure_content);

    const bounds = Box.container(all_content.items);

    const two_column = doc_layout.two_columns;
    const center_column = if (two_column) try findCenterColumn(allocator, page_body) else null;
    const page_center: ?f64 = if (center_column) |cc| (cc.x1 + cc.x2) / 2.0 else null;

    // Find content that crosses the center
    var crosses_center = std.ArrayList(Box).empty;
    if (center_column) |cc| {
        for (possible_figure_content) |box| {
            if (box.x1 < cc.x1 and box.x2 > cc.x2) {
                try crosses_center.append(allocator, box);
            }
        }
    }

    var all_proposals = std.ArrayList([]const Proposal).empty;

    for (page_body.captions) |caption| {
        const capt_box = caption.boundary();
        var x1 = bounds.x1;
        var y1 = bounds.y1;
        var x2 = bounds.x2;
        var y2 = bounds.y2;

        // Find max expansion without intersecting non-figure content.
        // On two-column pages, full-width boxes spanning both columns should not
        // block vertical expansion (up/down) for single-column captions, since those
        // boxes correspond to abstract/heading text that isn't column-specific.
        // This compensates for MuPDF grouping text across columns differently than PDFBox.
        for (non_figure_content) |box| {
            const alignment = boxAlignment(capt_box, box);
            const spans_center = two_column and center_column != null and
                box.x1 < center_column.?.x1 and box.x2 > center_column.?.x2;
            if (alignment.h == 0) {
                if (alignment.v == 1) {
                    if (!spans_center) y1 = @max(y1, box.y2);
                } else if (alignment.v == -1) {
                    if (!spans_center) y2 = @min(y2, box.y1);
                }
            } else if (alignment.v == 0) {
                if (alignment.h == 1) {
                    x1 = @max(x1, box.x2);
                } else if (alignment.h == -1) {
                    x2 = @min(x2, box.x1);
                }
            }
        }


        var proposals = std.ArrayList(Proposal).empty;

        // Left proposal
        if (x1 <= capt_box.x1 - MinProposalWidth) {
            const prop = boxExpandUD(
                Box.init(x1, capt_box.y1, capt_box.x1, capt_box.y2),
                non_figure_content,
                bounds,
            );
            if (two_column) {
                const has_center = for (crosses_center.items) |c| {
                    if (prop.contains(c, 2)) break true;
                } else false;
                if (has_center or !(prop.x1 < page_center.? and prop.x2 > page_center.?)) {
                    try proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .left });
                }
            } else {
                try proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .left });
            }
        }

        // Right proposal
        if (x2 >= capt_box.x2 + MinProposalWidth) {
            const prop = boxExpandUD(
                Box.init(capt_box.x2, capt_box.y1, x2, capt_box.y2),
                non_figure_content,
                bounds,
            );
            if (two_column) {
                const has_center = for (crosses_center.items) |c| {
                    if (prop.contains(c, 2)) break true;
                } else false;
                if (has_center or !(prop.x1 < page_center.? and prop.x2 > page_center.?)) {
                    try proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .right });
                }
            } else {
                try proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .right });
            }
        }

        // Up proposal
        if (y1 <= capt_box.y1 - MinProposalHeight) {
            const up_box = Box.init(capt_box.x1, y1, capt_box.x2, capt_box.y1);
            var prop = boxExpandLR(
                up_box,
                non_figure_content,
                bounds,
            );
            // On two-column pages, force proposals to stay in the caption's column.
            // MuPDF text grouping differs from PDFBox, so boxExpandLR may not find
            // column-specific blockers and produce full-page-width proposals.
            if (two_column and page_center != null) {
                if (capt_box.x1 > page_center.?) {
                    prop = Box.init(@max(prop.x1, page_center.?), prop.y1, prop.x2, prop.y2);
                } else if (capt_box.x2 < page_center.?) {
                    prop = Box.init(prop.x1, prop.y1, @min(prop.x2, page_center.?), prop.y2);
                }
            }
            if (two_column) {
                prop = cropToCenter(capt_box, prop, crosses_center.items, page_center.?);
            }
            const pruned = clipUpwardRegion(capt_box, prop, page_body.graphics, page_body.other_text);
            try proposals.append(allocator, .{ .region = pruned, .caption = caption, .dir = .up });
        }

        // Down proposal
        if (y2 >= capt_box.y2 + MinProposalHeight) {
            var prop = boxExpandLR(
                Box.init(capt_box.x1, capt_box.y2, capt_box.x2, y2),
                non_figure_content,
                bounds,
            );
            if (two_column and page_center != null) {
                if (capt_box.x1 > page_center.?) {
                    prop = Box.init(@max(prop.x1, page_center.?), prop.y1, prop.x2, prop.y2);
                } else if (capt_box.x2 < page_center.?) {
                    prop = Box.init(prop.x1, prop.y1, @min(prop.x2, page_center.?), prop.y2);
                }
            }
            if (two_column) {
                prop = cropToCenter(capt_box, prop, crosses_center.items, page_center.?);
            }
            try proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .down });
        }

        var valid_proposals = std.ArrayList(Proposal).empty;
        for (proposals.items) |prop| {
            const cropped = Box.crop(prop.region, all_content.items, -1);
            if (cropped == null) {
                continue;
            }
            const cr = cropped.?;
            if (cr.width() < MinProposalWidth or cr.height() < MinProposalHeight) {
                continue;
            }
            if (boxCutsFigure(cr, possible_figure_content, page_center, capt_box)) {
                continue;
            }
            if (boxOnBoundary(cr)) {
                continue;
            }
            try valid_proposals.append(allocator, .{ .region = cr, .caption = prop.caption, .dir = prop.dir, .split_with = prop.split_with });
        }

        // Fallback: if no valid proposals, retry with 2px tolerance on expansion bounds
        // to compensate for MuPDF/PDFBox coordinate differences
        if (valid_proposals.items.len == 0) {
            const Tol: f64 = 2;
            var fx1 = bounds.x1;
            var fy1 = bounds.y1;
            var fx2 = bounds.x2;
            var fy2 = bounds.y2;
            for (non_figure_content) |box| {
                const alignment = boxAlignment(capt_box, box);
                if (alignment.h == 0) {
                    if (alignment.v == 1) {
                        fy1 = @max(fy1, box.y2 - Tol);
                    } else if (alignment.v == -1) {
                        fy2 = @min(fy2, box.y1 + Tol);
                    }
                } else if (alignment.v == 0) {
                    if (alignment.h == 1) {
                        fx1 = @max(fx1, box.x2 - Tol);
                    } else if (alignment.h == -1) {
                        fx2 = @min(fx2, box.x1 + Tol);
                    }
                }
            }

            var fallback_proposals = std.ArrayList(Proposal).empty;
            if (fx1 <= capt_box.x1 - MinProposalWidth) {
                const prop = boxExpandUD(Box.init(fx1, capt_box.y1, capt_box.x1, capt_box.y2), non_figure_content, bounds);
                if (!two_column or blk: {
                    const has_center = for (crosses_center.items) |c| {
                        if (prop.contains(c, 2)) break true;
                    } else false;
                    break :blk has_center or !(prop.x1 < page_center.? and prop.x2 > page_center.?);
                }) {
                    try fallback_proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .left });
                }
            }
            if (fx2 >= capt_box.x2 + MinProposalWidth) {
                const prop = boxExpandUD(Box.init(capt_box.x2, capt_box.y1, fx2, capt_box.y2), non_figure_content, bounds);
                if (!two_column or blk: {
                    const has_center = for (crosses_center.items) |c| {
                        if (prop.contains(c, 2)) break true;
                    } else false;
                    break :blk has_center or !(prop.x1 < page_center.? and prop.x2 > page_center.?);
                }) {
                    try fallback_proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .right });
                }
            }
            if (fy1 <= capt_box.y1 - MinProposalHeight) {
                var prop = boxExpandLR(Box.init(capt_box.x1, fy1, capt_box.x2, capt_box.y1), non_figure_content, bounds);
                if (two_column and page_center != null) {
                    if (capt_box.x1 > page_center.?) {
                        prop = Box.init(@max(prop.x1, page_center.?), prop.y1, prop.x2, prop.y2);
                    } else if (capt_box.x2 < page_center.?) {
                        prop = Box.init(prop.x1, prop.y1, @min(prop.x2, page_center.?), prop.y2);
                    }
                }
                if (two_column) prop = cropToCenter(capt_box, prop, crosses_center.items, page_center.?);
                const pruned = clipUpwardRegion(capt_box, prop, page_body.graphics, page_body.other_text);
                try fallback_proposals.append(allocator, .{ .region = pruned, .caption = caption, .dir = .up });
            }
            if (fy2 >= capt_box.y2 + MinProposalHeight) {
                var prop = boxExpandLR(Box.init(capt_box.x1, capt_box.y2, capt_box.x2, fy2), non_figure_content, bounds);
                if (two_column and page_center != null) {
                    if (capt_box.x1 > page_center.?) {
                        prop = Box.init(@max(prop.x1, page_center.?), prop.y1, prop.x2, prop.y2);
                    } else if (capt_box.x2 < page_center.?) {
                        prop = Box.init(prop.x1, prop.y1, @min(prop.x2, page_center.?), prop.y2);
                    }
                }
                if (two_column) prop = cropToCenter(capt_box, prop, crosses_center.items, page_center.?);
                try fallback_proposals.append(allocator, .{ .region = prop, .caption = caption, .dir = .down });
            }

            for (fallback_proposals.items) |prop| {
                const cropped = Box.crop(prop.region, all_content.items, -1) orelse {
                    continue;
                };
                if (cropped.width() < MinProposalWidth or cropped.height() < MinProposalHeight) {
                    continue;
                }
                if (boxCutsFigure(cropped, possible_figure_content, page_center, capt_box)) {
                    continue;
                }
                if (boxOnBoundary(cropped)) {
                    continue;
                }
                try valid_proposals.append(allocator, .{ .region = cropped, .caption = prop.caption, .dir = prop.dir });
            }
        }

        try all_proposals.append(allocator, try valid_proposals.toOwnedSlice(allocator));
    }

    return all_proposals.items;
}

/// Generate Cartesian product of lists.
fn cartesianProduct(allocator: std.mem.Allocator, lists: []const []const Proposal) ![][]const Proposal {
    if (lists.len == 0) {
        var result = try allocator.alloc([]const Proposal, 1);
        result[0] = &.{};
        return result;
    }

    const head = lists[0];
    const tail_product = try cartesianProduct(allocator, lists[1..]);
    defer allocator.free(tail_product);

    var result = std.ArrayList([]const Proposal).empty;
    for (head) |h_item| {
        for (tail_product) |t_combo| {
            var combo = try allocator.alloc(Proposal, t_combo.len + 1);
            combo[0] = h_item;
            @memcpy(combo[1..], t_combo);
            try result.append(allocator, combo);
        }
    }
    return try result.toOwnedSlice(allocator);
}

/// Split overlapping proposals.
/// Groups proposals by collision, then attempts to split each group of 2
/// with one up and one down where one region contains the other.
fn splitProposals(proposals: []const Proposal, content: []const Box, allocator: std.mem.Allocator) ![]const Proposal {
    if (proposals.len <= 1) return proposals;

    // Group proposals that overlap into collision groups (matches Scala grouping)
    var groups = std.ArrayList(std.ArrayList(Proposal)).empty;
    defer {
        for (groups.items) |*g| g.deinit(allocator);
        groups.deinit(allocator);
    }

    // Track which proposals have been grouped
    var grouped = try allocator.alloc(bool, proposals.len);
    defer allocator.free(grouped);
    @memset(grouped, false);

    for (proposals, 0..) |prop, pi| {
        if (grouped[pi]) continue;
        var group = std.ArrayList(Proposal).empty;
        try group.append(allocator, prop);
        grouped[pi] = true;

        for (proposals[pi + 1 ..], pi + 1..) |other, oi| {
            if (grouped[oi]) continue;
            if (prop.region.intersects(other.region, -2)) {
                try group.append(allocator, other);
                grouped[oi] = true;
            }
        }
        try groups.append(allocator, group);
    }

    // Process each group: try to split groups of 2 with up+down where one contains the other
    var result = std.ArrayList(Proposal).empty;
    for (groups.items) |*group| {
        if (group.items.len == 1) {
            try result.append(allocator, group.items[0]);
        } else if (group.items.len == 2 and
            ((group.items[0].dir == .up and group.items[1].dir == .down) or
            (group.items[0].dir == .down and group.items[1].dir == .up)) and
            (group.items[1].region.contains(group.items[0].region, 0) or
            group.items[0].region.contains(group.items[1].region, 0)))
        {
            const container_box = Box.container(&.{ group.items[0].region, group.items[1].region });
            if (try splitRegionHorizontally(container_box, content, allocator)) |split| {
                // In Scala: upperProp is the Down proposal (above caption), lowerProp is Up (below caption)
                // In Zig (MuPDF y↓): .up = above caption, .down = below caption
                // split.upper = above gap (smaller y), split.lower = below gap (larger y)
                // Map: upper region → above-caption proposal (.up), lower region → below-caption proposal (.down)
                const above_prop = if (group.items[0].dir == .up) group.items[0] else group.items[1];
                const below_prop = if (group.items[0].dir == .down) group.items[0] else group.items[1];
                try result.append(allocator, .{
                    .region = split.upper,
                    .caption = above_prop.caption,
                    .dir = above_prop.dir,
                    .split_with = .{ .caption = below_prop.caption, .white_space = split.whitespace },
                });
                try result.append(allocator, .{
                    .region = split.lower,
                    .caption = below_prop.caption,
                    .dir = below_prop.dir,
                    .split_with = .{ .caption = above_prop.caption, .white_space = split.whitespace },
                });
            } else {
                try result.appendSlice(allocator, group.items);
            }
        } else {
            try result.appendSlice(allocator, group.items);
        }
    }

    return result.items;
}

/// Remove text contained within figure regions.
fn removeTextInRegions(allocator: std.mem.Allocator, paragraphs_list: []const Paragraph, regions: []const Box) ![]const Paragraph {
    if (regions.len == 0) return paragraphs_list;

    var cleaned = std.ArrayList(Paragraph).empty;
    for (paragraphs_list) |p| {
        var filtered_lines = std.ArrayList(paragraph.Line).empty;
        for (p.lines) |l| {
            var contained = false;
            for (regions) |r| {
                if (r.contains(l.boundary, 1.0)) {
                    contained = true;
                    break;
                }
            }
            if (!contained) {
                try filtered_lines.append(allocator, l);
            }
        }
        if (filtered_lines.items.len > 0) {
            try cleaned.append(allocator, Paragraph.init(try filtered_lines.toOwnedSlice(allocator)));
        }
    }
    return cleaned.items;
}

/// Detect figures on a page by proposing regions around captions.
pub fn detectFigures(
    allocator: std.mem.Allocator,
    page_body: PageWithBodyText,
    doc_layout: DocumentLayout,
) !PageWithFigures {
    const proposals = try buildProposals(allocator, &page_body, &doc_layout);

    const captions_with_no_proposals = blk: {
        var list = std.ArrayList(CaptionParagraph).empty;
        for (page_body.captions, proposals) |caption, props| {
            if (props.len == 0) {
                try list.append(allocator, caption);
            }
        }
        break :blk list.items;
    };

    // Filter to captions that have proposals
    var valid_proposals_list = std.ArrayList([]const Proposal).empty;
    for (proposals) |props| {
        if (props.len > 0) {
            try valid_proposals_list.append(allocator, props);
        }
    }

    const valid_proposals = valid_proposals_list.items;

    // Calculate total configurations
    var config_count: u64 = 1;
    for (valid_proposals) |vp| {
        config_count *%= vp.len;
        if (config_count > 500000) break;
    }

    if (valid_proposals.len == 0 or config_count > 500000) {
        var all_paras = std.ArrayList(Paragraph).empty;
        try all_paras.appendSlice(allocator, page_body.other_text);
        try all_paras.appendSlice(allocator, page_body.body_text);
        for (captions_with_no_proposals) |cnp| {
            try all_paras.append(allocator, cnp.paragraph);
        }
        std.mem.sort(Paragraph, all_paras.items, {}, struct {
            fn lt(_: void, a: Paragraph, b: Paragraph) bool {
                return a.startLineNumber() < b.startLineNumber();
            }
        }.lt);

        var failed = std.ArrayList(Caption).empty;
        for (captions_with_no_proposals) |cnp| {
            try failed.append(allocator, try Caption.fromCaptionParagraph(cnp, allocator));
        }

        return PageWithFigures.init(
            page_body.page_number,
            all_paras.items,
            page_body.classified_text,
            &.{},
            failed.items,
        );
    }

    const all_content = try page_body.allContent(allocator);
    const bounds = Box.container(all_content);

    const cart_product = try cartesianProduct(allocator, valid_proposals);
    defer {
        for (cart_product) |combo| allocator.free(combo);
        allocator.free(cart_product);
    }

    var best_score: f64 = -std.math.floatMax(f64);
    var best_config: ?struct { score: f64, config: []const Proposal, scores: []const ?f64 } = null;

    for (cart_product) |combo| {
        const split = try splitProposals(combo, all_content, allocator);
        defer if (split.ptr != combo.ptr) allocator.free(split);

        var scored = std.ArrayList(Proposal).empty;
        var scores = std.ArrayList(?f64).empty;
        var remaining = std.ArrayList(Proposal).empty;
        try remaining.appendSlice(allocator, split);

        while (remaining.items.len > 0) {
            const prop = remaining.orderedRemove(0);
            const other_boxes = try page_body.otherTextBoxes(allocator);
            defer allocator.free(other_boxes);
            const score = scoreProposal(
                prop,
                page_body.graphics,
                other_boxes,
                scored.items,
                bounds,
            );
            try scored.append(allocator, prop);
            try scores.append(allocator, score);
        }

        var overall: f64 = 0;
        var empty_count: u32 = 0;
        for (scores.items) |s| {
            if (s) |val| {
                overall += val;
            } else {
                empty_count += 1;
            }
        }
        overall -= @floatFromInt(empty_count);

        if (overall > best_score) {
            best_score = overall;
            if (best_config) |*bc| {
                bc.score = overall;
                bc.config = scored.items;
                bc.scores = scores.items;
            } else {
                best_config = .{ .score = overall, .config = scored.items, .scores = scores.items };
            }
        }
    }

    if (best_config) |bc| {
        var figures_list = std.ArrayList(Figure).empty;
        var failed_props = std.ArrayList(CaptionParagraph).empty;

        for (bc.config, bc.scores) |prop, s| {
            if (s != null) {
                var image_text = std.ArrayList([]const u8).empty;
                for (page_body.other_text) |p| {
                    for (p.lines) |l| {
                        for (l.words) |word| {
                            if (prop.region.contains(word.boundary, 1)) {
                                image_text.append(allocator, word.text) catch continue;
                            }
                        }
                    }
                }

                try figures_list.append(allocator, Figure{
                    .name = prop.caption.name,
                    .fig_type = prop.caption.fig_type,
                    .page = prop.caption.page,
                    .caption = try prop.caption.text(allocator),
                    .image_text = try image_text.toOwnedSlice(allocator),
                    .caption_boundary = prop.caption.boundary(),
                    .region_boundary = prop.region,
                });
            } else {
                try failed_props.append(allocator, prop.caption);
            }
        }

        for (captions_with_no_proposals) |cnp| {
            try failed_props.append(allocator, cnp);
        }

        var failed_captions = std.ArrayList(Caption).empty;
        for (failed_props.items) |fc| {
            try failed_captions.append(allocator, try Caption.fromCaptionParagraph(fc, allocator));
        }

        var figure_regions = std.ArrayList(Box).empty;
        for (figures_list.items) |f| {
            try figure_regions.append(allocator, f.region_boundary);
        }

        const non_figure_text = try removeTextInRegions(
            allocator,
            try page_body.nonFigureText(allocator),
            figure_regions.items,
        );
        // Actually use the combined paragraphs approach
        var all_paras = std.ArrayList(Paragraph).empty;
        try all_paras.appendSlice(allocator, non_figure_text);
        for (failed_props.items) |fc| {
            try all_paras.append(allocator, fc.paragraph);
        }
        std.mem.sort(Paragraph, all_paras.items, {}, struct {
            fn lt(_: void, a: Paragraph, b: Paragraph) bool {
                return a.startLineNumber() < b.startLineNumber();
            }
        }.lt);

        return PageWithFigures.init(
            page_body.page_number,
            all_paras.items,
            page_body.classified_text,
            figures_list.items,
            failed_captions.items,
        );
    }

    // Fallback: no figures found
    var all_paras = std.ArrayList(Paragraph).empty;
    try all_paras.appendSlice(allocator, page_body.other_text);
    try all_paras.appendSlice(allocator, page_body.body_text);
    for (captions_with_no_proposals) |cnp| {
        try all_paras.append(allocator, cnp.paragraph);
    }
    std.mem.sort(Paragraph, all_paras.items, {}, struct {
        fn lt(_: void, a: Paragraph, b: Paragraph) bool {
            return a.startLineNumber() < b.startLineNumber();
        }
    }.lt);

    var failed = std.ArrayList(Caption).empty;
    for (captions_with_no_proposals) |cnp| {
        try failed.append(allocator, try Caption.fromCaptionParagraph(cnp, allocator));
    }

    return PageWithFigures.init(
        page_body.page_number,
        all_paras.items,
        page_body.classified_text,
        &.{},
        failed.items,
    );
}

test "boxAlignment left" {
    const a = Box.init(0, 0, 10, 10);
    const b = Box.init(20, 0, 30, 10);
    const alignment = boxAlignment(a, b);
    try std.testing.expectEqual(@as(i32, -1), alignment.h);
    try std.testing.expectEqual(@as(i32, 0), alignment.v);
}

test "boxOnBoundary true" {
    const b = Box.init(5, 0, 100, 100);
    try std.testing.expect(boxOnBoundary(b));
}

test "boxOnBoundary false" {
    const b = Box.init(50, 50, 100, 100);
    try std.testing.expect(!boxOnBoundary(b));
}
