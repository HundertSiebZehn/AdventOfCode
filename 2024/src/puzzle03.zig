const std = @import("std");
const ArrayList = std.ArrayList;
const testing = std.testing;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const shared = @import("shared.zig");
const PuzzleResult = shared.PuzzleResult;
const readFile = shared.readFile;
const pickInputFile = shared.pickInputFile;
const Allocator = std.mem.Allocator;

pub fn runPart1(allocator: Allocator, comptime isExample: bool) !PuzzleResult {
    _ = allocator;
    const fileName = pickInputFile(3, if (isExample) 1 else null, isExample);
    const content = readFile(fileName) catch unreachable;

    const result = try solvePart1(content);
    return PuzzleResult{ .int = result };
}

pub fn runPart2(allocator: Allocator, comptime isExample: bool) !PuzzleResult {
    _ = allocator;
    const fileName = pickInputFile(3, if (isExample) 2 else null, isExample);
    const content = readFile(fileName) catch unreachable;

    const result = try solvePart2(content);
    return PuzzleResult{ .int = result };
}

fn solvePart1(input: []u8) !i32 {
    var sum: i32 = 0;
    var left: [3]u8 = undefined;
    var i: usize = 0;
    var right: [3]u8 = undefined;
    var j: usize = 0;
    var state = State.M;

    for (input) |current| {
        std.log.debug("{c}", .{current});
        switch (current) {
            'm' => {
                if (state == State.M) {
                    state = State.MU;
                } else {
                    state = State.M;
                }
            },
            'u' => {
                if (state == State.MU) {
                    state = State.MUL;
                } else {
                    state = State.M;
                }
            },
            'l' => {
                if (state == State.MUL) {
                    state = State.OPEN_BRACKET;
                } else {
                    state = State.M;
                }
            },
            '(' => {
                if (state == State.OPEN_BRACKET) {
                    state = State.LEFT_NUMBER;
                    left = undefined;
                    i = 0;
                    right = undefined;
                    j = 0;
                } else {
                    state = State.M;
                }
            },
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => {
                switch (state) {
                    State.LEFT_NUMBER => {
                        left[i] = current;
                        i += 1;
                        if (i >= 3) state = State.COMMA;
                        std.log.debug("current left: {s} in state {s}", .{ left, @tagName(state) });
                    },
                    State.RIGHT_NUMBER => {
                        right[j] = current;
                        j += 1;
                        if (j >= 3) state = State.CLOSE_BRACKET;
                        std.log.debug("current right: {s} in state {s}", .{ right, @tagName(state) });
                    },
                    else => {
                        state = State.M;
                    },
                }
            },
            ',' => {
                if (state == State.COMMA or state == State.LEFT_NUMBER) {
                    state = State.RIGHT_NUMBER;
                } else {
                    state = State.M;
                }
            },
            ')' => {
                if (state == State.CLOSE_BRACKET or state == State.RIGHT_NUMBER) {
                    const mult = try parseAndMult(left[0..i], right[0..j]);
                    std.log.debug("MULT({s},{s}) = {d}", .{ left[0..i], right[0..j], mult });
                    sum += mult;
                    left = undefined;
                    i = 0;
                    right = undefined;
                    j = 0;
                }
                state = State.M;
            },
            else => {
                std.log.debug("skipping", .{});
                state = State.M;
            },
        }
    }

    return sum;
}

