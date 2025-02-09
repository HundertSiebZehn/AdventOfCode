const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;
const puzzle01 = @import("puzzle01.zig");
const puzzle02 = @import("puzzle02.zig");


pub fn solve(number: u8, part: u8, comptime isExample: bool) !u8 {
    const fileName = try pickInputFile(number, part, isExample);
    switch (number) {
        1=> {
            const left, const right = try parseDoubleColumnInputList(fileName);
            const result = switch (part) {
                1 => puzzle01.solve(left, right),
                2 => puzzle01.solvePart2(left, right),
                else => @panic("no more parts"),
            };

            _ = try stdout.print("puzzle01:\t{d}\n", .{result});
        },
        2 => {
            const reports = try parseReports(mem, fileName);
            const result = puzzle02.solve(reports);

            _ = try stdout.print("puzzle02:\t{d}\n", .{result});
        },
        else => {}
    }

    return 0;
}

fn parseReports(allocator: std.mem.Allocator, path: []const u8) !ArrayList(ArrayList(i32)) {
    const content = try readFile(path);
    var reports = ArrayList(ArrayList(i32)).init(allocator);

    var lines = std.mem.splitSequence(u8, content, "\n");
    while(lines.next()) |line| {
        const levels = @constCast(&std.mem.splitSequence(u8, line, " "));
        var report = ArrayList(i32).init(allocator);
        while (levels.next()) |level| {
            if (std.mem.eql(u8, level, "")) continue; // skip empty
            const parsed = try std.fmt.parseInt(i32, level, 10);
            try report.append(parsed);
            //std.debug.print("{d} ", .{parsed});
        }
        try reports.append(report);
        // std.debug.print("\n", .{});
    }

    return reports;
}

fn pickInputFile(number: u8, part: u8, comptime isExample: bool) ![]u8 {
    const len = if (isExample) 20 else 12;
    _ = part; // ignore for now
    var result: [len]u8 = undefined;
    std.mem.copyForwards(u8, result[0..6], "input/");
    _ = try std.fmt.bufPrint(result[6..8], "{d:0>2.0}", .{number});
    if (isExample) {
        std.mem.copyForwards(u8, result[8..20], ".example.txt");
    } else {
        std.mem.copyForwards(u8, result[8..12], ".txt");
    }
    //std.debug.print("path: {s}\n", .{result});

    return &result;
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

fn readFile(path: []const u8) ![]u8 {
    var file = std.fs.cwd().openFile(path, .{}) catch |err| {
        switch (err) {
            std.fs.File.OpenError.FileNotFound => {
                _ = try stderr.print("File '{s}' was not found!", .{path});
                return err;
            },
            else => return err,
        }
    };
    defer file.close();
    return try file.readToEndAlloc(mem, (try file.stat()).size);
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

test "puzzle01 part1 & part2" {
    const fileName = try pickInputFile(1, 1, true);
    const left, const right = try parseDoubleColumnInputList(fileName);
    try testing.expectEqual(11, puzzle01.solve(left, right));
}

test "puzzle01 part1" {
    const fileName = try pickInputFile(1, 2, true);
    const left, const right = try parseDoubleColumnInputList(fileName);
    try testing.expectEqual(31, puzzle01.solvePart2(left, right));
}

test "puzzle02 part1" {
    const fileName = try pickInputFile(2, 1, true);
    const reports = try parseReports(testing.allocator, fileName);
    defer reports.deinit();
    try testing.expectEqual(2, puzzle02.solve(reports));
}
