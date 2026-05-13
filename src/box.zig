// Axis-aligned bounding box. Coordinates in PDF space (72 DPI, origin top-left).
// Direct translation of Box.scala.

const std = @import("std");

pub const Box = struct {
    x1: f64,
    y1: f64,
    x2: f64,
    y2: f64,

    pub fn init(x1: f64, y1: f64, x2: f64, y2: f64) Box {
        std.debug.assert(x1 <= x2); // boxes must have width >= 0
        std.debug.assert(y1 <= y2); // boxes must have height >= 0
        return .{ .x1 = x1, .y1 = y1, .x2 = x2, .y2 = y2 };
    }

    pub fn width(self: Box) f64 {
        return self.x2 - self.x1;
    }

    pub fn height(self: Box) f64 {
        return self.y2 - self.y1;
    }

    pub fn xCenter(self: Box) f64 {
        return (self.x2 + self.x1) / 2.0;
    }

    pub fn yCenter(self: Box) f64 {
        return (self.y2 + self.y1) / 2.0;
    }

    pub fn area(self: Box) f64 {
        return self.width() * self.height();
    }

    pub fn scale(self: Box, s: f64) Box {
        return Box.init(self.x1 * s, self.y1 * s, self.x2 * s, self.y2 * s);
    }

    pub fn horizontallyAligned(self: Box, other: Box, tol: f64) bool {
        return !(other.x1 - tol > self.x2 or other.x2 + tol < self.x1);
    }

    pub fn yDistanceTo(self: Box, other: Box) f64 {
        return @min(@abs(other.y1 - self.y2), @abs(self.y2 - other.y1));
    }

    pub fn intersects(self: Box, other: Box, tol: f64) bool {
        if (tol == 0) {
            return !(self.x2 < other.x1 or self.x1 > other.x2 or
                self.y2 < other.y1 or self.y1 > other.y2);
        }
        return !((self.x2 < other.x1 - tol) or (self.x1 > other.x2 + tol) or
            (self.y2 < other.y1 - tol) or (self.y1 > other.y2 + tol));
    }

    pub fn intersectRegion(self: Box, other: Box) ?Box {
        if (!self.intersects(other, 0)) {
            return null;
        }
        const overlap_x1 = @max(self.x1, other.x1);
        const overlap_y1 = @max(self.y1, other.y1);
        const overlap_x2 = @min(self.x2, other.x2);
        const overlap_y2 = @min(self.y2, other.y2);
        if (overlap_x1 > overlap_x2 or overlap_y1 > overlap_y2) return null;
        return Box.init(overlap_x1, overlap_y1, overlap_x2, overlap_y2);
    }

    pub fn intersectArea(self: Box, other: Box) f64 {
        return if (self.intersectRegion(other)) |overlap| overlap.area() else 0.0;
    }

    pub fn intersectsAny(self: Box, others: []const Box, tol: f64) bool {
        for (others) |other| {
            if (self.intersects(other, tol)) return true;
        }
        return false;
    }

    pub fn contains(self: Box, other: Box, tol: f64) bool {
        if (tol == 0) {
            return self.x1 <= other.x1 and self.y1 <= other.y1 and
                self.x2 >= other.x2 and self.y2 >= other.y2;
        }
        return (self.x1 <= other.x1 + tol) and (self.y1 <= other.y1 + tol) and
            (self.x2 >= other.x2 - tol) and (self.y2 >= other.y2 - tol);
    }

    pub fn containerBox(self: Box, other: Box) Box {
        return Box.init(
            @min(self.x1, other.x1),
            @min(self.y1, other.y1),
            @max(self.x2, other.x2),
            @max(self.y2, other.y2),
        );
    }

    // ---- Companion object functions ----

    /// Returns a Box that contains all the given boxes. Panics if boxes is empty.
    pub fn container(boxes: []const Box) Box {
        std.debug.assert(boxes.len > 0);
        var min_x = boxes[0].x1;
        var min_y = boxes[0].y1;
        var max_x = boxes[0].x2;
        var max_y = boxes[0].y2;
        for (boxes[1..]) |b| {
            min_x = @min(min_x, b.x1);
            min_y = @min(min_y, b.y1);
            max_x = @max(max_x, b.x2);
            max_y = @max(max_y, b.y2);
        }
        return Box.init(min_x, min_y, max_x, max_y);
    }

    /// Crops `box` to just contain the boxes in `boxes`. Returns null if `box` does not
    /// contain any box in `boxes`.
    pub fn crop(box: Box, boxes: []const Box, tol: f64) ?Box {
        var shrink_left: f64 = box.width();
        var shrink_right: f64 = box.width();
        var shrink_up: f64 = box.height();
        var shrink_down: f64 = box.height();
        var found_any = false;

        for (boxes) |other| {
            if (other.intersects(box, tol)) {
                shrink_left = @min(shrink_left, other.x1 - box.x1);
                shrink_right = @min(shrink_right, box.x2 - other.x2);
                shrink_up = @min(shrink_up, box.y2 - other.y2);
                shrink_down = @min(shrink_down, other.y1 - box.y1);
                found_any = true;
            }
        }

        if (!found_any) return null;

        return Box.init(
            box.x1 + @max(shrink_left, 0),
            box.y1 + @max(shrink_down, 0),
            box.x2 - @max(shrink_right, 0),
            box.y2 - @max(shrink_up, 0),
        );
    }

    /// Clusters intersecting boxes by merging them. Returns a list of non-overlapping boxes.
    /// Uses Box.container() to merge clusters.
    pub fn mergeBoxes(allocator: std.mem.Allocator, boxes: []const Box, tol: f64) !std.ArrayList(Box) {
        var current = std.ArrayList(Box).empty;
        try current.appendSlice(allocator, boxes);

        if (current.items.len == 0) {
            return std.ArrayList(Box).empty;
        }

        var found_intersecting = true;
        while (found_intersecting) {
            found_intersecting = false;

            var checked = std.ArrayList(Box).empty;
            defer checked.deinit(allocator);
            try checked.append(allocator, current.items[0]);

            var unchecked = std.ArrayList(Box).empty;
            defer unchecked.deinit(allocator);
            // Start from index 1
            if (current.items.len > 1) {
                try unchecked.appendSlice(allocator, current.items[1..]);
            }

            while (!found_intersecting and unchecked.items.len > 0) {
                const head = checked.items[checked.items.len - 1];

                // Partition unchecked into intersecting / non-intersecting
                var intersects_list = std.ArrayList(Box).empty;
                defer intersects_list.deinit(allocator);
                var non_intersects = std.ArrayList(Box).empty;
                defer non_intersects.deinit(allocator);

                for (unchecked.items) |b| {
                    if (b.intersects(head, tol)) {
                        try intersects_list.append(allocator, b);
                    } else {
                        try non_intersects.append(allocator, b);
                    }
                }

                if (intersects_list.items.len > 0) {
                    // Merge head with all intersecting boxes
                    var all = std.ArrayList(Box).empty;
                    defer all.deinit(allocator);
                    try all.append(allocator, head);
                    try all.appendSlice(allocator, intersects_list.items);
                    const new_box = Box.container(all.items);

                    // Replace: checked.tail (everything before head) + new_box
                    var new_checked = std.ArrayList(Box).empty;
                    defer new_checked.deinit(allocator);
                    if (checked.items.len > 1) {
                        try new_checked.appendSlice(allocator, checked.items[0 .. checked.items.len - 1]);
                    }
                    try new_checked.append(allocator, new_box);

                    // current = new_checked + non_intersects
                    current.clearAndFree(allocator);
                    try current.appendSlice(allocator, new_checked.items);
                    try current.appendSlice(allocator, non_intersects.items);

                    found_intersecting = true;
                } else {
                    // Move head to front of checked (no-op here since it's already last)
                    // Pop from unchecked
                    _ = unchecked.swapRemove(0);
                }
            }
        }

        return current;
    }

    /// Find all maximally-expanded empty horizontal blocks within `box` that do not
    /// intersect any box in `contents`. Returns blocks with same x1/x2 as `box`.
    pub fn findEmptyHorizontalBlocks(
        allocator: std.mem.Allocator,
        box: Box,
        contents: []const Box,
    ) !std.ArrayList(Box) {
        var empty_blocks = std.ArrayList(Box).empty;
        try empty_blocks.append(allocator, box);

        for (contents) |content_box| {
            var new_blocks = std.ArrayList(Box).empty;
            for (empty_blocks.items) |empty_region| {
                if (content_box.intersects(empty_region, 0)) {
                    if (content_box.y1 <= empty_region.y1) {
                        if (content_box.y2 < empty_region.y2) {
                            try new_blocks.append(allocator, Box.init(
                                empty_region.x1,
                                content_box.y2,
                                empty_region.x2,
                                empty_region.y2,
                            ));
                        }
                        // else: fully covered, add nothing
                    } else if (content_box.y2 >= empty_region.y2) {
                        if (content_box.y1 > empty_region.y1) {
                            try new_blocks.append(allocator, Box.init(
                                empty_region.x1, empty_region.y1,
                                empty_region.x2, content_box.y1,
                            ));
                        }
                        // else: fully covered, add nothing
                    } else {
                        // content_box is in the middle, split into two
                        try new_blocks.append(allocator, Box.init(
                            empty_region.x1, empty_region.y1,
                            empty_region.x2, content_box.y1,
                        ));
                        try new_blocks.append(allocator, Box.init(
                            empty_region.x1, content_box.y2,
                            empty_region.x2, empty_region.y2,
                        ));
                    }
                } else {
                    try new_blocks.append(allocator, empty_region);
                }
            }
            empty_blocks.deinit(allocator);
            empty_blocks = new_blocks;
        }

        return empty_blocks;
    }
};

