const std = @import("std");

const Token = union(enum) {
    IDENT: []const u8,
    INT: []const u8,

    EQUAL,
    EOF,
    ILLEGAL,
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
        self.skipWhiteSpaces();
        const token: Token = switch (self.current_char) {
            '0'...'9' => {
                const int = self.readIntOrIdent(std.ascii.isDigit);
                return .{ .INT = int };
            },
            'a'...'z', 'A'...'Z', '_' => {
                const ident = self.readIntOrIdent(std.ascii.isAlphabetic);
                return .{ .IDENT = ident };
            },
            '=' => .EQUAL,
            0 => .EOF,
            else => .ILLEGAL,
        };

        self.readChar();
        return token;
    }

    pub fn skipWhiteSpaces(self: *Self) void {
        while (std.ascii.isWhitespace(self.current_char)) {
            self.readChar();
        }
    }

    pub fn readIntOrIdent(self: *Self, condition: *const fn (u8) bool) []const u8 {
        const position = self.current_pos;

        while (condition(self.current_char)) {
            self.readChar();
        }

        return self.input[position..self.current_pos];
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

test "Lexer" {
    const input =
        \\const x = 5;
    ;

    var lex = Lexer.init(input);
    var tokens = [_]Token{
        .{ .IDENT = "const" },
        .{ .IDENT = "x" },
        .EQUAL,
        .{ .INT = "5" },
    };

    for (tokens) |token| {
        const tok = lex.matchToken();

        try std.testing.expectEqualDeep(token, tok);
    }
}