fn solvePart2(input: []u8) !i32 {
    var sum: i32 = 0;
    var do = true;
    var left: [3]u8 = undefined;
    var i: usize = 0;
    var right: [3]u8 = undefined;
    var j: usize = 0;
    var state = State2.M_OR_D;

    for (input) |current| {
        std.log.debug("{c}", .{current});
        switch (current) {
            'm' => {
                if (do and state == State2.M_OR_D) {
                    state = State2.MU;
                } else {
                    state = State2.M_OR_D;
                }
            },
            'u' => {
                if (state == State2.MU) {
                    state = State2.MUL;
                } else {
                    state = State2.M_OR_D;
                }
            },
            'l' => {
                if (state == State2.MUL) {
                    state = State2.MUL_OPEN_BRACKET;
                } else {
                    state = State2.M_OR_D;
                }
            },
            '(' => {
                switch (state) {
                    State2.MUL_OPEN_BRACKET => {
                        state = State2.LEFT_NUMBER;
                        left = undefined;
                        i = 0;
                        right = undefined;
                        j = 0;
                    },
                    State2.DO_OPEN_BRACKET_OR_DON => {
                        state = State2.DO_CLOSE_BRACKET;
                    },
                    State2.DON_T_OPEN_BRACKET => {
                        state = State2.DON_T_CLOSE_BRACKET;
                    },
                    else => {
                        state = State2.M_OR_D;
                    },
                }
            },
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => {
                switch (state) {
                    State2.LEFT_NUMBER => {
                        left[i] = current;
                        i += 1;
                        if (i >= 3) state = State2.COMMA;
                        std.log.debug("current left: {s} in state {s}", .{ left, @tagName(state) });
                    },
                    State2.RIGHT_NUMBER => {
                        right[j] = current;
                        j += 1;
                        if (j >= 3) state = State2.MUL_CLOSE_BRACKET;
                        std.log.debug("current right: {s} in state {s}", .{ right, @tagName(state) });
                    },
                    else => {
                        state = State2.M_OR_D;
                    },
                }
            },
            ',' => {
                if (state == State2.COMMA or state == State2.LEFT_NUMBER) {
                    state = State2.RIGHT_NUMBER;
                } else {
                    state = State2.M_OR_D;
                }
            },
            ')' => {
                switch (state) {
                    State2.MUL_CLOSE_BRACKET, State2.RIGHT_NUMBER => {
                        const mult = try parseAndMult(left[0..i], right[0..j]);
                        std.log.debug("MULT({s},{s}) = {d}", .{ left[0..i], right[0..j], mult });
                        sum += mult;
                        left = undefined;
                        i = 0;
                        right = undefined;
                        j = 0;
                    },
                    State2.DO_CLOSE_BRACKET => {
                        std.log.debug("DO!", .{});
                        do = true;
                        state = State2.M_OR_D;
                    },
                    State2.DON_T_CLOSE_BRACKET => {
                        std.log.debug("DON'T!", .{});
                        do = false;
                        state = State2.M_OR_D;
                    },
                    else => {
                        state = State2.M_OR_D;
                    },
                }
                state = State2.M_OR_D;
            },
            'd' => {
                if (state == State2.M_OR_D) {
                    state = State2.DO;
                } else {
                    state = State2.M_OR_D;
                }
            },
            'o' => {
                if (state == State2.DO) {
                    state = State2.DO_OPEN_BRACKET_OR_DON;
                } else {
                    state = State2.M_OR_D;
                }
            },
            'n' => {
                if (state == State2.DO_OPEN_BRACKET_OR_DON) {
                    state = State2.DON_;
                } else {
                    state = State2.M_OR_D;
                }
            },
            '\'' => {
                if (state == State2.DON_) {
                    state = State2.DON_T;
                } else {
                    state = State2.M_OR_D;
                }
            },
            't' => {
                if (state == State2.DON_T) {
                    state = State2.DON_T_OPEN_BRACKET;
                } else {
                    state = State2.M_OR_D;
                }
            },
            else => {
                std.log.debug("skipping", .{});
                state = State2.M_OR_D;
            },
        }
    }

    return sum;
}

fn parseAndMult(left: []u8, right: []u8) !i32 {
    const l = try std.fmt.parseInt(i32, left, 10);
    const r = try std.fmt.parseInt(i32, right, 10);

    return l * r;
}

const State = enum {
    M,
    MU,
    MUL,
    OPEN_BRACKET,
    LEFT_NUMBER,
    COMMA,
    RIGHT_NUMBER,
    CLOSE_BRACKET,
};

const State2 = enum {
    M_OR_D,
    MU,
    MUL,
    MUL_OPEN_BRACKET,
    LEFT_NUMBER,
    COMMA,
    RIGHT_NUMBER,
    MUL_CLOSE_BRACKET,
    DO,
    DON_,
    DON_T,
    DO_OPEN_BRACKET_OR_DON,
    DO_CLOSE_BRACKET,
    DON_T_OPEN_BRACKET,
    DON_T_CLOSE_BRACKET,
};
