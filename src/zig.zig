const utils = @import("utils.zig");
const std = @import("std");
const fs = std.fs;
const Tuple = std.meta.Tuple;

fn ExecuteZigInitExe() !Tuple(&.{ []u8, []u8 }) {
    return try utils.ExecuteCmd("zig", "build-exe");
}

pub fn createZigProject(dir: fs.Dir) !void {
    try dir.setAsCwd();
    _ = try ExecuteZigInitExe();
}
