// zig translation of charset.h from llvm-mos-sdk.
//
// Copyright 2023 LLVM-MOS Project Licensed under the Apache License,
// Version 2.0 with LLVM Exceptions. See
// https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license information.

// | Function                | C++ suffix | Output                                  |
// |-------------------------|------------|-----------------------------------------|
// | `unshifted`             | `_u`       | PETSCII, upper case/graphics set        |
// | `shifted`               | `_s`       | PETSCII, upper/lower case set           |
// | `unshiftedVideo`        | `_uv`      | screen codes, upper case/graphics set   |
// | `unshiftedReverseVideo` | `_urv`     | reverse screen codes, upper case/graphics set |
// | `shiftedVideo`          | `_sv`      | screen codes, upper/lower case set      |
// | `shiftedReverseVideo`   | `_srv`     | reverse screen codes, upper/lower case set |

const std = @import("std");

const Entry = struct { u21, u8 };

/// PETSCII, primary (upper case/graphics) character set. C0 control codes are uninterpreted.
pub fn unshifted(comptime s: []const u8) *const [len(s):0]u8 {
    return convert(s, &unshifted_table, true);
}

/// PETSCII, alternate (upper/lower case) character set. C0 control codes are uninterpreted.
pub fn shifted(comptime s: []const u8) *const [len(s):0]u8 {
    return convert(s, &shifted_table, true);
}

/// Screen codes, primary (upper case/graphics) character set.
pub fn unshiftedVideo(comptime s: []const u8) *const [len(s):0]u8 {
    return convert(s, &unshifted_video_table, false);
}

/// Reverse video screen codes, primary (upper case/graphics) character set.
pub fn unshiftedReverseVideo(comptime s: []const u8) *const [len(s):0]u8 {
    return convert(s, &unshifted_reverse_video_table, false);
}

/// Screen codes, alternate (upper/lower case) character set.
pub fn shiftedVideo(comptime s: []const u8) *const [len(s):0]u8 {
    return convert(s, &shifted_video_table, false);
}

/// Reverse video screen codes, alternate (upper/lower case) character set.
pub fn shiftedReverseVideo(comptime s: []const u8) *const [len(s):0]u8 {
    return convert(s, &shifted_reverse_video_table, false);
}

fn len(comptime s: []const u8) usize {
    return std.unicode.utf8CountCodepoints(s) catch @compileError("invalid UTF-8 string");
}

fn convert(comptime s: []const u8, comptime table: []const Entry, comptime c0: bool) *const [len(s):0]u8 {
    comptime {
        @setEvalBranchQuota(1000 + s.len * 1000);
        var out: [len(s):0]u8 = undefined;
        var it = std.unicode.Utf8View.initComptime(s).iterator();
        var i: usize = 0;
        while (it.nextCodepoint()) |cp| : (i += 1) {
            out[i] = translate(cp, table, c0);
        }
        out[out.len] = 0;
        const final = out;
        return &final;
    }
}

fn translate(comptime cp: u21, comptime table: []const Entry, comptime c0: bool) u8 {
    // PETSCII: C0 control codes are uninterpreted. Screen codes: preserve NUL.
    if (c0 and cp <= 0x1F) return @intCast(cp);
    if (!c0 and cp == 0) return 0;
    for (table) |e| {
        if (e[0] == cp) return e[1];
    }
    @compileError(std.fmt.comptimePrint("Unsupported character U+{X:0>4}", .{cp}));
}

// Name: Map from Commodore 64/128 (interchange) primary character set to Unicode
// Date: 2018 April 20
// Author: Rebecca Bettencourt <support@kreativekorp.com>
const unshifted_table = [_]Entry{
    .{ 0x0020, 0x20 }, // SPACE
    .{ 0x0021, 0x21 }, // EXCLAMATION MARK
    .{ 0x0022, 0x22 }, // QUOTATION MARK
    .{ 0x0023, 0x23 }, // NUMBER SIGN
    .{ 0x0024, 0x24 }, // DOLLAR SIGN
    .{ 0x0025, 0x25 }, // PERCENT SIGN
    .{ 0x0026, 0x26 }, // AMPERSAND
    .{ 0x0027, 0x27 }, // APOSTROPHE
    .{ 0x0028, 0x28 }, // LEFT PARENTHESIS
    .{ 0x0029, 0x29 }, // RIGHT PARENTHESIS
    .{ 0x002A, 0x2A }, // ASTERISK
    .{ 0x002B, 0x2B }, // PLUS SIGN
    .{ 0x002C, 0x2C }, // COMMA
    .{ 0x002D, 0x2D }, // HYPHEN-MINUS
    .{ 0x002E, 0x2E }, // FULL STOP
    .{ 0x002F, 0x2F }, // SOLIDUS
    .{ 0x0030, 0x30 }, // DIGIT ZERO
    .{ 0x0031, 0x31 }, // DIGIT ONE
    .{ 0x0032, 0x32 }, // DIGIT TWO
    .{ 0x0033, 0x33 }, // DIGIT THREE
    .{ 0x0034, 0x34 }, // DIGIT FOUR
    .{ 0x0035, 0x35 }, // DIGIT FIVE
    .{ 0x0036, 0x36 }, // DIGIT SIX
    .{ 0x0037, 0x37 }, // DIGIT SEVEN
    .{ 0x0038, 0x38 }, // DIGIT EIGHT
    .{ 0x0039, 0x39 }, // DIGIT NINE
    .{ 0x003A, 0x3A }, // COLON
    .{ 0x003B, 0x3B }, // SEMICOLON
    .{ 0x003C, 0x3C }, // LESS-THAN SIGN
    .{ 0x003D, 0x3D }, // EQUALS SIGN
    .{ 0x003E, 0x3E }, // GREATER-THAN SIGN
    .{ 0x003F, 0x3F }, // QUESTION MARK
    .{ 0x0040, 0x40 }, // COMMERCIAL AT
    .{ 0x0041, 0x41 }, // LATIN CAPITAL LETTER A
    .{ 0x0042, 0x42 }, // LATIN CAPITAL LETTER B
    .{ 0x0043, 0x43 }, // LATIN CAPITAL LETTER C
    .{ 0x0044, 0x44 }, // LATIN CAPITAL LETTER D
    .{ 0x0045, 0x45 }, // LATIN CAPITAL LETTER E
    .{ 0x0046, 0x46 }, // LATIN CAPITAL LETTER F
    .{ 0x0047, 0x47 }, // LATIN CAPITAL LETTER G
    .{ 0x0048, 0x48 }, // LATIN CAPITAL LETTER H
    .{ 0x0049, 0x49 }, // LATIN CAPITAL LETTER I
    .{ 0x004A, 0x4A }, // LATIN CAPITAL LETTER J
    .{ 0x004B, 0x4B }, // LATIN CAPITAL LETTER K
    .{ 0x004C, 0x4C }, // LATIN CAPITAL LETTER L
    .{ 0x004D, 0x4D }, // LATIN CAPITAL LETTER M
    .{ 0x004E, 0x4E }, // LATIN CAPITAL LETTER N
    .{ 0x004F, 0x4F }, // LATIN CAPITAL LETTER O
    .{ 0x0050, 0x50 }, // LATIN CAPITAL LETTER P
    .{ 0x0051, 0x51 }, // LATIN CAPITAL LETTER Q
    .{ 0x0052, 0x52 }, // LATIN CAPITAL LETTER R
    .{ 0x0053, 0x53 }, // LATIN CAPITAL LETTER S
    .{ 0x0054, 0x54 }, // LATIN CAPITAL LETTER T
    .{ 0x0055, 0x55 }, // LATIN CAPITAL LETTER U
    .{ 0x0056, 0x56 }, // LATIN CAPITAL LETTER V
    .{ 0x0057, 0x57 }, // LATIN CAPITAL LETTER W
    .{ 0x0058, 0x58 }, // LATIN CAPITAL LETTER X
    .{ 0x0059, 0x59 }, // LATIN CAPITAL LETTER Y
    .{ 0x005A, 0x5A }, // LATIN CAPITAL LETTER Z
    .{ 0x005B, 0x5B }, // LEFT SQUARE BRACKET
    .{ 0x00A3, 0x5C }, // POUND SIGN
    .{ 0x005D, 0x5D }, // RIGHT SQUARE BRACKET
    .{ 0x2191, 0x5E }, // UPWARDS ARROW
    .{ 0x2190, 0x5F }, // LEFTWARDS ARROW
    .{ 0x2500, 0x60 }, // BOX DRAWINGS LIGHT HORIZONTAL
    .{ 0x2660, 0x61 }, // BLACK SPADE SUIT
    .{ 0x1FB72, 0x62 }, // VERTICAL ONE EIGHTH BLOCK-4
    .{ 0x1FB78, 0x63 }, // HORIZONTAL ONE EIGHTH BLOCK-4
    .{ 0x1FB77, 0x64 }, // HORIZONTAL ONE EIGHTH BLOCK-3
    .{ 0x1FB76, 0x65 }, // HORIZONTAL ONE EIGHTH BLOCK-2
    .{ 0x1FB7A, 0x66 }, // HORIZONTAL ONE EIGHTH BLOCK-6
    .{ 0x1FB71, 0x67 }, // VERTICAL ONE EIGHTH BLOCK-3
    .{ 0x1FB74, 0x68 }, // VERTICAL ONE EIGHTH BLOCK-6
    .{ 0x256E, 0x69 }, // BOX DRAWINGS LIGHT ARC DOWN AND LEFT
    .{ 0x2570, 0x6A }, // BOX DRAWINGS LIGHT ARC UP AND RIGHT
    .{ 0x256F, 0x6B }, // BOX DRAWINGS LIGHT ARC UP AND LEFT
    .{ 0x1FB7C, 0x6C }, // LEFT AND LOWER ONE EIGHTH BLOCK
    .{ 0x2572, 0x6D }, // BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
    .{ 0x2571, 0x6E }, // BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
    .{ 0x1FB7D, 0x6F }, // LEFT AND UPPER ONE EIGHTH BLOCK
    .{ 0x1FB7E, 0x70 }, // RIGHT AND UPPER ONE EIGHTH BLOCK
    .{ 0x2022, 0x71 }, // BULLET
    .{ 0x25CF, 0x71 }, // BLACK CIRCLE
    .{ 0x1FB7B, 0x72 }, // HORIZONTAL ONE EIGHTH BLOCK-7
    .{ 0x2665, 0x73 }, // BLACK HEART SUIT
    .{ 0x1FB70, 0x74 }, // VERTICAL ONE EIGHTH BLOCK-2
    .{ 0x256D, 0x75 }, // BOX DRAWINGS LIGHT ARC DOWN AND RIGHT
    .{ 0x2573, 0x76 }, // BOX DRAWINGS LIGHT DIAGONAL CROSS
    .{ 0x25CB, 0x77 }, // WHITE CIRCLE
    .{ 0x25E6, 0x77 }, // WHITE BULLET
    .{ 0x2663, 0x78 }, // BLACK CLUB SUIT
    .{ 0x1FB75, 0x79 }, // VERTICAL ONE EIGHTH BLOCK-7
    .{ 0x2666, 0x7A }, // BLACK DIAMOND SUIT
    .{ 0x253C, 0x7B }, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
    .{ 0x1FB8C, 0x7C }, // LEFT HALF MEDIUM SHADE
    .{ 0x2502, 0x7D }, // BOX DRAWINGS LIGHT VERTICAL
    .{ 0x03C0, 0x7E }, // GREEK SMALL LETTER PI
    .{ 0x25E5, 0x7F }, // BLACK UPPER RIGHT TRIANGLE
    .{ 0x00A0, 0xA0 }, // NO-BREAK SPACE
    .{ 0x258C, 0xA1 }, // LEFT HALF BLOCK
    .{ 0x2584, 0xA2 }, // LOWER HALF BLOCK
    .{ 0x2594, 0xA3 }, // UPPER ONE EIGHTH BLOCK
    .{ 0x2581, 0xA4 }, // LOWER ONE EIGHTH BLOCK
    .{ 0x258F, 0xA5 }, // LEFT ONE EIGHTH BLOCK
    .{ 0x2592, 0xA6 }, // MEDIUM SHADE
    .{ 0x2595, 0xA7 }, // RIGHT ONE EIGHTH BLOCK
    .{ 0x1FB8F, 0xA8 }, // LOWER HALF MEDIUM SHADE
    .{ 0x25E4, 0xA9 }, // BLACK UPPER LEFT TRIANGLE
    .{ 0x1FB87, 0xAA }, // RIGHT ONE QUARTER BLOCK
    .{ 0x251C, 0xAB }, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
    .{ 0x2597, 0xAC }, // QUADRANT LOWER RIGHT
    .{ 0x2514, 0xAD }, // BOX DRAWINGS LIGHT UP AND RIGHT
    .{ 0x2510, 0xAE }, // BOX DRAWINGS LIGHT DOWN AND LEFT
    .{ 0x2582, 0xAF }, // LOWER ONE QUARTER BLOCK
    .{ 0x250C, 0xB0 }, // BOX DRAWINGS LIGHT DOWN AND RIGHT
    .{ 0x2534, 0xB1 }, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
    .{ 0x252C, 0xB2 }, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
    .{ 0x2524, 0xB3 }, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
    .{ 0x258E, 0xB4 }, // LEFT ONE QUARTER BLOCK
    .{ 0x258D, 0xB5 }, // LEFT THREE EIGHTHS BLOCK
    .{ 0x1FB88, 0xB6 }, // RIGHT THREE EIGHTHS BLOCK
    .{ 0x1FB82, 0xB7 }, // UPPER ONE QUARTER BLOCK
    .{ 0x1FB83, 0xB8 }, // UPPER THREE EIGHTHS BLOCK
    .{ 0x2583, 0xB9 }, // LOWER THREE EIGHTHS BLOCK
    .{ 0x1FB7F, 0xBA }, // RIGHT AND LOWER ONE EIGHTH BLOCK
    .{ 0x2596, 0xBB }, // QUADRANT LOWER LEFT
    .{ 0x259D, 0xBC }, // QUADRANT UPPER RIGHT
    .{ 0x2518, 0xBD }, // BOX DRAWINGS LIGHT UP AND LEFT
    .{ 0x2598, 0xBE }, // QUADRANT UPPER LEFT
    .{ 0x259A, 0xBF }, // QUADRANT UPPER LEFT AND LOWER RIGHT
};

