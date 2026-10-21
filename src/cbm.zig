// zig translation of cbm.h from llvm-mos-sdk:
//
// Copyright 2022 LLVM-MOS Project
// Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
// See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license information.

const std = @import("std");
const c64 = @import("c64.zig");

pub const joy_fire_mask: u8 = c64.joy_btn_1_mask;

pub fn joyFire(v: u8) u8 {
    return v & joy_fire_mask;
}

// Character codes (CBM charset)
pub const ch_hline: u8 = 192;
pub const ch_vline: u8 = 221;
pub const ch_ulcorner: u8 = 176;
pub const ch_urcorner: u8 = 174;
pub const ch_llcorner: u8 = 173;
pub const ch_lrcorner: u8 = 189;
pub const ch_ttee: u8 = 178;
pub const ch_btee: u8 = 177;
pub const ch_ltee: u8 = 171;
pub const ch_rtee: u8 = 179;
pub const ch_cross: u8 = 219;
pub const ch_curs_up: u8 = 145;
pub const ch_curs_down: u8 = 17;
pub const ch_curs_left: u8 = 157;
pub const ch_curs_right: u8 = 29;
pub const ch_pi: u8 = 222;
pub const ch_home: u8 = 19;
pub const ch_del: u8 = 20;
pub const ch_ins: u8 = 148;
pub const ch_enter: u8 = 13;
pub const ch_stop: u8 = 3;
pub const ch_lira: u8 = 92;
pub const ch_esc: u8 = 27;
pub const ch_font_lower: u8 = 14;
pub const ch_font_upper: u8 = 142;

// CBM file access
pub const cbm_a_ro: u8 = 1; // Read only
pub const cbm_a_wo: u8 = 2; // Write only
pub const cbm_a_rw: u8 = 3; // Read, Write

/// Directory entry.
pub const CbmDirent = extern struct {
    name: [17]u8, // File name in PetSCII, limited to 16 chars
    size: u16 align(1), // Size, in 254-/256-byte blocks
    type: u8,
    access: u8,
};

// Constants to use with cbm_open() for opening a file for reading or
// writing without the need to append ",r" or ",w" to the filename.
pub const cbm_read: u8 = 0; // default is ",p"
pub const cbm_write: u8 = 1; // ditto
pub const cbm_seq: u8 = 2; // default is ",r" -- or ",s" when writing

// Flags for cbm_k_load()
pub const cbm_load_ram: u8 = 0; // Load into RAM
pub const cbm_load_verify: u8 = 1; // Performs verify

// Kernal-level functions
pub extern fn cbm_k_acptr() u8;
pub extern fn cbm_k_basin() u8;
pub extern fn cbm_k_bsout(c: u8) void;
pub extern fn cbm_k_chkin(fnum: u8) u8;
pub extern fn cbm_k_chkout(fnum: u8) u8;
pub extern fn cbm_k_chrin() u8;
pub extern fn cbm_k_chrout(c: u8) void;
pub extern fn cbm_k_cint() void;
pub extern fn cbm_k_ciout(c: u8) void;
pub extern fn cbm_k_ckout(fnum: u8) u8;
pub extern fn cbm_k_clall() void;
pub extern fn cbm_k_close(fnum: u8) void;
pub extern fn cbm_k_clrch() void;
pub extern fn cbm_k_getin() u8;
pub extern fn cbm_k_iobase() u16;
pub extern fn cbm_k_listen(dev: u8) void;

/// CBM KERNAL function to load or verify file.
///
/// Should be called after `cbm_k_setlfs()` and `cbm_k_setnam()`.
/// A non-zero `flag` value triggers verify.
///
/// Returns the address of the last byte loaded/verified or a KERNAL error code.
pub extern fn cbm_k_load(flag: u8, load_addr: ?*anyopaque) ?*anyopaque;

pub extern fn cbm_k_open() u8;
pub extern fn cbm_k_readst() u8;
pub extern fn cbm_k_save(startaddr: ?*anyopaque, endaddr_plusone: ?*anyopaque) u8;
pub extern fn cbm_k_scnkey() void;
pub extern fn cbm_k_second(addr: u8) void;
pub extern fn cbm_k_setlfs(lfn: u8, dev: u8, sa: u8) void;
pub extern fn cbm_k_setnam(name: [*:0]const u8) void;
pub extern fn cbm_k_settim(timer: u32) void;
pub extern fn cbm_k_talk(dev: u8) void;
pub extern fn cbm_k_tksa(addr: u8) void;
pub extern fn cbm_k_udtim() void;
pub extern fn cbm_k_unlsn() void;
pub extern fn cbm_k_untlk() void;
