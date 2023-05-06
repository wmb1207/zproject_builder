const utils = @import("utils.zig");
const std = @import("std");
const fs = std.fs;
const Tuple = std.meta.Tuple;

fn ExecuteCargoInit() !Tuple(&.{ []u8, []u8 }) {
    return try utils.ExecuteCmd("cargo", "init");
}

pub fn createRustProject(dir: fs.Dir) !void {
    try dir.setAsCwd();
    _ = try ExecuteCargoInit();
}
