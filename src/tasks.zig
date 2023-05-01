const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const heap = std.heap;

pub const TaskCommand = struct {
    name: []const u8,
    cmd: []const u8,
};

const TASK_CMD_YML =
    \\  {s}
    \\    cmds:
    \\      - {s}
;

pub fn to_yaml(task: *TaskCommand) ![]u8 {
    const allocator = heap.page_allocator;
    defer allocator.free(); // Don't forget to free the memory lao

    const cmd_string = try fmt.allocPrint(allocator, TASK_CMD_YML, .{ task.name, task.cmd });
    return cmd_string;
}
