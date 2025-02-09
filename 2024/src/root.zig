const std = @import("std");
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;
const puzzle01 = @import("puzzle01.zig");

pub fn solve(number: u8, part: u8, comptime isExample: bool) !u8 {
    const fileName = try pickInputFile(number, part, isExample);
    switch (number) {
        1=> {
            const left, const right = try parseDoubleColumnInputlist(fileName);
            const result = switch (part) {
                1 => puzzle01.solve(left, right),
                2 => puzzle01.solvePart2(left, right),
                else => @panic("no more parts"),
            };

            _ = try stdout.print("puzzle01:\t{}\n", .{result});
        },
        else => {}
    }

    return 0;
}

fn pickInputFile(number: u8, part: u8, comptime isExample: bool) ![]u8 {
    const len = if (isExample) 20 else 12;
    _ = part;
    var result: [len]u8 = undefined;
    std.mem.copyForwards(u8, result[0..6], "input/");
    _ = try std.fmt.bufPrint(result[6..8], "{d:0>2.0}", .{number});
    if (isExample) {
        std.mem.copyForwards(u8, result[8..20], ".example.txt");
    } else {
        std.mem.copyForwards(u8, result[8..12], ".txt");
    }
    // std.debug.print("path: {s}\n", .{result});

    return &result;
}

fn parseDoubleColumnInputlist(path: []const u8) !struct { []i32, []i32 } {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const content = try file.readToEndAlloc(mem, (try file.stat()).size);
    var left = std.ArrayList(i32).init(mem);
    defer left.deinit();
    var right = std.ArrayList(i32).init(mem);
    defer right.deinit();

    var lines = std.mem.splitSequence(u8, content, "\n");
    while (lines.next()) |line| {
        const numbers = std.mem.splitSequence(u8, line, " ");
        const tuple = try parseLine(numbers);
        try left.append(tuple.@"0");
        try right.append(tuple.@"1");
    }
    return .{
        try left.toOwnedSlice(),
        try right.toOwnedSlice(),
    };
}

fn parseLine(_numbers: std.mem.SplitIterator(u8, .sequence)) !struct { i32, i32 } {
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

test "puzzle01" {
    const fileName = try pickInputFile(1, 1, true);
    const left, const right = try parseDoubleColumnInputlist(fileName);
    try testing.expectEqual(11, puzzle01.solve(left, right));
}

test "puzzle01 part 2" {
    const fileName = try pickInputFile(1, 2, true);
    const left, const right = try parseDoubleColumnInputlist(fileName);
    try testing.expectEqual(31, puzzle01.solvePart2(left, right));
}
