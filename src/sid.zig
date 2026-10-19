// Zig translation of _sid.h from llvm-mos-sdk:
// Copyright 2022 LLVM-MOS Project
// Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
// See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license information.

const std = @import("std");

/// SID voice registers.
pub const Voice = extern struct {
    freq: u16 align(1), // Frequency
    pw: u16 align(1), // Pulse width
    ctrl: u8, // Control register
    ad: u8, // Attack/decay
    sr: u8, // Sustain/release
};

/// SID registers.
pub const Sid = extern struct {
    v1: Voice, // Voice 1
    v2: Voice, // Voice 2
    v3: Voice, // Voice 3
    flt_freq: u16 align(1), // Filter frequency
    flt_ctrl: u8, // Filter control register
    amp: u8, // Amplitude
    ad1: u8, // A/D converter 1
    ad2: u8, // A/D converter 2
    noise: u8, // Noise generator
    read3: u8, // Value of voice 3
};
