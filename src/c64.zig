// Zig translation of c64.h from llvm-mos-sdk:
//
// Copyright 2022 LLVM-MOS Project
// Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
// See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license information.

const builtin = @import("builtin");

comptime {
    if (builtin.cpu.arch != .mos or builtin.os.tag != .c64)
        @compileError("This module may only be used when compiling for the C64");
}

// Additional key defines
pub const ch_f1: u8 = 133;
pub const ch_f2: u8 = 137;
pub const ch_f3: u8 = 134;
pub const ch_f4: u8 = 138;
pub const ch_f5: u8 = 135;
pub const ch_f6: u8 = 139;
pub const ch_f7: u8 = 136;
pub const ch_f8: u8 = 140;

// Colors
pub const Color = enum(u8) {
    black = 0x00,
    white = 0x01,
    red = 0x02,
    cyan = 0x03,
    purple = 0x04,
    green = 0x05,
    blue = 0x06,
    yellow = 0x07,
    orange = 0x08,
    brown = 0x09,
    light_red = 0x0A,
    gray1 = 0x0B,
    gray2 = 0x0C,
    light_green = 0x0D,
    light_blue = 0x0E,
    gray3 = 0x0F,
    _,
};

// Masks for joy_read
pub const joy_up_mask: u8 = 0x01;
pub const joy_down_mask: u8 = 0x02;
pub const joy_left_mask: u8 = 0x04;
pub const joy_right_mask: u8 = 0x08;
pub const joy_btn_1_mask: u8 = 0x10;

// Hardware
pub const vic: *volatile @import("vic2.zig").Vic2 = @ptrFromInt(0xD000);
pub const sid: *volatile @import("sid.zig").Sid = @ptrFromInt(0xD400);
pub const cia1: *volatile @import("cia.zig").Cia = @ptrFromInt(0xDC00);
pub const cia2: *volatile @import("cia.zig").Cia = @ptrFromInt(0xDD00);

// Special memory areas
pub const color_ram: [*]volatile u8 = @ptrFromInt(0xD800);
