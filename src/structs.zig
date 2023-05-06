const std = @import("std");
const Tuple = std.meta.Tuple;

pub const Databases = enum { mysql, postgresql, mariadb };
pub const Languages = enum { python, zig, rust, js, ts };

pub const Database = struct {
    version: []const u8,
    db_name: []const u8,
    username: []const u8,
    password: []const u8,
    root_password: []const u8,
    port: []const u8,
    db: Databases,
};

pub const Project = struct {
    name: []const u8,
    language: Languages,
    include_nvim_container: bool,
    include_database_container: bool,
    database: Database,
};

pub fn EmptyDatabase() Project {
    return Database{
        .root_password = "",
        .password = "",
        .db_name = "",
        .username = "",
        .port = "",
        .version = "",
        .db = "",
    };
}

pub fn EmptyProject() Project {
    return Project{
        .name = "",
        .database = undefined,
        .include_database_container = false,
        .include_nvim_container = false,
        .language = undefined,
    };
}

pub const CmdResult = Tuple(&.{ []u8, []u8 });
