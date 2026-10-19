// Zig translation of _6526 from llvm-mos-sdk:
//
// Copyright 2022 LLVM-MOS Project
// Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
// See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license information.

const std = @import("std");

/// 6526 CIA registers.
/// NOTE: The timer registers are not declared as 16 bit registers, because
/// the order in which the two 8 bit halves are written is important, and
/// the compiler doesn't guarantee any order when writing 16 bit values.
pub const Cia = extern struct {
    pra: u8, // Port register A
    prb: u8, // Port register B
    ddra: u8, // Data direction register A
    ddrb: u8, // Data direction register B
    ta_lo: u8, // Timer A, low byte
    ta_hi: u8, // Timer A, high byte
    tb_lo: u8, // Timer B, low byte
    tb_hi: u8, // Timer B, high byte
    tod_10: u8, // TOD, 1/10 sec.
    tod_sec: u8, // TOD, seconds
    tod_min: u8, // TOD, minutes
    tod_hour: u8, // TOD, hours
    sdr: u8, // Serial data register
    icr: u8, // Interrupt control register
    cra: u8, // Control register A
    crb: u8, // Control register B
};
