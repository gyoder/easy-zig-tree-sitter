const std = @import("std");
const Io = std.Io;

const ts = @import("tree-sitter");
const ezts = @import("eazy_zig_tree_sitter");

const test_source =
    \\#include <stdio.h>
    \\
    \\int add(int a, int b) {
    \\    return a + b;
    \\}
    \\
    \\int main(void) {
    \\    int result = add(1, 2);
    \\    printf("result: %d\n", result);
    \\    return 0;
    \\}
    \\
;

const test_source_lua =
    \\local function values()
    \\    return 3, 7
    \\end
    \\
    \\a, b = values()
    \\print(a)
    \\print(b)
    \\
    \\_, c = values()
    \\print(c)
;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    const query_source = ezts.getQuery("lua").?;

    const language = ezts.getLang("lua").?;
    defer language.destroy();

    const parser = ts.Parser.create();
    defer parser.destroy();
    try parser.setLanguage(language);

    const tree = parser.parseString(test_source_lua, null);
    defer tree.?.destroy();

    const root = tree.?.rootNode();

    var error_offset: u32 = 0;
    const query = ts.Query.create(language, query_source, &error_offset) catch |err| {
        std.debug.print("failed to parse query at byte {d}: {s}\n", .{ error_offset, @errorName(err) });
        return err;
    };
    defer query.destroy();

    const cursor = ts.QueryCursor.create();
    defer cursor.destroy();
    cursor.exec(query, root);

    const Span = struct {
        start: u32,
        end: u32,
        name: []const u8,
    };

    var spans: std.ArrayList(Span) = .empty;
    defer spans.deinit(allocator);

    while (cursor.nextCapture()) |result| {
        const capture_index, const match = result;
        const capture = match.captures[capture_index];
        const name = query.captureNameForId(capture.index) orelse "?";
        std.debug.print("{d} {d} {s}\n", .{ capture.node.startByte(), capture.node.endByte(), name });
        try spans.append(allocator, .{
            .start = capture.node.startByte(),
            .end = capture.node.endByte(),
            .name = name,
        });
    }
}

test { _ = @import("tests.zig"); }
