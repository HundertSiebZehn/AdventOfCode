const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;


pub fn solve(reports: ArrayList(ArrayList(i32))) i32 {
    var safeCount: i32 = 0;
    report: for (reports.items) |report| {
        //std.debug.print("\nReport: ", .{});
        var previous = report.items[0];
        var previousDiff: ?i32 = null;
        //std.debug.print("{d} ", .{previous});
        for (report.items[1..]) |current| {
            //std.debug.print("{d} ", .{current});
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
        
        //std.debug.print("Safe!\n", .{});
        safeCount += 1;
    }

    return safeCount;
}

pub fn solvePart2() void {
    
}