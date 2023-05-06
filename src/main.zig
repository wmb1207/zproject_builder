const std = @import("std");
const templates = @import("templates.zig");
const python = @import("python.zig");
const rust = @import("rust.zig");
const zig = @import("zig.zig");
const typescript = @import("typescript.zig");
const utils = @import("utils.zig");
const structs = @import("structs.zig");

const process = std.process;
const fs = std.fs;
const fmt = std.fmt;
const mem = std.mem;
const os = std.os;
const childProcess = std.ChildProcess;
const stdout = std.io.getStdOut;

fn createProject(project: structs.Project) !void {
    const cwd = fs.cwd();
    cwd.makeDir(project.name) catch {
        std.log.err("Cannot create directory: Directory {s} already exists", .{project.name});
        os.exit(1);
    };

    const iter_dir = try cwd.openIterableDir(project.name, .{});
    const dir = iter_dir.dir;

    switch (project.language) {
        .python => {
            try python.createPythonProject(dir);
            try utils.createDockerCompose(dir, "python_", project);
        },
        .rust => {
            try rust.createRustProject(dir);
            try utils.createDockerCompose(dir, "rust_", project);
        },
        .zig => {
            try zig.createZigProject(dir);
            try utils.createDockerCompose(dir, "zig_", project);
        },
        .js => {
            _ = try stdout().write("No no no... you're wrong... lets use TS");
            try typescript.createTypescriptProject(dir, project);
            try utils.createDockerCompose(dir, "ts_", project);
        },
        .ts => {
            try typescript.createTypescriptProject(dir, project);
            try utils.createDockerCompose(dir, "ts_", project);
        },
    }
}

pub fn main() !void {
    var args = process.args();
    defer args.deinit();

    _ = args.skip();

    const project_name = args.next() orelse "";

    if (project_name.len == 0) {
        @panic("MISSING NAME");
    }

    var project = structs.EmptyProject();
    project.name = project_name;
    const selected_language_response = try utils.SelectLanguage();
    project.language = selected_language_response.language;
    project.include_nvim_container = try utils.ShouldIncludeNvimContainer();
    project.include_database_container = try utils.ShouldIncludeDatabaseContainer();
    if (project.include_database_container) {
        const selected_database_response = try utils.SelectDatabase();
        var database = structs.Database{
            .version = "latest",
            .port = "3306",
            .db_name = "$DB_NAME",
            .username = "$DB_USERNAME",
            .password = "$DB_PASSWORD",
            .root_password = "$DB_PASSWORD",
            .db = selected_database_response.database,
        };
        project.database = database;
    }
    try createProject(project);
}
