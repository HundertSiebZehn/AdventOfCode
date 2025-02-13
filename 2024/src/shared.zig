const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;

pub const PuzzleResult = union(enum) { int: i32 };

pub fn pickInputFile(number: u8, part: ?u8, isExample: bool) []u8 {
    var len = if (isExample) @as(usize, 20) else @as(usize, 12);
    if (part != null) len += 2;
    var result: [22]u8 = undefined;
    std.mem.copyForwards(u8, result[0..6], "input/");
    _ = std.fmt.bufPrint(result[6..8], "{d:0>2.0}", .{number}) catch unreachable;
    if (isExample) {
        std.mem.copyForwards(u8, result[8..16], ".example");
        if (part != null) {
            _ = std.fmt.bufPrint(result[16..18], "_{d:1}", .{part.?}) catch unreachable;
            std.mem.copyForwards(u8, result[18..22], ".txt");
        } else {
            std.mem.copyForwards(u8, result[16..20], ".txt");
        }
    } else {
        if (part != null) {
            _ = std.fmt.bufPrint(result[8..10], "_{d:1}", .{part.?}) catch unreachable;
            std.mem.copyForwards(u8, result[10..14], ".txt");
        } else {
            std.mem.copyForwards(u8, result[8..12], ".txt");
        }
    }
    //std.debug.print("path: {s}\n", .{result});

    return result[0..len];
}

pub fn readFile(path: []const u8) ![]u8 {
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
