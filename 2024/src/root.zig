const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;
const puzzle01 = @import("puzzle01.zig");
const puzzle02 = @import("puzzle02.zig");
const shared = @import("shared.zig");
const pickInputFile = shared.pickInputFile;
const PuzzleResult = shared.PuzzleResult;


pub fn solve(number: u8, part: u8) !void {
    const result = switch (number) {
        1=> switch (part) {
                1 => try puzzle01.runPart1(mem, false),
                2 => try puzzle01.runPart2(mem, false),
                else => @panic("no more parts"),
            },
        2 => switch (part) {
            1 => try puzzle02.runPart1(mem, false),
            2 => try puzzle02.runPart2(mem, false),
            else => @panic("no more parts"),
        }, 
        else => @panic("not implemented yet"),
    };
    switch(result) {
        .int => |i|{
            _ = try stdout.print("Solution:\t{d}\n", .{i});
        }
    }
}

const PuzzleSetup = struct {
    number: u8,
    part: u8,
};

test "puzzle 01 part1" {
    try testing.expectEqual(PuzzleResult{.int = 11}, puzzle01.runPart1(testing.allocator, true));
}

test "puzzle 01 part 2" {
    try testing.expectEqual(PuzzleResult{.int = 31}, puzzle01.runPart2(testing.allocator, true));
}

test "puzzle 02 part 1" {
    try testing.expectEqual(PuzzleResult{.int = 2},puzzle02.runPart1(testing.allocator, true));
}

test "puzzle 02 part 2" {
    try testing.expectEqual(PuzzleResult{.int = 4}, puzzle02.runPart2(testing.allocator, true));
}