// Name: Map from Commodore 64/128 (interchange) alternate character set to Unicode
// Date: 2018 October 11
// Author: Rebecca Bettencourt <support@kreativekorp.com>
const shifted_table = [_]Entry{
    .{ 0x0020, 0x20 }, // SPACE
    .{ 0x0021, 0x21 }, // EXCLAMATION MARK
    .{ 0x0022, 0x22 }, // QUOTATION MARK
    .{ 0x0023, 0x23 }, // NUMBER SIGN
    .{ 0x0024, 0x24 }, // DOLLAR SIGN
    .{ 0x0025, 0x25 }, // PERCENT SIGN
    .{ 0x0026, 0x26 }, // AMPERSAND
    .{ 0x0027, 0x27 }, // APOSTROPHE
    .{ 0x0028, 0x28 }, // LEFT PARENTHESIS
    .{ 0x0029, 0x29 }, // RIGHT PARENTHESIS
    .{ 0x002A, 0x2A }, // ASTERISK
    .{ 0x002B, 0x2B }, // PLUS SIGN
    .{ 0x002C, 0x2C }, // COMMA
    .{ 0x002D, 0x2D }, // HYPHEN-MINUS
    .{ 0x002E, 0x2E }, // FULL STOP
    .{ 0x002F, 0x2F }, // SOLIDUS
    .{ 0x0030, 0x30 }, // DIGIT ZERO
    .{ 0x0031, 0x31 }, // DIGIT ONE
    .{ 0x0032, 0x32 }, // DIGIT TWO
    .{ 0x0033, 0x33 }, // DIGIT THREE
    .{ 0x0034, 0x34 }, // DIGIT FOUR
    .{ 0x0035, 0x35 }, // DIGIT FIVE
    .{ 0x0036, 0x36 }, // DIGIT SIX
    .{ 0x0037, 0x37 }, // DIGIT SEVEN
    .{ 0x0038, 0x38 }, // DIGIT EIGHT
    .{ 0x0039, 0x39 }, // DIGIT NINE
    .{ 0x003A, 0x3A }, // COLON
    .{ 0x003B, 0x3B }, // SEMICOLON
    .{ 0x003C, 0x3C }, // LESS-THAN SIGN
    .{ 0x003D, 0x3D }, // EQUALS SIGN
    .{ 0x003E, 0x3E }, // GREATER-THAN SIGN
    .{ 0x003F, 0x3F }, // QUESTION MARK
    .{ 0x0040, 0x40 }, // COMMERCIAL AT
    .{ 0x0061, 0x41 }, // LATIN SMALL LETTER A
    .{ 0x0062, 0x42 }, // LATIN SMALL LETTER B
    .{ 0x0063, 0x43 }, // LATIN SMALL LETTER C
    .{ 0x0064, 0x44 }, // LATIN SMALL LETTER D
    .{ 0x0065, 0x45 }, // LATIN SMALL LETTER E
    .{ 0x0066, 0x46 }, // LATIN SMALL LETTER F
    .{ 0x0067, 0x47 }, // LATIN SMALL LETTER G
    .{ 0x0068, 0x48 }, // LATIN SMALL LETTER H
    .{ 0x0069, 0x49 }, // LATIN SMALL LETTER I
    .{ 0x006A, 0x4A }, // LATIN SMALL LETTER J
    .{ 0x006B, 0x4B }, // LATIN SMALL LETTER K
    .{ 0x006C, 0x4C }, // LATIN SMALL LETTER L
    .{ 0x006D, 0x4D }, // LATIN SMALL LETTER M
    .{ 0x006E, 0x4E }, // LATIN SMALL LETTER N
    .{ 0x006F, 0x4F }, // LATIN SMALL LETTER O
    .{ 0x0070, 0x50 }, // LATIN SMALL LETTER P
    .{ 0x0071, 0x51 }, // LATIN SMALL LETTER Q
    .{ 0x0072, 0x52 }, // LATIN SMALL LETTER R
    .{ 0x0073, 0x53 }, // LATIN SMALL LETTER S
    .{ 0x0074, 0x54 }, // LATIN SMALL LETTER T
    .{ 0x0075, 0x55 }, // LATIN SMALL LETTER U
    .{ 0x0076, 0x56 }, // LATIN SMALL LETTER V
    .{ 0x0077, 0x57 }, // LATIN SMALL LETTER W
    .{ 0x0078, 0x58 }, // LATIN SMALL LETTER X
    .{ 0x0079, 0x59 }, // LATIN SMALL LETTER Y
    .{ 0x007A, 0x5A }, // LATIN SMALL LETTER Z
    .{ 0x005B, 0x5B }, // LEFT SQUARE BRACKET
    .{ 0x00A3, 0x5C }, // POUND SIGN
    .{ 0x005D, 0x5D }, // RIGHT SQUARE BRACKET
    .{ 0x2191, 0x5E }, // UPWARDS ARROW
    .{ 0x2190, 0x5F }, // LEFTWARDS ARROW
    .{ 0x2500, 0x60 }, // BOX DRAWINGS LIGHT HORIZONTAL
    .{ 0x0041, 0x61 }, // LATIN CAPITAL LETTER A
    .{ 0x0042, 0x62 }, // LATIN CAPITAL LETTER B
    .{ 0x0043, 0x63 }, // LATIN CAPITAL LETTER C
    .{ 0x0044, 0x64 }, // LATIN CAPITAL LETTER D
    .{ 0x0045, 0x65 }, // LATIN CAPITAL LETTER E
    .{ 0x0046, 0x66 }, // LATIN CAPITAL LETTER F
    .{ 0x0047, 0x67 }, // LATIN CAPITAL LETTER G
    .{ 0x0048, 0x68 }, // LATIN CAPITAL LETTER H
    .{ 0x0049, 0x69 }, // LATIN CAPITAL LETTER I
    .{ 0x004A, 0x6A }, // LATIN CAPITAL LETTER J
    .{ 0x004B, 0x6B }, // LATIN CAPITAL LETTER K
    .{ 0x004C, 0x6C }, // LATIN CAPITAL LETTER L
    .{ 0x004D, 0x6D }, // LATIN CAPITAL LETTER M
    .{ 0x004E, 0x6E }, // LATIN CAPITAL LETTER N
    .{ 0x004F, 0x6F }, // LATIN CAPITAL LETTER O
    .{ 0x0050, 0x70 }, // LATIN CAPITAL LETTER P
    .{ 0x0051, 0x71 }, // LATIN CAPITAL LETTER Q
    .{ 0x0052, 0x72 }, // LATIN CAPITAL LETTER R
    .{ 0x0053, 0x73 }, // LATIN CAPITAL LETTER S
    .{ 0x0054, 0x74 }, // LATIN CAPITAL LETTER T
    .{ 0x0055, 0x75 }, // LATIN CAPITAL LETTER U
    .{ 0x0056, 0x76 }, // LATIN CAPITAL LETTER V
    .{ 0x0057, 0x77 }, // LATIN CAPITAL LETTER W
    .{ 0x0058, 0x78 }, // LATIN CAPITAL LETTER X
    .{ 0x0059, 0x79 }, // LATIN CAPITAL LETTER Y
    .{ 0x005A, 0x7A }, // LATIN CAPITAL LETTER Z
    .{ 0x253C, 0x7B }, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
    .{ 0x1FB8C, 0x7C }, // LEFT HALF MEDIUM SHADE
    .{ 0x2502, 0x7D }, // BOX DRAWINGS LIGHT VERTICAL
    .{ 0x1FB96, 0x7E }, // INVERSE CHECKER BOARD FILL
    .{ 0x1FB98, 0x7F }, // UPPER LEFT TO LOWER RIGHT FILL
    .{ 0x00A0, 0xA0 }, // NO-BREAK SPACE
    .{ 0x258C, 0xA1 }, // LEFT HALF BLOCK
    .{ 0x2584, 0xA2 }, // LOWER HALF BLOCK
    .{ 0x2594, 0xA3 }, // UPPER ONE EIGHTH BLOCK
    .{ 0x2581, 0xA4 }, // LOWER ONE EIGHTH BLOCK
    .{ 0x258F, 0xA5 }, // LEFT ONE EIGHTH BLOCK
    .{ 0x2592, 0xA6 }, // MEDIUM SHADE
    .{ 0x2595, 0xA7 }, // RIGHT ONE EIGHTH BLOCK
    .{ 0x1FB8F, 0xA8 }, // LOWER HALF MEDIUM SHADE
    .{ 0x1FB99, 0xA9 }, // UPPER RIGHT TO LOWER LEFT FILL
    .{ 0x1FB87, 0xAA }, // RIGHT ONE QUARTER BLOCK
    .{ 0x251C, 0xAB }, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
    .{ 0x2597, 0xAC }, // QUADRANT LOWER RIGHT
    .{ 0x2514, 0xAD }, // BOX DRAWINGS LIGHT UP AND RIGHT
    .{ 0x2510, 0xAE }, // BOX DRAWINGS LIGHT DOWN AND LEFT
    .{ 0x2582, 0xAF }, // LOWER ONE QUARTER BLOCK
    .{ 0x250C, 0xB0 }, // BOX DRAWINGS LIGHT DOWN AND RIGHT
    .{ 0x2534, 0xB1 }, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
    .{ 0x252C, 0xB2 }, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
    .{ 0x2524, 0xB3 }, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
    .{ 0x258E, 0xB4 }, // LEFT ONE QUARTER BLOCK
    .{ 0x258D, 0xB5 }, // LEFT THREE EIGHTHS BLOCK
    .{ 0x1FB88, 0xB6 }, // RIGHT THREE EIGHTHS BLOCK
    .{ 0x1FB82, 0xB7 }, // UPPER ONE QUARTER BLOCK
    .{ 0x1FB83, 0xB8 }, // UPPER THREE EIGHTHS BLOCK
    .{ 0x2583, 0xB9 }, // LOWER THREE EIGHTHS BLOCK
    .{ 0x2713, 0xBA }, // CHECK MARK
    .{ 0x2596, 0xBB }, // QUADRANT LOWER LEFT
    .{ 0x259D, 0xBC }, // QUADRANT UPPER RIGHT
    .{ 0x2518, 0xBD }, // BOX DRAWINGS LIGHT UP AND LEFT
    .{ 0x2598, 0xBE }, // QUADRANT UPPER LEFT
    .{ 0x259A, 0xBF }, // QUADRANT UPPER LEFT AND LOWER RIGHT
};

