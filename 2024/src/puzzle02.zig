const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const shared = @import("shared.zig");
const PuzzleResult = shared.PuzzleResult;
const readFile = shared.readFile;
const pickInputFile = shared.pickInputFile;

pub fn runPart1(allocator: std.mem.Allocator, comptime isExample: bool) !PuzzleResult {
    const fileName = pickInputFile(2, 1, isExample);
    const reports = try parseReports(allocator, fileName);
    const result = solvePart1(reports);

    return PuzzleResult{ .int = result };
}

pub fn runPart2(allocator: std.mem.Allocator, comptime isExample: bool) !PuzzleResult {
    const fileName = pickInputFile(2, 2, isExample);
    const reports = try parseReports(allocator, fileName);
    const result = solvePart2(reports);

    return PuzzleResult{ .int = result };
}

fn solvePart1(reports: ArrayList(ArrayList(i32))) i32 {
    defer reports.deinit();
    var safeCount: i32 = 0;
    report: for (reports.items) |report| {
        defer report.deinit();
        // std.debug.print("\nReport: ", .{});
        var previous = report.items[0];
        var previousDiff: ?i32 = null;
        // std.debug.print("{d} ", .{previous});
        for (report.items[1..]) |current| {
            // std.debug.print("{d} ", .{current});
            const diff = previous - current;
            switch (@abs(diff)) {
                0 => continue :report,
                1, 2, 3 => {
                    if (previousDiff != null) {
                        if ((diff < 0) != (previousDiff.? < 0)) continue :report;
                    }
                    previousDiff = diff;
                    previous = current;
                },
                else => continue :report,
            }
        }

        // std.debug.print("Safe!\n", .{});
        safeCount += 1;
    }

    return safeCount;
}

fn solvePart2(reports: ArrayList(ArrayList(i32))) i32 {
    defer reports.deinit();
    var safeCount: i32 = 0;
    for (reports.items) |r| {
        var report: ArrayList(i32) = r;
        defer report.deinit();
        if (isSafe(report)) {
            safeCount += 1;
            continue;
        }
        for (0..report.items.len) |i| {
            var copy = report.clone() catch unreachable;
            defer copy.deinit();
            _ = copy.orderedRemove(i);
            if (isSafe(copy)) {
                safeCount += 1;
                break;
            }
        }
    }
    return safeCount;
}

fn isSafe(report: ArrayList(i32)) bool {
    var previous = report.items[0];
    var previousDiff: ?i32 = null;
    for (report.items[1..]) |current| {
        const diff = previous - current;
        switch (@abs(diff)) {
            0 => {
                return false;
            },
            1, 2, 3 => {
                if (previousDiff != null) {
                    if ((diff < 0) != (previousDiff.? < 0)) {
                        return false;
                    }
                }
                previousDiff = diff;
                previous = current;
            },
            else => {
                return false;
            },
        }
    }
    return true;
}

fn parseReports(allocator: std.mem.Allocator, path: []const u8) !ArrayList(ArrayList(i32)) {
    const content = try readFile(path);
    var reports = ArrayList(ArrayList(i32)).init(allocator);

    var lines = std.mem.splitSequence(u8, content, "\n");
    while (lines.next()) |line| {
        const levels = @constCast(&std.mem.splitSequence(u8, line, " "));
        var report = ArrayList(i32).init(allocator);
        while (levels.next()) |level| {
            if (level.len <= 0) continue; // skip empty
            const parsed = try std.fmt.parseInt(i32, level, 10);
            try report.append(parsed);
            // std.debug.print("{d} ", .{parsed});
        }
        try reports.append(report);
        // std.debug.print("\n", .{});
    }

    return reports;
}
