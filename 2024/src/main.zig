const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const lib = @import("./root.zig");


pub fn main() !u8 {
    const allo = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allo);
    defer std.process.argsFree(allo, args);
    // for (0.., args) |i, arg| {
    //     //try std.fmt.format(stdout, "%s: %s\n", i, arg);
    //     try stdout.print("{d}: {s}\n", .{i , arg});
    // }
    if (args[1..].len != 1) {
        try stderr.print("Missing argument\n", .{});
        return 1;
    }
    const puzzleNo = try std.fmt.parseInt(u8, args[1], 10);
    return lib.solve(puzzleNo);
}
