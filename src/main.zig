const std = @import("std");
const templates = @import("templates.zig");
const python = @import("python.zig");
const rust = @import("rust.zig");
const utils = @import("utils.zig");
const structs = @import("structs.zig");

const process = std.process;
const fs = std.fs;
const fmt = std.fmt;
const mem = std.mem;
const os = std.os;
const childProcess = std.ChildProcess;
const stdout = std.io.getStdOut;
const stdin = std.io.getStdIn;

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
        .zig => std.log.debug("oeuoeuoeu", .{}),
    }
}

const ConfigInputError = error{
    InvalidInput,
};

const OptionalResponse = union {
    language: structs.Languages,
    database: structs.Databases,
    invalid_input: ConfigInputError,
};

fn MapCharToLanguage(value: []u8) OptionalResponse {
    if (mem.eql(u8, value, "p")) return OptionalResponse{ .language = .python };
    if (mem.eql(u8, value, "r")) return OptionalResponse{ .language = .rust };
    if (mem.eql(u8, value, "z")) return OptionalResponse{ .language = .zig };
    return OptionalResponse{ .invalid_input = ConfigInputError.InvalidInput };
}

fn MapCharToDatabase(value: []u8) OptionalResponse {
    if (mem.eql(u8, value, "m")) return OptionalResponse{ .database = .mysql };
    if (mem.eql(u8, value, "M")) return OptionalResponse{ .database = .mariadb };
    if (mem.eql(u8, value, "p")) return OptionalResponse{ .database = .postgresql };
    return OptionalResponse{ .invalid_input = ConfigInputError.InvalidInput };
}

fn SelectDatabase() !OptionalResponse {
    const select_message =
        \\ Choose a database: 
        \\      mysql(m) 
        \\      mariadb(M)
        \\      postgresql(p)
        \\
    ;
    return OptionalQuestion(select_message, MapCharToDatabase);
}

fn SelectLanguage() !OptionalResponse {
    const select_message =
        \\ Choose a language: 
        \\      python(p) 
        \\      rust(r)
        \\      zig(z)
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

fn ShouldIncludeNvimContainer() !bool {
    const question = "Include a Neovim container ready to code? (Y/n):";
    return binary_question(question);
}

fn ShouldIncludeDatabaseContainer() !bool {
    const question = "Include a SQL database container? (Y/n):";
    return binary_question(question);
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
    const selected_language_response = try SelectLanguage();
    project.language = selected_language_response.language;
    project.include_nvim_container = try ShouldIncludeNvimContainer();
    project.include_database_container = try ShouldIncludeDatabaseContainer();
    if (project.include_database_container) {
        const selected_database_response = try SelectDatabase();
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