// Name: Map from Commodore 64/128 (video) primary character set to Unicode
// Date: 2018 April 20
// Author: Rebecca Bettencourt <support@kreativekorp.com>
const unshifted_video_table = [_]Entry{
    .{ 0x0040, 0x00 }, // COMMERCIAL AT
    .{ 0x0041, 0x01 }, // LATIN CAPITAL LETTER A
    .{ 0x0042, 0x02 }, // LATIN CAPITAL LETTER B
    .{ 0x0043, 0x03 }, // LATIN CAPITAL LETTER C
    .{ 0x0044, 0x04 }, // LATIN CAPITAL LETTER D
    .{ 0x0045, 0x05 }, // LATIN CAPITAL LETTER E
    .{ 0x0046, 0x06 }, // LATIN CAPITAL LETTER F
    .{ 0x0047, 0x07 }, // LATIN CAPITAL LETTER G
    .{ 0x0048, 0x08 }, // LATIN CAPITAL LETTER H
    .{ 0x0049, 0x09 }, // LATIN CAPITAL LETTER I
    .{ 0x004A, 0x0A }, // LATIN CAPITAL LETTER J
    .{ 0x004B, 0x0B }, // LATIN CAPITAL LETTER K
    .{ 0x004C, 0x0C }, // LATIN CAPITAL LETTER L
    .{ 0x004D, 0x0D }, // LATIN CAPITAL LETTER M
    .{ 0x004E, 0x0E }, // LATIN CAPITAL LETTER N
    .{ 0x004F, 0x0F }, // LATIN CAPITAL LETTER O
    .{ 0x0050, 0x10 }, // LATIN CAPITAL LETTER P
    .{ 0x0051, 0x11 }, // LATIN CAPITAL LETTER Q
    .{ 0x0052, 0x12 }, // LATIN CAPITAL LETTER R
    .{ 0x0053, 0x13 }, // LATIN CAPITAL LETTER S
    .{ 0x0054, 0x14 }, // LATIN CAPITAL LETTER T
    .{ 0x0055, 0x15 }, // LATIN CAPITAL LETTER U
    .{ 0x0056, 0x16 }, // LATIN CAPITAL LETTER V
    .{ 0x0057, 0x17 }, // LATIN CAPITAL LETTER W
    .{ 0x0058, 0x18 }, // LATIN CAPITAL LETTER X
    .{ 0x0059, 0x19 }, // LATIN CAPITAL LETTER Y
    .{ 0x005A, 0x1A }, // LATIN CAPITAL LETTER Z
    .{ 0x005B, 0x1B }, // LEFT SQUARE BRACKET
    .{ 0x00A3, 0x1C }, // POUND SIGN
    .{ 0x005D, 0x1D }, // RIGHT SQUARE BRACKET
    .{ 0x2191, 0x1E }, // UPWARDS ARROW
    .{ 0x2190, 0x1F }, // LEFTWARDS ARROW
    .{ 0x0020, 0x20 }, // SPACE
    .{ 0x0021, 0x21 }, // EXCLAMATION MARK
    .{ 0x0022, 0x22 }, // QUOTATION MARK
    .{ 0x0023, 0x23 }, // NUMBER SIGN
    .{ 0x0024, 0x24 }, // DOLLAR SIGN
    .{ 0x0025, 0x25 }, // PERCENT SIGN
    .{ 0x0026, 0x26 }, // AMPERSAND
    .{ 0x0027, 0x27 }, // APOSTROPHE
    .{ 0x0028, 0x28 }, // LEFT PARENTHESIS
    .{ 0x0029, 0x29 }, // RIGHT PARENTHESIS
    .{ 0x002A, 0x2A }, // ASTERISK
    .{ 0x002B, 0x2B }, // PLUS SIGN
    .{ 0x002C, 0x2C }, // COMMA
    .{ 0x002D, 0x2D }, // HYPHEN-MINUS
    .{ 0x002E, 0x2E }, // FULL STOP
    .{ 0x002F, 0x2F }, // SOLIDUS
    .{ 0x0030, 0x30 }, // DIGIT ZERO
    .{ 0x0031, 0x31 }, // DIGIT ONE
    .{ 0x0032, 0x32 }, // DIGIT TWO
    .{ 0x0033, 0x33 }, // DIGIT THREE
    .{ 0x0034, 0x34 }, // DIGIT FOUR
    .{ 0x0035, 0x35 }, // DIGIT FIVE
    .{ 0x0036, 0x36 }, // DIGIT SIX
    .{ 0x0037, 0x37 }, // DIGIT SEVEN
    .{ 0x0038, 0x38 }, // DIGIT EIGHT
    .{ 0x0039, 0x39 }, // DIGIT NINE
    .{ 0x003A, 0x3A }, // COLON
    .{ 0x003B, 0x3B }, // SEMICOLON
    .{ 0x003C, 0x3C }, // LESS-THAN SIGN
    .{ 0x003D, 0x3D }, // EQUALS SIGN
    .{ 0x003E, 0x3E }, // GREATER-THAN SIGN
    .{ 0x003F, 0x3F }, // QUESTION MARK
    .{ 0x2500, 0x40 }, // BOX DRAWINGS LIGHT HORIZONTAL
    .{ 0x2660, 0x41 }, // BLACK SPADE SUIT
    .{ 0x1FB72, 0x42 }, // VERTICAL ONE EIGHTH BLOCK-4
    .{ 0x1FB78, 0x43 }, // HORIZONTAL ONE EIGHTH BLOCK-4
    .{ 0x1FB77, 0x44 }, // HORIZONTAL ONE EIGHTH BLOCK-3
    .{ 0x1FB76, 0x45 }, // HORIZONTAL ONE EIGHTH BLOCK-2
    .{ 0x1FB7A, 0x46 }, // HORIZONTAL ONE EIGHTH BLOCK-6
    .{ 0x1FB71, 0x47 }, // VERTICAL ONE EIGHTH BLOCK-3
    .{ 0x1FB74, 0x48 }, // VERTICAL ONE EIGHTH BLOCK-6
    .{ 0x256E, 0x49 }, // BOX DRAWINGS LIGHT ARC DOWN AND LEFT
    .{ 0x2570, 0x4A }, // BOX DRAWINGS LIGHT ARC UP AND RIGHT
    .{ 0x256F, 0x4B }, // BOX DRAWINGS LIGHT ARC UP AND LEFT
    .{ 0x1FB7C, 0x4C }, // LEFT AND LOWER ONE EIGHTH BLOCK
    .{ 0x2572, 0x4D }, // BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
    .{ 0x2571, 0x4E }, // BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
    .{ 0x1FB7D, 0x4F }, // LEFT AND UPPER ONE EIGHTH BLOCK
    .{ 0x1FB7E, 0x50 }, // RIGHT AND UPPER ONE EIGHTH BLOCK
    .{ 0x2022, 0x51 }, // BULLET
    .{ 0x25CF, 0x51 }, // BLACK CIRCLE
    .{ 0x1FB7B, 0x52 }, // HORIZONTAL ONE EIGHTH BLOCK-7
    .{ 0x2665, 0x53 }, // BLACK HEART SUIT
    .{ 0x1FB70, 0x54 }, // VERTICAL ONE EIGHTH BLOCK-2
    .{ 0x256D, 0x55 }, // BOX DRAWINGS LIGHT ARC DOWN AND RIGHT
    .{ 0x2573, 0x56 }, // BOX DRAWINGS LIGHT DIAGONAL CROSS
    .{ 0x25CB, 0x57 }, // WHITE CIRCLE
    .{ 0x25E6, 0x57 }, // WHITE BULLET
    .{ 0x2663, 0x58 }, // BLACK CLUB SUIT
    .{ 0x1FB75, 0x59 }, // VERTICAL ONE EIGHTH BLOCK-7
    .{ 0x2666, 0x5A }, // BLACK DIAMOND SUIT
    .{ 0x253C, 0x5B }, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
    .{ 0x1FB8C, 0x5C }, // LEFT HALF MEDIUM SHADE
    .{ 0x2502, 0x5D }, // BOX DRAWINGS LIGHT VERTICAL
    .{ 0x03C0, 0x5E }, // GREEK SMALL LETTER PI
    .{ 0x25E5, 0x5F }, // BLACK UPPER RIGHT TRIANGLE
    .{ 0x00A0, 0x60 }, // NO-BREAK SPACE
    .{ 0x258C, 0x61 }, // LEFT HALF BLOCK
    .{ 0x2584, 0x62 }, // LOWER HALF BLOCK
    .{ 0x2594, 0x63 }, // UPPER ONE EIGHTH BLOCK
    .{ 0x2581, 0x64 }, // LOWER ONE EIGHTH BLOCK
    .{ 0x258F, 0x65 }, // LEFT ONE EIGHTH BLOCK
    .{ 0x2592, 0x66 }, // MEDIUM SHADE
    .{ 0x2595, 0x67 }, // RIGHT ONE EIGHTH BLOCK
    .{ 0x1FB8F, 0x68 }, // LOWER HALF MEDIUM SHADE
    .{ 0x25E4, 0x69 }, // BLACK UPPER LEFT TRIANGLE
    .{ 0x1FB87, 0x6A }, // RIGHT ONE QUARTER BLOCK
    .{ 0x251C, 0x6B }, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
    .{ 0x2597, 0x6C }, // QUADRANT LOWER RIGHT
    .{ 0x2514, 0x6D }, // BOX DRAWINGS LIGHT UP AND RIGHT
    .{ 0x2510, 0x6E }, // BOX DRAWINGS LIGHT DOWN AND LEFT
    .{ 0x2582, 0x6F }, // LOWER ONE QUARTER BLOCK
    .{ 0x250C, 0x70 }, // BOX DRAWINGS LIGHT DOWN AND RIGHT
    .{ 0x2534, 0x71 }, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
    .{ 0x252C, 0x72 }, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
    .{ 0x2524, 0x73 }, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
    .{ 0x258E, 0x74 }, // LEFT ONE QUARTER BLOCK
    .{ 0x258D, 0x75 }, // LEFT THREE EIGHTHS BLOCK
    .{ 0x1FB88, 0x76 }, // RIGHT THREE EIGHTHS BLOCK
    .{ 0x1FB82, 0x77 }, // UPPER ONE QUARTER BLOCK
    .{ 0x1FB83, 0x78 }, // UPPER THREE EIGHTHS BLOCK
    .{ 0x2583, 0x79 }, // LOWER THREE EIGHTHS BLOCK
    .{ 0x1FB7F, 0x7A }, // RIGHT AND LOWER ONE EIGHTH BLOCK
    .{ 0x2596, 0x7B }, // QUADRANT LOWER LEFT
    .{ 0x259D, 0x7C }, // QUADRANT UPPER RIGHT
    .{ 0x2518, 0x7D }, // BOX DRAWINGS LIGHT UP AND LEFT
    .{ 0x2598, 0x7E }, // QUADRANT UPPER LEFT
    .{ 0x259A, 0x7F }, // QUADRANT UPPER LEFT AND LOWER RIGHT
    .{ 0x25D8, 0xD1 }, // INVERSE BULLET
    .{ 0x25D9, 0xD7 }, // INVERSE WHITE CIRCLE
    .{ 0x1FB94, 0xDC }, // LEFT HALF INVERSE MEDIUM SHADE AND RIGHT HALF BLOCK
    .{ 0x25E3, 0xDF }, // BLACK LOWER LEFT TRIANGLE
    .{ 0x2588, 0xE0 }, // FULL BLOCK
    .{ 0x2590, 0xE1 }, // RIGHT HALF BLOCK
    .{ 0x2580, 0xE2 }, // UPPER HALF BLOCK
    .{ 0x2587, 0xE3 }, // LOWER SEVEN EIGHTHS BLOCK
    .{ 0x1FB86, 0xE4 }, // UPPER SEVEN EIGHTHS BLOCK
    .{ 0x1FB8B, 0xE5 }, // RIGHT SEVEN EIGHTHS BLOCK
    .{ 0x1FB90, 0xE6 }, // INVERSE MEDIUM SHADE
    .{ 0x2589, 0xE7 }, // LEFT SEVEN EIGHTHS BLOCK
    .{ 0x1FB91, 0xE8 }, // UPPER HALF BLOCK AND LOWER HALF INVERSE MEDIUM SHADE
    .{ 0x25E2, 0xE9 }, // BLACK LOWER RIGHT TRIANGLE
    .{ 0x258A, 0xEA }, // LEFT THREE QUARTERS BLOCK
    .{ 0x259B, 0xEC }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
    .{ 0x1FB85, 0xEF }, // UPPER THREE QUARTERS BLOCK
    .{ 0x1FB8A, 0xF4 }, // RIGHT THREE QUARTERS BLOCK
    .{ 0x1FB89, 0xF5 }, // RIGHT FIVE EIGHTHS BLOCK
    .{ 0x258B, 0xF6 }, // LEFT FIVE EIGHTHS BLOCK
    .{ 0x2586, 0xF7 }, // LOWER THREE QUARTERS BLOCK
    .{ 0x2585, 0xF8 }, // LOWER FIVE EIGHTHS BLOCK
    .{ 0x1FB84, 0xF9 }, // UPPER FIVE EIGHTHS BLOCK
    .{ 0x259C, 0xFB }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
    .{ 0x2599, 0xFC }, // QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259F, 0xFE }, // QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259E, 0xFF }, // QUADRANT UPPER RIGHT AND LOWER LEFT
};

