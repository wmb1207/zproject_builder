const utils = @import("utils.zig");
const std = @import("std");
const structs = @import("structs.zig");
const templates = @import("templates.zig");
const Project = structs.Project;
const fs = std.fs;
const Tuple = std.meta.Tuple;

const CmdResult = structs.CmdResult;

const NpmErrors = error{
    ErrorInstallingDependencies,
};

fn createIndexFile(dir: fs.Dir) !void {
    var file = try dir.createFile("index.ts", .{ .read = true });
    defer file.close();
}

fn createDistDirectory(dir: fs.Dir) !void {
    try dir.makeDir("Dist");
}

fn ExecuteNpmInit() !CmdResult {
    return try utils.ExecuteCmd("npm", "init");
}

fn createPackageJson(dir: fs.Dir, project: Project) !void {
    var file = try dir.createFile("package.json", .{ .read = true });
    defer file.close();

    try file.writer().print(templates.PACKAGE_JSON, .{ project.name, "this is just a dummy description" });
}

fn installDependencies(dir: fs.Dir) !CmdResult {
    try dir.setAsCwd();
    return try utils.ExecuteCmd("npm", "i");
}

pub fn createTypescriptProject(dir: fs.Dir, project: Project) !void {
    try dir.setAsCwd();
    _ = try ExecuteNpmInit();
    _ = try createDistDirectory(dir);
    _ = try createIndexFile(dir);
    _ = try createPackageJson(dir, project);
    const output = try installDependencies(dir);
    if (output[1].len > 0) {
        std.debug.print("{s}", .{output[1]});
        return NpmErrors.ErrorInstallingDependencies;
    }
}
