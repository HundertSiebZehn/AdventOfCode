const std = @import("std");
const testing = std.testing;
const shared = @import("shared.zig");
const PuzzleResult = shared.PuzzleResult;
const readFile = shared.readFile;
const pickInputFile = shared.pickInputFile;
const Allocator = std.mem.Allocator;

pub fn runPart1(allocator: Allocator, comptime isExample: bool) !PuzzleResult {
    const fileName = pickInputFile(1, null, isExample);
    const tuple = try parseDoubleColumnInputList(allocator, fileName);
    defer allocator.free(tuple.left);
    defer allocator.free(tuple.right);
    const result = solvePart1(tuple.left, tuple.right);

    return PuzzleResult{ .int = result };
}

pub fn runPart2(allocator: Allocator, comptime isExample: bool) !PuzzleResult {
    const fileName = pickInputFile(1, null, isExample);
    const tuple = try parseDoubleColumnInputList(allocator, fileName);
    defer allocator.free(tuple.left);
    defer allocator.free(tuple.right);
    const result = solvePart2(tuple.left, tuple.right);

    return PuzzleResult{ .int = result };
}

fn solvePart1(left: []i32, right: []i32) i32 {
    std.mem.sort(i32, left, {}, std.sort.asc(i32));
    std.mem.sort(i32, right, {}, std.sort.asc(i32));

    var dist: u32 = 0;
    for (left, right) |l, r| {
        dist += @abs(l - r);
    }

    return @intCast(dist);
}

fn solvePart2(left: []i32, right: []i32) i32 {
    var result: i32 = 0;
    for (left) |l| {
        var count: i32 = 0;
        for (right) |r| {
            if (l == r) {
                count += 1;
            }
        }
        result += l * count;
    }
    return result;
}

fn parseDoubleColumnInputList(allocator: Allocator, path: []const u8) !Tuple([]i32) {
    const content = try readFile(allocator, path);
    defer allocator.free(content);
    var left = std.ArrayList(i32).init(allocator);
    defer left.deinit();
    var right = std.ArrayList(i32).init(allocator);
    defer right.deinit();

    var lines = std.mem.splitSequence(u8, content, "\n");
    while (lines.next()) |line| {
        const numbers = std.mem.splitSequence(u8, line, " ");
        const tuple = try parseDoubleColumnInputLine(numbers);
        try left.append(tuple.left);
        try right.append(tuple.right);
    }
    return Tuple([]i32){
        .left = try left.toOwnedSlice(),
        .right = try right.toOwnedSlice(),
    };
}

fn parseDoubleColumnInputLine(_numbers: std.mem.SplitIterator(u8, .sequence)) !Tuple(i32) {
    var numbers = @constCast(&_numbers);
    var number = numbers.next().?;
    const left = try std.fmt.parseInt(i32, number, 10);

    while (true) {
        number = numbers.next().?;
        if (number.len <= 0) continue;
        const right = try std.fmt.parseInt(i32, number, 10);
        return Tuple(i32){
            .left = left,
            .right = right,
        };
    } else {
        @panic("No right value to parse");
    }
}

fn Tuple(comptime T: type) type {
    return struct {
        left: T,
        right: T,
    };
}
