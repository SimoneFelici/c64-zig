# c64-zig

Commodore 64 hardware definitions in Zig.

A Zig translation of the C64 headers from [llvm-mos-sdk](https://github.com/llvm-mos/llvm-mos-sdk) (`c64.h`, `_vic2.h`, `_sid.h`, `_6526.h`, `cbm.h`, `charset.h`).

## Requirements

- zig 0.17.0
- [zig-mos-bootstrap](https://github.com/kassane/zig-mos-bootstrap) 0.17.0
- The C64 target `.cpu_arch = .mos, .os_tag = .c64)`

## Installation

Add the dependency:
```bash
zig fetch --save git+https://github.com/SimoneFelici/c64-zig
```

Import it in `build.zig`:
```zig
const c64_dep = b.dependency("c64_zig", .{});
exe.root_module.addImport("c64", c64_dep.module("c64"));
```

Then use it:
```zig
const c64 = @import("c64");
```

## Example

```zig
const c64 = @import("c64");

const VIC = c64.vic;

export fn main() void {
    VIC.bgcolor[0] = .black;
    VIC.bordercolor = .blue;
}
```

Or use this [repo](https://github.com/SimoneFelici/zig-c64-baseline) as a baseline for the project

## Contents

| Name | Type | Address | Description |
|------|------|---------|-------------|
| `vic` | `*volatile Vic2` | `$D000` | VIC-II video chip |
| `sid` | `*volatile Sid` | `$D400` | SID sound chip |
| `cia1` | `*volatile Cia` | `$DC00` | CIA 1: keyboard, joysticks, IRQ |
| `cia2` | `*volatile Cia` | `$DD00` | CIA 2: serial bus, VIC-II bank, NMI |
| `color_ram` | `[*]volatile u8` | `$D800` | Color RAM |
| `Color` | `enum(u8)` | | The 16 C64 colors |
| `ch_f1` … `ch_f8` | `u8` | | PETSCII codes of the function keys |
| `joy_*_mask` | `u8` | | Joystick bit masks |


## Credits and license

The register layouts are translated from [llvm-mos-sdk](https://github.com/llvm-mos/llvm-mos-sdk)