// Name: Map from Commodore 64/128 (video) primary character set to Unicode
// Date: 2018 April 20
// Author: Rebecca Bettencourt <support@kreativekorp.com>
const unshifted_reverse_video_table = [_]Entry{
    .{ 0x25D8, 0x51 }, // INVERSE BULLET
    .{ 0x25D9, 0x57 }, // INVERSE WHITE CIRCLE
    .{ 0x1FB94, 0x5C }, // LEFT HALF INVERSE MEDIUM SHADE AND RIGHT HALF BLOCK
    .{ 0x25E3, 0x5F }, // BLACK LOWER LEFT TRIANGLE
    .{ 0x2588, 0x60 }, // FULL BLOCK
    .{ 0x2590, 0x61 }, // RIGHT HALF BLOCK
    .{ 0x2580, 0x62 }, // UPPER HALF BLOCK
    .{ 0x2587, 0x63 }, // LOWER SEVEN EIGHTHS BLOCK
    .{ 0x1FB86, 0x64 }, // UPPER SEVEN EIGHTHS BLOCK
    .{ 0x1FB8B, 0x65 }, // RIGHT SEVEN EIGHTHS BLOCK
    .{ 0x1FB90, 0x66 }, // INVERSE MEDIUM SHADE
    .{ 0x2589, 0x67 }, // LEFT SEVEN EIGHTHS BLOCK
    .{ 0x1FB91, 0x68 }, // UPPER HALF BLOCK AND LOWER HALF INVERSE MEDIUM SHADE
    .{ 0x25E2, 0x69 }, // BLACK LOWER RIGHT TRIANGLE
    .{ 0x258A, 0x6A }, // LEFT THREE QUARTERS BLOCK
    .{ 0x259B, 0x6C }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
    .{ 0x1FB85, 0x6F }, // UPPER THREE QUARTERS BLOCK
    .{ 0x1FB8A, 0x74 }, // RIGHT THREE QUARTERS BLOCK
    .{ 0x1FB89, 0x75 }, // RIGHT FIVE EIGHTHS BLOCK
    .{ 0x258B, 0x76 }, // LEFT FIVE EIGHTHS BLOCK
    .{ 0x2586, 0x77 }, // LOWER THREE QUARTERS BLOCK
    .{ 0x2585, 0x78 }, // LOWER FIVE EIGHTHS BLOCK
    .{ 0x1FB84, 0x79 }, // UPPER FIVE EIGHTHS BLOCK
    .{ 0x259C, 0x7B }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
    .{ 0x2599, 0x7C }, // QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259F, 0x7E }, // QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259E, 0x7F }, // QUADRANT UPPER RIGHT AND LOWER LEFT
    .{ 0x0040, 0x80 }, // COMMERCIAL AT
    .{ 0x0041, 0x81 }, // LATIN CAPITAL LETTER A
    .{ 0x0042, 0x82 }, // LATIN CAPITAL LETTER B
    .{ 0x0043, 0x83 }, // LATIN CAPITAL LETTER C
    .{ 0x0044, 0x84 }, // LATIN CAPITAL LETTER D
    .{ 0x0045, 0x85 }, // LATIN CAPITAL LETTER E
    .{ 0x0046, 0x86 }, // LATIN CAPITAL LETTER F
    .{ 0x0047, 0x87 }, // LATIN CAPITAL LETTER G
    .{ 0x0048, 0x88 }, // LATIN CAPITAL LETTER H
    .{ 0x0049, 0x89 }, // LATIN CAPITAL LETTER I
    .{ 0x004A, 0x8A }, // LATIN CAPITAL LETTER J
    .{ 0x004B, 0x8B }, // LATIN CAPITAL LETTER K
    .{ 0x004C, 0x8C }, // LATIN CAPITAL LETTER L
    .{ 0x004D, 0x8D }, // LATIN CAPITAL LETTER M
    .{ 0x004E, 0x8E }, // LATIN CAPITAL LETTER N
    .{ 0x004F, 0x8F }, // LATIN CAPITAL LETTER O
    .{ 0x0050, 0x90 }, // LATIN CAPITAL LETTER P
    .{ 0x0051, 0x91 }, // LATIN CAPITAL LETTER Q
    .{ 0x0052, 0x92 }, // LATIN CAPITAL LETTER R
    .{ 0x0053, 0x93 }, // LATIN CAPITAL LETTER S
    .{ 0x0054, 0x94 }, // LATIN CAPITAL LETTER T
    .{ 0x0055, 0x95 }, // LATIN CAPITAL LETTER U
    .{ 0x0056, 0x96 }, // LATIN CAPITAL LETTER V
    .{ 0x0057, 0x97 }, // LATIN CAPITAL LETTER W
    .{ 0x0058, 0x98 }, // LATIN CAPITAL LETTER X
    .{ 0x0059, 0x99 }, // LATIN CAPITAL LETTER Y
    .{ 0x005A, 0x9A }, // LATIN CAPITAL LETTER Z
    .{ 0x005B, 0x9B }, // LEFT SQUARE BRACKET
    .{ 0x00A3, 0x9C }, // POUND SIGN
    .{ 0x005D, 0x9D }, // RIGHT SQUARE BRACKET
    .{ 0x2191, 0x9E }, // UPWARDS ARROW
    .{ 0x2190, 0x9F }, // LEFTWARDS ARROW
    .{ 0x0020, 0xA0 }, // SPACE
    .{ 0x0021, 0xA1 }, // EXCLAMATION MARK
    .{ 0x0022, 0xA2 }, // QUOTATION MARK
    .{ 0x0023, 0xA3 }, // NUMBER SIGN
    .{ 0x0024, 0xA4 }, // DOLLAR SIGN
    .{ 0x0025, 0xA5 }, // PERCENT SIGN
    .{ 0x0026, 0xA6 }, // AMPERSAND
    .{ 0x0027, 0xA7 }, // APOSTROPHE
    .{ 0x0028, 0xA8 }, // LEFT PARENTHESIS
    .{ 0x0029, 0xA9 }, // RIGHT PARENTHESIS
    .{ 0x002A, 0xAA }, // ASTERISK
    .{ 0x002B, 0xAB }, // PLUS SIGN
    .{ 0x002C, 0xAC }, // COMMA
    .{ 0x002D, 0xAD }, // HYPHEN-MINUS
    .{ 0x002E, 0xAE }, // FULL STOP
    .{ 0x002F, 0xAF }, // SOLIDUS
    .{ 0x0030, 0xB0 }, // DIGIT ZERO
    .{ 0x0031, 0xB1 }, // DIGIT ONE
    .{ 0x0032, 0xB2 }, // DIGIT TWO
    .{ 0x0033, 0xB3 }, // DIGIT THREE
    .{ 0x0034, 0xB4 }, // DIGIT FOUR
    .{ 0x0035, 0xB5 }, // DIGIT FIVE
    .{ 0x0036, 0xB6 }, // DIGIT SIX
    .{ 0x0037, 0xB7 }, // DIGIT SEVEN
    .{ 0x0038, 0xB8 }, // DIGIT EIGHT
    .{ 0x0039, 0xB9 }, // DIGIT NINE
    .{ 0x003A, 0xBA }, // COLON
    .{ 0x003B, 0xBB }, // SEMICOLON
    .{ 0x003C, 0xBC }, // LESS-THAN SIGN
    .{ 0x003D, 0xBD }, // EQUALS SIGN
    .{ 0x003E, 0xBE }, // GREATER-THAN SIGN
    .{ 0x003F, 0xBF }, // QUESTION MARK
    .{ 0x2500, 0xC0 }, // BOX DRAWINGS LIGHT HORIZONTAL
    .{ 0x2660, 0xC1 }, // BLACK SPADE SUIT
    .{ 0x1FB72, 0xC2 }, // VERTICAL ONE EIGHTH BLOCK-4
    .{ 0x1FB78, 0xC3 }, // HORIZONTAL ONE EIGHTH BLOCK-4
    .{ 0x1FB77, 0xC4 }, // HORIZONTAL ONE EIGHTH BLOCK-3
    .{ 0x1FB76, 0xC5 }, // HORIZONTAL ONE EIGHTH BLOCK-2
    .{ 0x1FB7A, 0xC6 }, // HORIZONTAL ONE EIGHTH BLOCK-6
    .{ 0x1FB71, 0xC7 }, // VERTICAL ONE EIGHTH BLOCK-3
    .{ 0x1FB74, 0xC8 }, // VERTICAL ONE EIGHTH BLOCK-6
    .{ 0x256E, 0xC9 }, // BOX DRAWINGS LIGHT ARC DOWN AND LEFT
    .{ 0x2570, 0xCA }, // BOX DRAWINGS LIGHT ARC UP AND RIGHT
    .{ 0x256F, 0xCB }, // BOX DRAWINGS LIGHT ARC UP AND LEFT
    .{ 0x1FB7C, 0xCC }, // LEFT AND LOWER ONE EIGHTH BLOCK
    .{ 0x2572, 0xCD }, // BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
    .{ 0x2571, 0xCE }, // BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
    .{ 0x1FB7D, 0xCF }, // LEFT AND UPPER ONE EIGHTH BLOCK
    .{ 0x1FB7E, 0xD0 }, // RIGHT AND UPPER ONE EIGHTH BLOCK
    .{ 0x2022, 0xD1 }, // BULLET
    .{ 0x25CF, 0xD1 }, // BLACK CIRCLE
    .{ 0x1FB7B, 0xD2 }, // HORIZONTAL ONE EIGHTH BLOCK-7
    .{ 0x2665, 0xD3 }, // BLACK HEART SUIT
    .{ 0x1FB70, 0xD4 }, // VERTICAL ONE EIGHTH BLOCK-2
    .{ 0x256D, 0xD5 }, // BOX DRAWINGS LIGHT ARC DOWN AND RIGHT
    .{ 0x2573, 0xD6 }, // BOX DRAWINGS LIGHT DIAGONAL CROSS
    .{ 0x25CB, 0xD7 }, // WHITE CIRCLE
    .{ 0x25E6, 0xD7 }, // WHITE BULLET
    .{ 0x2663, 0xD8 }, // BLACK CLUB SUIT
    .{ 0x1FB75, 0xD9 }, // VERTICAL ONE EIGHTH BLOCK-7
    .{ 0x2666, 0xDA }, // BLACK DIAMOND SUIT
    .{ 0x253C, 0xDB }, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
    .{ 0x1FB8C, 0xDC }, // LEFT HALF MEDIUM SHADE
    .{ 0x2502, 0xDD }, // BOX DRAWINGS LIGHT VERTICAL
    .{ 0x03C0, 0xDE }, // GREEK SMALL LETTER PI
    .{ 0x25E5, 0xDF }, // BLACK UPPER RIGHT TRIANGLE
    .{ 0x00A0, 0xE0 }, // NO-BREAK SPACE
    .{ 0x258C, 0xE1 }, // LEFT HALF BLOCK
    .{ 0x2584, 0xE2 }, // LOWER HALF BLOCK
    .{ 0x2594, 0xE3 }, // UPPER ONE EIGHTH BLOCK
    .{ 0x2581, 0xE4 }, // LOWER ONE EIGHTH BLOCK
    .{ 0x258F, 0xE5 }, // LEFT ONE EIGHTH BLOCK
    .{ 0x2592, 0xE6 }, // MEDIUM SHADE
    .{ 0x2595, 0xE7 }, // RIGHT ONE EIGHTH BLOCK
    .{ 0x1FB8F, 0xE8 }, // LOWER HALF MEDIUM SHADE
    .{ 0x25E4, 0xE9 }, // BLACK UPPER LEFT TRIANGLE
    .{ 0x1FB87, 0xEA }, // RIGHT ONE QUARTER BLOCK
    .{ 0x251C, 0xEB }, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
    .{ 0x2597, 0xEC }, // QUADRANT LOWER RIGHT
    .{ 0x2514, 0xED }, // BOX DRAWINGS LIGHT UP AND RIGHT
    .{ 0x2510, 0xEE }, // BOX DRAWINGS LIGHT DOWN AND LEFT
    .{ 0x2582, 0xEF }, // LOWER ONE QUARTER BLOCK
    .{ 0x250C, 0xF0 }, // BOX DRAWINGS LIGHT DOWN AND RIGHT
    .{ 0x2534, 0xF1 }, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
    .{ 0x252C, 0xF2 }, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
    .{ 0x2524, 0xF3 }, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
    .{ 0x258E, 0xF4 }, // LEFT ONE QUARTER BLOCK
    .{ 0x258D, 0xF5 }, // LEFT THREE EIGHTHS BLOCK
    .{ 0x1FB88, 0xF6 }, // RIGHT THREE EIGHTHS BLOCK
    .{ 0x1FB82, 0xF7 }, // UPPER ONE QUARTER BLOCK
    .{ 0x1FB83, 0xF8 }, // UPPER THREE EIGHTHS BLOCK
    .{ 0x2583, 0xF9 }, // LOWER THREE EIGHTHS BLOCK
    .{ 0x1FB7F, 0xFA }, // RIGHT AND LOWER ONE EIGHTH BLOCK
    .{ 0x2596, 0xFB }, // QUADRANT LOWER LEFT
    .{ 0x259D, 0xFC }, // QUADRANT UPPER RIGHT
    .{ 0x2518, 0xFD }, // BOX DRAWINGS LIGHT UP AND LEFT
    .{ 0x2598, 0xFE }, // QUADRANT UPPER LEFT
    .{ 0x259A, 0xFF }, // QUADRANT UPPER LEFT AND LOWER RIGHT
};