// ---- Tests ----

test "Box basics" {
    const b = Box.init(0, 0, 10, 20);
    try std.testing.expectEqual(@as(f64, 10), b.width());
    try std.testing.expectEqual(@as(f64, 20), b.height());
    try std.testing.expectEqual(@as(f64, 200), b.area());
    try std.testing.expectEqual(@as(f64, 5), b.xCenter());
    try std.testing.expectEqual(@as(f64, 10), b.yCenter());
}

test "Box scale" {
    const b = Box.init(0, 0, 10, 20).scale(2.0);
    try std.testing.expectEqual(@as(f64, 0), b.x1);
    try std.testing.expectEqual(@as(f64, 0), b.y1);
    try std.testing.expectEqual(@as(f64, 20), b.x2);
    try std.testing.expectEqual(@as(f64, 40), b.y2);
}

test "Box intersects" {
    const a = Box.init(0, 0, 10, 10);
    const b = Box.init(5, 5, 15, 15);
    const c = Box.init(20, 20, 30, 30);
    try std.testing.expect(a.intersects(b, 0));
    try std.testing.expect(!a.intersects(c, 0));
    // With tolerance
    const d = Box.init(11, 0, 15, 10);
    try std.testing.expect(a.intersects(d, 2));
    try std.testing.expect(!a.intersects(d, 0));
}

