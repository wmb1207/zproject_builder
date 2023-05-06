const std = @import("std");
const templates = @import("templates.zig");
const structs = @import("structs.zig");
const fs = std.fs;
const Tuple = std.meta.Tuple;
const childProcess = std.ChildProcess;
const mem = std.mem;
const stdout = std.io.getStdOut;
const stdin = std.io.getStdIn;

pub fn ExecuteCmd(cmd: []const u8, arguments: []const u8) !Tuple(&.{ []u8, []u8 }) {
    const result = try childProcess.exec(.{ .allocator = std.heap.page_allocator, .argv = &[_][]const u8{
        cmd,
        arguments,
    } });
    return .{ result.stdout, result.stderr };
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

pub const ConfigInputError = error{
    InvalidInput,
};

pub const OptionalResponse = union {
    language: structs.Languages,
    database: structs.Databases,
    invalid_input: ConfigInputError,
};

fn MapCharToLanguage(value: []u8) OptionalResponse {
    if (mem.eql(u8, value, "p")) return OptionalResponse{ .language = .python };
    if (mem.eql(u8, value, "r")) return OptionalResponse{ .language = .rust };
    if (mem.eql(u8, value, "z")) return OptionalResponse{ .language = .zig };
    if (mem.eql(u8, value, "j")) return OptionalResponse{ .language = .js };
    if (mem.eql(u8, value, "t")) return OptionalResponse{ .language = .ts };
    return OptionalResponse{ .invalid_input = ConfigInputError.InvalidInput };
}

fn MapCharToDatabase(value: []u8) OptionalResponse {
    if (mem.eql(u8, value, "m")) return OptionalResponse{ .database = .mysql };
    if (mem.eql(u8, value, "M")) return OptionalResponse{ .database = .mariadb };
    if (mem.eql(u8, value, "p")) return OptionalResponse{ .database = .postgresql };
    return OptionalResponse{ .invalid_input = ConfigInputError.InvalidInput };
}

pub fn SelectDatabase() !OptionalResponse {
    const select_message =
        \\ Choose a database: 
        \\      mysql(m) 
        \\      mariadb(M)
        \\      postgresql(p)
        \\
    ;
    return OptionalQuestion(select_message, MapCharToDatabase);
}

pub fn SelectLanguage() !OptionalResponse {
    const select_message =
        \\ Choose a language: 
        \\      python(p) 
        \\      rust(r)
        \\      zig(z)
        \\      js(j)
        \\      ts(t)
        \\
    ;

    return OptionalQuestion(select_message, MapCharToLanguage);
}

fn OptionalQuestion(question: []const u8, handler: *const fn (value: []u8) OptionalResponse) !OptionalResponse {
    _ = try stdout().write(question);
    const input_reader = stdin().reader();
    var buffer: [2]u8 = undefined; // REMEMBER this needs to be 2 to be able to handle the new_line char '\n'.

    if (try input_reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |user_input| {
        return handler(user_input);
    }
    @panic("ERROR INVALID OPTION");
}

fn binary_question(question: []const u8) !bool {
    _ = try stdout().write(question);
    const input_reader = stdin().reader();
    var buffer: [2]u8 = undefined; // REMEMBER this needs to be 2 to be able to handle the new_line char '\n'.
    if (try input_reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |user_input| {
        if (mem.eql(u8, user_input, "n")) return false;
    }
    return true;
}

pub fn ShouldIncludeNvimContainer() !bool {
    const question = "Include a Neovim container ready to code? (Y/n):";
    return binary_question(question);
}

pub fn ShouldIncludeDatabaseContainer() !bool {
    const question = "Include a SQL database container? (Y/n):";
    return binary_question(question);
}
