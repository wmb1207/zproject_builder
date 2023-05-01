const fs = @import("std").fs;
const templates = @import("templates.zig");

fn createInitPy(dir: fs.Dir) !void {
    var file = try dir.createFile("__init__.py", .{ .read = true });
    defer file.close();
}

fn createRequirementsTxt(dir: fs.Dir) !void {
    var file = try dir.createFile("requirements.txt", .{ .read = true });
    defer file.close();
}

fn createMainPy(dir: fs.Dir) !void {
    var file = try dir.createFile("main.py", .{ .read = true });
    defer file.close();
    try file.writer().writeAll(templates.MAIN_PY);
}

pub fn createPythonProject(dir: fs.Dir) !void {
    try createInitPy(dir);
    try createRequirementsTxt(dir);
    try createMainPy(dir);
}
