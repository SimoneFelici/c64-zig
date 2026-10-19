// Zig translation of _vic2.h from llvm-mos-sdk:
//
// Copyright 2022 LLVM-MOS Project
// Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
// See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license information.

const std = @import("std");
const Color = @import("c64.zig").Color;

/// X/Y coordinate pair.
pub const Position = extern struct {
    x: u8, // X coordinate
    y: u8, // Y coordinate
};

/// VIC-II registers.
pub const Vic2 = extern struct {
    spr_pos: [8]Position, // Sprite X/Y coordinates
    spr_hi_x: u8, // High bits of X coordinate
    ctrl1: u8, // Control register 1
    rasterline: u8, // Current raster line
    strobe: Position, // Light pen X/Y position
    spr_ena: u8, // Enable sprites
    ctrl2: u8, // Control register 2
    spr_exp_y: u8, // Expand sprites in Y dir
    addr: u8, // Address of chargen and video ram
    irr: u8, // Interrupt request register
    imr: u8, // Interrupt mask register
    spr_bg_prio: u8, // Priority to background
    spr_mcolor: u8, // Sprite multicolor bits
    spr_exp_x: u8, // Expand sprites in X dir
    spr_coll: u8, // Sprite/sprite collision reg
    spr_bg_coll: u8, // Sprite/background collision reg
    bordercolor: Color, // Border color
    bgcolor: [4]Color, // Background colors
    spr_mcolors: [2]Color, // Colors for multicolor sprites
    spr_color: [8]Color, // Colors for the sprites

    // The following ones are only valid in the C128:
    x_kbd: u8, // Additional keyboard lines
    clock: u8, // Clock switch bit
};