// Name: Map from Commodore 64/128 (video) alternate character set to Unicode
// Date: 2018 October 11
// Author: Rebecca Bettencourt <support@kreativekorp.com>
const shifted_video_table = [_]Entry{
    .{ 0x0040, 0x00 }, // COMMERCIAL AT
    .{ 0x0061, 0x01 }, // LATIN SMALL LETTER A
    .{ 0x0062, 0x02 }, // LATIN SMALL LETTER B
    .{ 0x0063, 0x03 }, // LATIN SMALL LETTER C
    .{ 0x0064, 0x04 }, // LATIN SMALL LETTER D
    .{ 0x0065, 0x05 }, // LATIN SMALL LETTER E
    .{ 0x0066, 0x06 }, // LATIN SMALL LETTER F
    .{ 0x0067, 0x07 }, // LATIN SMALL LETTER G
    .{ 0x0068, 0x08 }, // LATIN SMALL LETTER H
    .{ 0x0069, 0x09 }, // LATIN SMALL LETTER I
    .{ 0x006A, 0x0A }, // LATIN SMALL LETTER J
    .{ 0x006B, 0x0B }, // LATIN SMALL LETTER K
    .{ 0x006C, 0x0C }, // LATIN SMALL LETTER L
    .{ 0x006D, 0x0D }, // LATIN SMALL LETTER M
    .{ 0x006E, 0x0E }, // LATIN SMALL LETTER N
    .{ 0x006F, 0x0F }, // LATIN SMALL LETTER O
    .{ 0x0070, 0x10 }, // LATIN SMALL LETTER P
    .{ 0x0071, 0x11 }, // LATIN SMALL LETTER Q
    .{ 0x0072, 0x12 }, // LATIN SMALL LETTER R
    .{ 0x0073, 0x13 }, // LATIN SMALL LETTER S
    .{ 0x0074, 0x14 }, // LATIN SMALL LETTER T
    .{ 0x0075, 0x15 }, // LATIN SMALL LETTER U
    .{ 0x0076, 0x16 }, // LATIN SMALL LETTER V
    .{ 0x0077, 0x17 }, // LATIN SMALL LETTER W
    .{ 0x0078, 0x18 }, // LATIN SMALL LETTER X
    .{ 0x0079, 0x19 }, // LATIN SMALL LETTER Y
    .{ 0x007A, 0x1A }, // LATIN SMALL LETTER Z
    .{ 0x005B, 0x1B }, // LEFT SQUARE BRACKET
    .{ 0x00A3, 0x1C }, // POUND SIGN
    .{ 0x005D, 0x1D }, // RIGHT SQUARE BRACKET
    .{ 0x2191, 0x1E }, // UPWARDS ARROW
    .{ 0x2190, 0x1F }, // LEFTWARDS ARROW
    .{ 0x0020, 0x20 }, // SPACE
    .{ 0x0021, 0x21 }, // EXCLAMATION MARK
    .{ 0x0022, 0x22 }, // QUOTATION MARK
    .{ 0x0023, 0x23 }, // NUMBER SIGN
    .{ 0x0024, 0x24 }, // DOLLAR SIGN
    .{ 0x0025, 0x25 }, // PERCENT SIGN
    .{ 0x0026, 0x26 }, // AMPERSAND
    .{ 0x0027, 0x27 }, // APOSTROPHE
    .{ 0x0028, 0x28 }, // LEFT PARENTHESIS
    .{ 0x0029, 0x29 }, // RIGHT PARENTHESIS
    .{ 0x002A, 0x2A }, // ASTERISK
    .{ 0x002B, 0x2B }, // PLUS SIGN
    .{ 0x002C, 0x2C }, // COMMA
    .{ 0x002D, 0x2D }, // HYPHEN-MINUS
    .{ 0x002E, 0x2E }, // FULL STOP
    .{ 0x002F, 0x2F }, // SOLIDUS
    .{ 0x0030, 0x30 }, // DIGIT ZERO
    .{ 0x0031, 0x31 }, // DIGIT ONE
    .{ 0x0032, 0x32 }, // DIGIT TWO
    .{ 0x0033, 0x33 }, // DIGIT THREE
    .{ 0x0034, 0x34 }, // DIGIT FOUR
    .{ 0x0035, 0x35 }, // DIGIT FIVE
    .{ 0x0036, 0x36 }, // DIGIT SIX
    .{ 0x0037, 0x37 }, // DIGIT SEVEN
    .{ 0x0038, 0x38 }, // DIGIT EIGHT
    .{ 0x0039, 0x39 }, // DIGIT NINE
    .{ 0x003A, 0x3A }, // COLON
    .{ 0x003B, 0x3B }, // SEMICOLON
    .{ 0x003C, 0x3C }, // LESS-THAN SIGN
    .{ 0x003D, 0x3D }, // EQUALS SIGN
    .{ 0x003E, 0x3E }, // GREATER-THAN SIGN
    .{ 0x003F, 0x3F }, // QUESTION MARK
    .{ 0x2500, 0x40 }, // BOX DRAWINGS LIGHT HORIZONTAL
    .{ 0x0041, 0x41 }, // LATIN CAPITAL LETTER A
    .{ 0x0042, 0x42 }, // LATIN CAPITAL LETTER B
    .{ 0x0043, 0x43 }, // LATIN CAPITAL LETTER C
    .{ 0x0044, 0x44 }, // LATIN CAPITAL LETTER D
    .{ 0x0045, 0x45 }, // LATIN CAPITAL LETTER E
    .{ 0x0046, 0x46 }, // LATIN CAPITAL LETTER F
    .{ 0x0047, 0x47 }, // LATIN CAPITAL LETTER G
    .{ 0x0048, 0x48 }, // LATIN CAPITAL LETTER H
    .{ 0x0049, 0x49 }, // LATIN CAPITAL LETTER I
    .{ 0x004A, 0x4A }, // LATIN CAPITAL LETTER J
    .{ 0x004B, 0x4B }, // LATIN CAPITAL LETTER K
    .{ 0x004C, 0x4C }, // LATIN CAPITAL LETTER L
    .{ 0x004D, 0x4D }, // LATIN CAPITAL LETTER M
    .{ 0x004E, 0x4E }, // LATIN CAPITAL LETTER N
    .{ 0x004F, 0x4F }, // LATIN CAPITAL LETTER O
    .{ 0x0050, 0x50 }, // LATIN CAPITAL LETTER P
    .{ 0x0051, 0x51 }, // LATIN CAPITAL LETTER Q
    .{ 0x0052, 0x52 }, // LATIN CAPITAL LETTER R
    .{ 0x0053, 0x53 }, // LATIN CAPITAL LETTER S
    .{ 0x0054, 0x54 }, // LATIN CAPITAL LETTER T
    .{ 0x0055, 0x55 }, // LATIN CAPITAL LETTER U
    .{ 0x0056, 0x56 }, // LATIN CAPITAL LETTER V
    .{ 0x0057, 0x57 }, // LATIN CAPITAL LETTER W
    .{ 0x0058, 0x58 }, // LATIN CAPITAL LETTER X
    .{ 0x0059, 0x59 }, // LATIN CAPITAL LETTER Y
    .{ 0x005A, 0x5A }, // LATIN CAPITAL LETTER Z
    .{ 0x253C, 0x5B }, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
    .{ 0x1FB8C, 0x5C }, // LEFT HALF MEDIUM SHADE
    .{ 0x2502, 0x5D }, // BOX DRAWINGS LIGHT VERTICAL
    .{ 0x1FB96, 0x5E }, // INVERSE CHECKER BOARD FILL
    .{ 0x1FB98, 0x5F }, // UPPER LEFT TO LOWER RIGHT FILL
    .{ 0x00A0, 0x60 }, // NO-BREAK SPACE
    .{ 0x258C, 0x61 }, // LEFT HALF BLOCK
    .{ 0x2584, 0x62 }, // LOWER HALF BLOCK
    .{ 0x2594, 0x63 }, // UPPER ONE EIGHTH BLOCK
    .{ 0x2581, 0x64 }, // LOWER ONE EIGHTH BLOCK
    .{ 0x258F, 0x65 }, // LEFT ONE EIGHTH BLOCK
    .{ 0x2592, 0x66 }, // MEDIUM SHADE
    .{ 0x2595, 0x67 }, // RIGHT ONE EIGHTH BLOCK
    .{ 0x1FB8F, 0x68 }, // LOWER HALF MEDIUM SHADE
    .{ 0x1FB99, 0x69 }, // UPPER RIGHT TO LOWER LEFT FILL
    .{ 0x1FB87, 0x6A }, // RIGHT ONE QUARTER BLOCK
    .{ 0x251C, 0x6B }, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
    .{ 0x2597, 0x6C }, // QUADRANT LOWER RIGHT
    .{ 0x2514, 0x6D }, // BOX DRAWINGS LIGHT UP AND RIGHT
    .{ 0x2510, 0x6E }, // BOX DRAWINGS LIGHT DOWN AND LEFT
    .{ 0x2582, 0x6F }, // LOWER ONE QUARTER BLOCK
    .{ 0x250C, 0x70 }, // BOX DRAWINGS LIGHT DOWN AND RIGHT
    .{ 0x2534, 0x71 }, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
    .{ 0x252C, 0x72 }, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
    .{ 0x2524, 0x73 }, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
    .{ 0x258E, 0x74 }, // LEFT ONE QUARTER BLOCK
    .{ 0x258D, 0x75 }, // LEFT THREE EIGHTHS BLOCK
    .{ 0x1FB88, 0x76 }, // RIGHT THREE EIGHTHS BLOCK
    .{ 0x1FB82, 0x77 }, // UPPER ONE QUARTER BLOCK
    .{ 0x1FB83, 0x78 }, // UPPER THREE EIGHTHS BLOCK
    .{ 0x2583, 0x79 }, // LOWER THREE EIGHTHS BLOCK
    .{ 0x2713, 0x7A }, // CHECK MARK
    .{ 0x2596, 0x7B }, // QUADRANT LOWER LEFT
    .{ 0x259D, 0x7C }, // QUADRANT UPPER RIGHT
    .{ 0x2518, 0x7D }, // BOX DRAWINGS LIGHT UP AND LEFT
    .{ 0x2598, 0x7E }, // QUADRANT UPPER LEFT
    .{ 0x259A, 0x7F }, // QUADRANT UPPER LEFT AND LOWER RIGHT
    .{ 0x1FB94, 0xDC }, // LEFT HALF INVERSE MEDIUM SHADE AND RIGHT HALF BLOCK
    .{ 0x1FB95, 0xDE }, // CHECKER BOARD FILL
    .{ 0x2588, 0xE0 }, // FULL BLOCK
    .{ 0x2590, 0xE1 }, // RIGHT HALF BLOCK
    .{ 0x2580, 0xE2 }, // UPPER HALF BLOCK
    .{ 0x2587, 0xE3 }, // LOWER SEVEN EIGHTHS BLOCK
    .{ 0x1FB86, 0xE4 }, // UPPER SEVEN EIGHTHS BLOCK
    .{ 0x1FB8B, 0xE5 }, // RIGHT SEVEN EIGHTHS BLOCK
    .{ 0x1FB90, 0xE6 }, // INVERSE MEDIUM SHADE
    .{ 0x2589, 0xE7 }, // LEFT SEVEN EIGHTHS BLOCK
    .{ 0x1FB91, 0xE8 }, // UPPER HALF BLOCK AND LOWER HALF INVERSE MEDIUM SHADE
    .{ 0x258A, 0xEA }, // LEFT THREE QUARTERS BLOCK
    .{ 0x259B, 0xEC }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
    .{ 0x1FB85, 0xEF }, // UPPER THREE QUARTERS BLOCK
    .{ 0x1FB8A, 0xF4 }, // RIGHT THREE QUARTERS BLOCK
    .{ 0x1FB89, 0xF5 }, // RIGHT FIVE EIGHTHS BLOCK
    .{ 0x258B, 0xF6 }, // LEFT FIVE EIGHTHS BLOCK
    .{ 0x2586, 0xF7 }, // LOWER THREE QUARTERS BLOCK
    .{ 0x2585, 0xF8 }, // LOWER FIVE EIGHTHS BLOCK
    .{ 0x1FB84, 0xF9 }, // UPPER FIVE EIGHTHS BLOCK
    .{ 0x1FBB1, 0xFA }, // INVERSE CHECK MARK
    .{ 0x259C, 0xFB }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
    .{ 0x2599, 0xFC }, // QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259F, 0xFE }, // QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259E, 0xFF }, // QUADRANT UPPER RIGHT AND LOWER LEFT
};

