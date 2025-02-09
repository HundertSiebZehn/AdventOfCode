const std = @import("std");
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;
const puzzle01 = @import("puzzle01.zig");

pub fn solve(number: u8) !u8 {
    switch (number) {
        1 => {
            const left, const right = try parseDoubleInputlist("input/1.txt");
            const dist = puzzle01.solve(left, right);

            _ = try stdout.print("puzzle01:\t{}\n", .{dist});
        },
        else => {}
    }

    return 0;
}

fn parseDoubleInputlist(path: []const u8) !struct { []i32, []i32 } {
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
