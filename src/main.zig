const std = @import("std");

const Token = union(enum) { EOF, EQUAL: u8 };

fn matchToken(line: u8) ?Token {
    return switch (line) {
        'a'...'z' => .EOF,
        '0'...'9' => .{ .EQUAL = 9 },
        else => undefined,
    };
}

pub fn main() !void {
    var reader = std.io.getStdIn().reader();

    var buffer: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var token = matchToken(line[0]);

        if (token) |t| {
            std.debug.print("{?}\n", .{t});
        }
    }
}