test "Box intersectRegion" {
    const a = Box.init(0, 0, 10, 10);
    const b = Box.init(5, 5, 15, 15);
    const overlap = a.intersectRegion(b).?;
    try std.testing.expectEqual(@as(f64, 5), overlap.x1);
    try std.testing.expectEqual(@as(f64, 5), overlap.y1);
    try std.testing.expectEqual(@as(f64, 10), overlap.x2);
    try std.testing.expectEqual(@as(f64, 10), overlap.y2);
}

test "Box contains" {
    const a = Box.init(0, 0, 10, 10);
    const b = Box.init(2, 2, 8, 8);
    const c = Box.init(5, 5, 15, 15);
    try std.testing.expect(a.contains(b, 0));
    try std.testing.expect(!a.contains(c, 0));
    try std.testing.expect(a.contains(c, 6)); // with tolerance
}

test "Box container function" {
    var boxes = [_]Box{ Box.init(0, 0, 10, 10), Box.init(5, 5, 15, 20) };
    const c = Box.container(&boxes);
    try std.testing.expectEqual(@as(f64, 0), c.x1);
    try std.testing.expectEqual(@as(f64, 0), c.y1);
    try std.testing.expectEqual(@as(f64, 15), c.x2);
    try std.testing.expectEqual(@as(f64, 20), c.y2);
}

test "Box crop" {
    const box = Box.init(0, 0, 20, 20);
    var contents = [_]Box{ Box.init(2, 3, 18, 17) };
    const cropped = Box.crop(box, &contents, 0).?;
    try std.testing.expectEqual(@as(f64, 2), cropped.x1);
    try std.testing.expectEqual(@as(f64, 3), cropped.y1);
    try std.testing.expectEqual(@as(f64, 18), cropped.x2);
    try std.testing.expectEqual(@as(f64, 17), cropped.y2);
}

test "Box crop empty" {
    const box = Box.init(0, 0, 20, 20);
    var contents = [_]Box{ Box.init(30, 30, 40, 40) };
    try std.testing.expect(Box.crop(box, &contents, 0) == null);
}

test "Box mergeBoxes" {
    const allocator = std.testing.allocator;
    var input = [_]Box{
        Box.init(0, 0, 10, 10),
        Box.init(5, 5, 15, 15),
        Box.init(30, 30, 40, 40),
    };
    var merged = try Box.mergeBoxes(allocator, &input, 0);
    defer merged.deinit(allocator);
    try std.testing.expectEqual(@as(usize, 2), merged.items.len);
}

test "Box findEmptyHorizontalBlocks" {
    const allocator = std.testing.allocator;
    const box = Box.init(0, 0, 10, 100);
    var contents = [_]Box{ Box.init(0, 40, 10, 60) };
    var blocks = try Box.findEmptyHorizontalBlocks(allocator, box, &contents);
    defer blocks.deinit(allocator);
    try std.testing.expectEqual(@as(usize, 2), blocks.items.len);
}