const utils = @import("utils.zig");
const fs = @import("std").fs;

fn ExecuteCargoInit() ![]u8 {
    return try utils.ExecuteCmd("cargo", "init");
}

pub fn createRustProject(dir: fs.Dir) !void {
    try dir.setAsCwd();
    _ = try ExecuteCargoInit();
}
