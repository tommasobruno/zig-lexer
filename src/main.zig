const std = @import("std");
const lexer = @import("./lexer.zig");

pub fn main() void {
    const buffer: []const u8 = "const x = 2;";

    var lex = lexer.Lexer.init(buffer);

    while (lex.canRead()) {
        const token = lex.matchToken();

        std.debug.print("{}\n", .{token});
    }
}

test {
    _ = @import("./lexer.zig");
}
