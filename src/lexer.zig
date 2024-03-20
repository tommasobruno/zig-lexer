const std = @import("std");

const Token = union(enum) {
    EQUAL,
};

pub const Lexer = struct {
    const Self = @This();

    input: []const u8,
    current_pos: u8 = 0,
    current_read_pos: u8 = 0,
    current_char: u8 = 0,

    pub fn init(input: []const u8) Self {
        var lex = Self{ .input = input };

        lex.readChar();
        return lex;
    }

    pub fn matchToken(self: *Self) Token {
        const token: Token = switch (self.current_char) {
            '=' => .EQUAL,
            else => .EOF,
        };

        self.readChar();
        return token;
    }

    pub fn readChar(self: *Self) void {
        if (self.current_read_pos >= self.input.len) {
            self.current_char = 0;
            return;
        }

        const char = self.input[self.current_read_pos];

        self.current_pos = self.current_read_pos;
        self.current_read_pos += 1;
        self.current_char = char;
    }

    pub fn canRead(self: *Self) bool {
        return self.current_char != 0;
    }
};
