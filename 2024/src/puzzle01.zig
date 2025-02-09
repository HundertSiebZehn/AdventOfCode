const std = @import("std");
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const mem = std.heap.page_allocator;

pub fn solve(left: []i32, right: []i32) i32 {
    std.mem.sort(i32, left, {}, std.sort.asc(i32));
    std.mem.sort(i32, right, {}, std.sort.asc(i32));

    var dist: u32 = 0;
    for (left, right) |l, r| {
        dist += @abs(l - r);
    }

    return @intCast(dist);
}

pub fn solvePart2(left: []i32, right: []i32) i32 {
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