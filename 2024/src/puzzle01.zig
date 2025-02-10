const std = @import("std");
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;
const shared = @import("shared.zig");
const PuzzleResult = shared.PuzzleResult;
const readFile = shared.readFile;
const pickInputFile = shared.pickInputFile;

pub fn runPart1(comptime isExample: bool) !PuzzleResult {
    const fileName = pickInputFile(1, 1, isExample);
    const left, const right = try parseDoubleColumnInputList(fileName);
    const result = solvePart1(left, right);

    return PuzzleResult{.int =  result};
}

pub fn runPart2(comptime isExample: bool) !PuzzleResult {
    const fileName = pickInputFile(1, 1, isExample);
    const left, const right = try parseDoubleColumnInputList(fileName);
    const result = solvePart2(left, right);

    return PuzzleResult{.int =  result};
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
                count +=1;
            }
        }
        result += l * count;
    }
    return result;
}

fn parseDoubleColumnInputList(path: []const u8) !struct { []i32, []i32 } {
    const content = try readFile(path);
    var left = std.ArrayList(i32).init(mem);
    defer left.deinit();
    var right = std.ArrayList(i32).init(mem);
    defer right.deinit();

    var lines = std.mem.splitSequence(u8, content, "\n");
    while (lines.next()) |line| {
        const numbers = std.mem.splitSequence(u8, line, " ");
        const tuple = try parseDoubleColumnInputLine(numbers);
        try left.append(tuple.@"0");
        try right.append(tuple.@"1");
    }
    return .{
        try left.toOwnedSlice(),
        try right.toOwnedSlice(),
    };
}

fn parseDoubleColumnInputLine(_numbers: std.mem.SplitIterator(u8, .sequence)) !struct { i32, i32 } {
    var numbers = @constCast(&_numbers);
    var number = numbers.next().?;
    const left = try std.fmt.parseInt(i32, number, 10);

    while (true) {
        number = numbers.next().?;
        if (number.len <= 0) continue;
        const right = try std.fmt.parseInt(i32, number, 10);
        return .{ left, right };
    } else {
        @panic("No right value to parse");
    }
}