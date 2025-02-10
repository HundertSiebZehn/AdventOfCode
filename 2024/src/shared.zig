const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;

pub const PuzzleResult = union(enum) {
    int: i32
};

pub fn pickInputFile(number: u8, part: u8, comptime isExample: bool) []u8 {
    const len = if (isExample) 20 else 12;
    _ = part; // ignore for now
    var result: [len]u8 = undefined;
    std.mem.copyForwards(u8, result[0..6], "input/");
    _ = std.fmt.bufPrint(result[6..8], "{d:0>2.0}", .{number}) catch {};
    if (isExample) {
        std.mem.copyForwards(u8, result[8..20], ".example.txt");
    } else {
        std.mem.copyForwards(u8, result[8..12], ".txt");
    }
    //std.debug.print("path: {s}\n", .{result});

    return &result;
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