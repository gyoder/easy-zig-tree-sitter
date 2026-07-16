# EZTS
## Easy Zig Tree Sitter

Managed Grammars and Highlight Queries for use with [Tree-Sitter Zig Bindings](https://github.com/tree-sitter/zig-tree-sitter)

## How to use

### Grab Dependencies
```sh
zig fetch --save git+https://github.com/tree-sitter/zig-tree-sitter.git

# official source
zig fetch --save git+https://git.gae.moe/grace/eazy-zig-tree-sitter.git
# mirrors
zig fetch --save git+https://github.com/gyoder/eazy-zig-tree-sitter.git
zig fetch --save git+https://tangled.org/grace.pink/eazy-zig-tree-sitter.git
```

### `build.zig`
```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ezts = b.dependency("eazy_zig_tree_sitter", .{
        .target = target,
        .optimize = optimize,
        .use_all_langs = false
        .use_langs = &.{"c", "js", "ts", "py", "rs"},
        .third_party = true,  // optional, for community grammars
    });

    const exe = b.addExecutable(.{
        .name = "my_project",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "eazy_zig_tree_sitter", .module = ezts.module("eazy_zig_tree_sitter") },
                .{ .name = "tree-sitter", .module = ezts.module("tree-sitter") },
            },
        }),
    });
    b.installArtifact(exe);
}
```

### `main.zig`
```zig
const std = @import("std");
const ts = @import("tree-sitter");
const ezts = @import("eazy_zig_tree_sitter");

pub fn main() !void {
    const source =
        \\fn fib(n: u32) u32 {
        \\    if n < 2 { return n; }
        \\    return fib(n - 1) + fib(n - 2);
        \\}
    ;

    const lang = (ezts.getLang("rs") orelse return error.NoLang).?;
    defer lang.destroy();

    var parser = ts.Parser.create();
    defer parser.destroy();
    try parser.setLanguage(lang);

    const tree = (parser.parseString(source, null) orelse return error.ParseFailed);
    defer tree.destroy();

    std.debug.print("tree: {s}\n", .{tree.rootNode().string()});
}
```


## LLM Notice

An LLM was used to aggregate dependencies. It was not used in any of the (quite
minimal) logic of this repo. That was all done by hand by me without LLM
influence.


