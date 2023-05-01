const std = @import("std");
const templates = @import("templates.zig");
const structs = @import("structs.zig");
const fs = std.fs;
const childProcess = std.ChildProcess;

pub fn ExecuteCmd(cmd: []const u8, arguments: []const u8) ![]u8 {
    const result = try childProcess.exec(.{ .allocator = std.heap.page_allocator, .argv = &[_][]const u8{
        cmd,
        arguments,
    } });
    return result.stdout;
}

pub fn createTaskFile(dir: fs.Dir, project: structs.Project) !void {
    _ = project;
    var file = try dir.createFile("taskfile.yml", .{ .read = true });
    defer file.close();

    try file.writer().writeAll(templates.TASKFILE);
}

pub fn createDockerCompose(dir: fs.Dir, language: []const u8, project: structs.Project) !void {
    var file = try dir.createFile("test.docker-compose.yml", .{ .read = true });
    defer file.close();

    try file.writer().print(templates.DOCKER_COMPOSE_TEMPLATE, .{});
    if (project.include_nvim_container) {
        try file.writer().print(templates.NVIM_CONTAINER, .{language});
    }
    if (project.include_database_container) {
        var database = project.database;
        switch (database.db) {
            .mysql => try file.writer().print(templates.MYSQL, .{
                database.version,
                database.username,
                database.password,
                database.db_name,
                database.port,
            }),
            .mariadb => try file.writer().print(templates.MARIADB, .{
                database.version,
                database.username,
                database.password,
                database.db_name,
                database.port,
            }),
            .postgresql => try file.writer().print(templates.POSTGRESQL, .{
                database.version,
                database.username,
                database.password,
                database.db_name,
                database.port,
            }),
        }
    }
}
