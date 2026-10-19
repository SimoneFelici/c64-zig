const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("c64", .{
        .root_source_file = b.path("src/c64.zig"),
    });
}