// Name: Map from Commodore 64/128 (video) alternate character set to Unicode
// Date: 2018 October 11
// Author: Rebecca Bettencourt <support@kreativekorp.com>
const shifted_reverse_video_table = [_]Entry{
    .{ 0x1FB94, 0x5C }, // LEFT HALF INVERSE MEDIUM SHADE AND RIGHT HALF BLOCK
    .{ 0x1FB95, 0x5E }, // CHECKER BOARD FILL
    .{ 0x2588, 0x60 }, // FULL BLOCK
    .{ 0x2590, 0x61 }, // RIGHT HALF BLOCK
    .{ 0x2580, 0x62 }, // UPPER HALF BLOCK
    .{ 0x2587, 0x63 }, // LOWER SEVEN EIGHTHS BLOCK
    .{ 0x1FB86, 0x64 }, // UPPER SEVEN EIGHTHS BLOCK
    .{ 0x1FB8B, 0x65 }, // RIGHT SEVEN EIGHTHS BLOCK
    .{ 0x1FB90, 0x66 }, // INVERSE MEDIUM SHADE
    .{ 0x2589, 0x67 }, // LEFT SEVEN EIGHTHS BLOCK
    .{ 0x1FB91, 0x68 }, // UPPER HALF BLOCK AND LOWER HALF INVERSE MEDIUM SHADE
    .{ 0x258A, 0x6A }, // LEFT THREE QUARTERS BLOCK
    .{ 0x259B, 0x6C }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
    .{ 0x1FB85, 0x6F }, // UPPER THREE QUARTERS BLOCK
    .{ 0x1FB8A, 0x74 }, // RIGHT THREE QUARTERS BLOCK
    .{ 0x1FB89, 0x75 }, // RIGHT FIVE EIGHTHS BLOCK
    .{ 0x258B, 0x76 }, // LEFT FIVE EIGHTHS BLOCK
    .{ 0x2586, 0x77 }, // LOWER THREE QUARTERS BLOCK
    .{ 0x2585, 0x78 }, // LOWER FIVE EIGHTHS BLOCK
    .{ 0x1FB84, 0x79 }, // UPPER FIVE EIGHTHS BLOCK
    .{ 0x1FBB1, 0x7A }, // INVERSE CHECK MARK
    .{ 0x259C, 0x7B }, // QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
    .{ 0x2599, 0x7C }, // QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259F, 0x7E }, // QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT
    .{ 0x259E, 0x7F }, // QUADRANT UPPER RIGHT AND LOWER LEFT
    .{ 0x0040, 0x80 }, // COMMERCIAL AT
    .{ 0x0061, 0x81 }, // LATIN SMALL LETTER A
    .{ 0x0062, 0x82 }, // LATIN SMALL LETTER B
    .{ 0x0063, 0x83 }, // LATIN SMALL LETTER C
    .{ 0x0064, 0x84 }, // LATIN SMALL LETTER D
    .{ 0x0065, 0x85 }, // LATIN SMALL LETTER E
    .{ 0x0066, 0x86 }, // LATIN SMALL LETTER F
    .{ 0x0067, 0x87 }, // LATIN SMALL LETTER G
    .{ 0x0068, 0x88 }, // LATIN SMALL LETTER H
    .{ 0x0069, 0x89 }, // LATIN SMALL LETTER I
    .{ 0x006A, 0x8A }, // LATIN SMALL LETTER J
    .{ 0x006B, 0x8B }, // LATIN SMALL LETTER K
    .{ 0x006C, 0x8C }, // LATIN SMALL LETTER L
    .{ 0x006D, 0x8D }, // LATIN SMALL LETTER M
    .{ 0x006E, 0x8E }, // LATIN SMALL LETTER N
    .{ 0x006F, 0x8F }, // LATIN SMALL LETTER O
    .{ 0x0070, 0x90 }, // LATIN SMALL LETTER P
    .{ 0x0071, 0x91 }, // LATIN SMALL LETTER Q
    .{ 0x0072, 0x92 }, // LATIN SMALL LETTER R
    .{ 0x0073, 0x93 }, // LATIN SMALL LETTER S
    .{ 0x0074, 0x94 }, // LATIN SMALL LETTER T
    .{ 0x0075, 0x95 }, // LATIN SMALL LETTER U
    .{ 0x0076, 0x96 }, // LATIN SMALL LETTER V
    .{ 0x0077, 0x97 }, // LATIN SMALL LETTER W
    .{ 0x0078, 0x98 }, // LATIN SMALL LETTER X
    .{ 0x0079, 0x99 }, // LATIN SMALL LETTER Y
    .{ 0x007A, 0x9A }, // LATIN SMALL LETTER Z
    .{ 0x005B, 0x9B }, // LEFT SQUARE BRACKET
    .{ 0x00A3, 0x9C }, // POUND SIGN
    .{ 0x005D, 0x9D }, // RIGHT SQUARE BRACKET
    .{ 0x2191, 0x9E }, // UPWARDS ARROW
    .{ 0x2190, 0x9F }, // LEFTWARDS ARROW
    .{ 0x0020, 0xA0 }, // SPACE
    .{ 0x0021, 0xA1 }, // EXCLAMATION MARK
    .{ 0x0022, 0xA2 }, // QUOTATION MARK
    .{ 0x0023, 0xA3 }, // NUMBER SIGN
    .{ 0x0024, 0xA4 }, // DOLLAR SIGN
    .{ 0x0025, 0xA5 }, // PERCENT SIGN
    .{ 0x0026, 0xA6 }, // AMPERSAND
    .{ 0x0027, 0xA7 }, // APOSTROPHE
    .{ 0x0028, 0xA8 }, // LEFT PARENTHESIS
    .{ 0x0029, 0xA9 }, // RIGHT PARENTHESIS
    .{ 0x002A, 0xAA }, // ASTERISK
    .{ 0x002B, 0xAB }, // PLUS SIGN
    .{ 0x002C, 0xAC }, // COMMA
    .{ 0x002D, 0xAD }, // HYPHEN-MINUS
    .{ 0x002E, 0xAE }, // FULL STOP
    .{ 0x002F, 0xAF }, // SOLIDUS
    .{ 0x0030, 0xB0 }, // DIGIT ZERO
    .{ 0x0031, 0xB1 }, // DIGIT ONE
    .{ 0x0032, 0xB2 }, // DIGIT TWO
    .{ 0x0033, 0xB3 }, // DIGIT THREE
    .{ 0x0034, 0xB4 }, // DIGIT FOUR
    .{ 0x0035, 0xB5 }, // DIGIT FIVE
    .{ 0x0036, 0xB6 }, // DIGIT SIX
    .{ 0x0037, 0xB7 }, // DIGIT SEVEN
    .{ 0x0038, 0xB8 }, // DIGIT EIGHT
    .{ 0x0039, 0xB9 }, // DIGIT NINE
    .{ 0x003A, 0xBA }, // COLON
    .{ 0x003B, 0xBB }, // SEMICOLON
    .{ 0x003C, 0xBC }, // LESS-THAN SIGN
    .{ 0x003D, 0xBD }, // EQUALS SIGN
    .{ 0x003E, 0xBE }, // GREATER-THAN SIGN
    .{ 0x003F, 0xBF }, // QUESTION MARK
    .{ 0x2500, 0xC0 }, // BOX DRAWINGS LIGHT HORIZONTAL
    .{ 0x0041, 0xC1 }, // LATIN CAPITAL LETTER A
    .{ 0x0042, 0xC2 }, // LATIN CAPITAL LETTER B
    .{ 0x0043, 0xC3 }, // LATIN CAPITAL LETTER C
    .{ 0x0044, 0xC4 }, // LATIN CAPITAL LETTER D
    .{ 0x0045, 0xC5 }, // LATIN CAPITAL LETTER E
    .{ 0x0046, 0xC6 }, // LATIN CAPITAL LETTER F
    .{ 0x0047, 0xC7 }, // LATIN CAPITAL LETTER G
    .{ 0x0048, 0xC8 }, // LATIN CAPITAL LETTER H
    .{ 0x0049, 0xC9 }, // LATIN CAPITAL LETTER I
    .{ 0x004A, 0xCA }, // LATIN CAPITAL LETTER J
    .{ 0x004B, 0xCB }, // LATIN CAPITAL LETTER K
    .{ 0x004C, 0xCC }, // LATIN CAPITAL LETTER L
    .{ 0x004D, 0xCD }, // LATIN CAPITAL LETTER M
    .{ 0x004E, 0xCE }, // LATIN CAPITAL LETTER N
    .{ 0x004F, 0xCF }, // LATIN CAPITAL LETTER O
    .{ 0x0050, 0xD0 }, // LATIN CAPITAL LETTER P
    .{ 0x0051, 0xD1 }, // LATIN CAPITAL LETTER Q
    .{ 0x0052, 0xD2 }, // LATIN CAPITAL LETTER R
    .{ 0x0053, 0xD3 }, // LATIN CAPITAL LETTER S
    .{ 0x0054, 0xD4 }, // LATIN CAPITAL LETTER T
    .{ 0x0055, 0xD5 }, // LATIN CAPITAL LETTER U
    .{ 0x0056, 0xD6 }, // LATIN CAPITAL LETTER V
    .{ 0x0057, 0xD7 }, // LATIN CAPITAL LETTER W
    .{ 0x0058, 0xD8 }, // LATIN CAPITAL LETTER X
    .{ 0x0059, 0xD9 }, // LATIN CAPITAL LETTER Y
    .{ 0x005A, 0xDA }, // LATIN CAPITAL LETTER Z
    .{ 0x253C, 0xDB }, // BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL
    .{ 0x1FB8C, 0xDC }, // LEFT HALF MEDIUM SHADE
    .{ 0x2502, 0xDD }, // BOX DRAWINGS LIGHT VERTICAL
    .{ 0x1FB96, 0xDE }, // INVERSE CHECKER BOARD FILL
    .{ 0x1FB98, 0xDF }, // UPPER LEFT TO LOWER RIGHT FILL
    .{ 0x00A0, 0xE0 }, // NO-BREAK SPACE
    .{ 0x258C, 0xE1 }, // LEFT HALF BLOCK
    .{ 0x2584, 0xE2 }, // LOWER HALF BLOCK
    .{ 0x2594, 0xE3 }, // UPPER ONE EIGHTH BLOCK
    .{ 0x2581, 0xE4 }, // LOWER ONE EIGHTH BLOCK
    .{ 0x258F, 0xE5 }, // LEFT ONE EIGHTH BLOCK
    .{ 0x2592, 0xE6 }, // MEDIUM SHADE
    .{ 0x2595, 0xE7 }, // RIGHT ONE EIGHTH BLOCK
    .{ 0x1FB8F, 0xE8 }, // LOWER HALF MEDIUM SHADE
    .{ 0x1FB99, 0xE9 }, // UPPER RIGHT TO LOWER LEFT FILL
    .{ 0x1FB87, 0xEA }, // RIGHT ONE QUARTER BLOCK
    .{ 0x251C, 0xEB }, // BOX DRAWINGS LIGHT VERTICAL AND RIGHT
    .{ 0x2597, 0xEC }, // QUADRANT LOWER RIGHT
    .{ 0x2514, 0xED }, // BOX DRAWINGS LIGHT UP AND RIGHT
    .{ 0x2510, 0xEE }, // BOX DRAWINGS LIGHT DOWN AND LEFT
    .{ 0x2582, 0xEF }, // LOWER ONE QUARTER BLOCK
    .{ 0x250C, 0xF0 }, // BOX DRAWINGS LIGHT DOWN AND RIGHT
    .{ 0x2534, 0xF1 }, // BOX DRAWINGS LIGHT UP AND HORIZONTAL
    .{ 0x252C, 0xF2 }, // BOX DRAWINGS LIGHT DOWN AND HORIZONTAL
    .{ 0x2524, 0xF3 }, // BOX DRAWINGS LIGHT VERTICAL AND LEFT
    .{ 0x258E, 0xF4 }, // LEFT ONE QUARTER BLOCK
    .{ 0x258D, 0xF5 }, // LEFT THREE EIGHTHS BLOCK
    .{ 0x1FB88, 0xF6 }, // RIGHT THREE EIGHTHS BLOCK
    .{ 0x1FB82, 0xF7 }, // UPPER ONE QUARTER BLOCK
    .{ 0x1FB83, 0xF8 }, // UPPER THREE EIGHTHS BLOCK
    .{ 0x2583, 0xF9 }, // LOWER THREE EIGHTHS BLOCK
    .{ 0x2713, 0xFA }, // CHECK MARK
    .{ 0x2596, 0xFB }, // QUADRANT LOWER LEFT
    .{ 0x259D, 0xFC }, // QUADRANT UPPER RIGHT
    .{ 0x2518, 0xFD }, // BOX DRAWINGS LIGHT UP AND LEFT
    .{ 0x2598, 0xFE }, // QUADRANT UPPER LEFT
    .{ 0x259A, 0xFF }, // QUADRANT UPPER LEFT AND LOWER RIGHT
};
