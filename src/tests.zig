const std = @import("std");
const testing = std.testing;
const ts = @import("tree-sitter");
const ezts = @import("eazy_zig_tree_sitter");
const grammars = @import("grammars");
const queries_mod = @import("queries");

const Entry = struct { key: []const u8, source: []const u8 };

fn runParseTest(entries: []const Entry) !void {
    for (entries) |e| {
        const lang = ezts.getLang(e.key) orelse @panic("unknown lang");
        defer lang.destroy();
        var parser = ts.Parser.create();
        defer parser.destroy();
        try parser.setLanguage(lang);
        const tree = parser.parseString(e.source, null) orelse {
            std.debug.print("PARSE FAIL: {s}\n", .{e.key});
            return error.ParseFailed;
        };
        defer tree.destroy();
    }
}

fn runQueryTest(entries: []const Entry) !void {
    for (entries) |e| {
        const lang = ezts.getLang(e.key) orelse @panic("unknown lang");
        defer lang.destroy();
        var parser = ts.Parser.create();
        defer parser.destroy();
        try parser.setLanguage(lang);
        const tree = parser.parseString(e.source, null) orelse continue;
        defer tree.destroy();
        const query_src = ezts.getQuery(e.key) orelse {
            std.debug.print("NO QUERY: {s}\n", .{e.key});
            continue;
        };
        var error_offset: u32 = 0;
        const query = ts.Query.create(lang, query_src, &error_offset) catch |err| {
            std.debug.print("QUERY ERROR {s}: {s} at {d}\n", .{ e.key, @errorName(err), error_offset });
            return error.QueryFailed;
        };
        defer query.destroy();
        const cursor = ts.QueryCursor.create();
        defer cursor.destroy();
        cursor.exec(query, tree.rootNode());
        _ = cursor.nextCapture();
    }
}

const parse_entries: []const Entry = &.{
    .{ .key = "c", .source = "int a;" },
    .{ .key = "md", .source = "# hi" },
    .{ .key = "md_inline", .source = "**hi**" },
    .{ .key = "lua", .source = "x=1" },
    .{ .key = "cuda", .source = "int a;" },
    .{ .key = "glsl", .source = "int a;" },
    .{ .key = "diff", .source = "+a" },
    .{ .key = "ungrammar", .source = "A = 'a'" },
    .{ .key = "thrift", .source = "struct A{}" },
    .{ .key = "meson", .source = "x=1" },
    .{ .key = "gitattributes", .source = "* text" },
    .{ .key = "pymanifest", .source = "" },
    .{ .key = "poe_filter", .source = "" },
    .{ .key = "chatito", .source = "" },
    .{ .key = "ino", .source = "void setup(){}" },
    .{ .key = "capnp", .source = "struct A{}" },
    .{ .key = "kdl", .source = "node1" },
    .{ .key = "func", .source = "" },
    .{ .key = "gosum", .source = "" },
    .{ .key = "ron", .source = "()" },
    .{ .key = "po", .source = "" },
    .{ .key = "starlark", .source = "x=1" },
    .{ .key = "yuck", .source = "" },
    .{ .key = "smali", .source = ".class public A" },
    .{ .key = "bicep", .source = "" },
    .{ .key = "cpon", .source = "" },
    .{ .key = "firrtl", .source = "" },
    .{ .key = "luap", .source = "" },
    .{ .key = "squirrel", .source = "x=1" },
    .{ .key = "uxntal", .source = "" },
    .{ .key = "cairo", .source = "func main(){}" },
    .{ .key = "odin", .source = "main :: proc(){}" },
    .{ .key = "hare", .source = "export fn main() void;" },
    .{ .key = "pony", .source = "actor Main" },
    .{ .key = "tablegen", .source = "" },
    .{ .key = "luadoc", .source = "" },
    .{ .key = "puppet", .source = "$a=1" },
    .{ .key = "luau", .source = "x=1" },
    .{ .key = "objc", .source = "int a;" },
    .{ .key = "ispc", .source = "int a;" },
    .{ .key = "pem", .source = "" },
    .{ .key = "requirements", .source = "a" },
    .{ .key = "gpg", .source = "" },
    .{ .key = "bb", .source = "A = \"1\"" },
    .{ .key = "csv", .source = "a,b" },
    .{ .key = "psv", .source = "a|b" },
    .{ .key = "tsv", .source = "a\tb" },
    .{ .key = "printf", .source = "" },
    .{ .key = "re2c", .source = "" },
    .{ .key = "doxygen", .source = "" },
    .{ .key = "ssh_config", .source = "Host *" },
    .{ .key = "nqc", .source = "" },
    .{ .key = "kconfig", .source = "mainmenu \"x\"" },
    .{ .key = "gn", .source = "executable(\"a\") {}" },
    .{ .key = "udev", .source = "" },
    .{ .key = "xcompose", .source = "" },
    .{ .key = "linkerscript", .source = "" },
    .{ .key = "properties", .source = "key=value" },
    .{ .key = "readline", .source = "" },
    .{ .key = "Makefile", .source = "x=a" },
    .{ .key = "yaml", .source = "a: 1" },
    .{ .key = "toml", .source = "a=1" },
    .{ .key = "svelte", .source = "" },
    .{ .key = "scss", .source = "$a:1" },
    .{ .key = "cst", .source = "" },
    .{ .key = "jl", .source = "x=1" },
    .{ .key = "hs", .source = "x=1" },
    .{ .key = "cyberchef", .source = "" },
    .{ .key = "js", .source = "1" },
    .{ .key = "json", .source = "1" },
    .{ .key = "cpp", .source = "int a;" },
    .{ .key = "rb", .source = "x=1" },
    .{ .key = "go", .source = "package p" },
    .{ .key = "cs", .source = "class A{}" },
    .{ .key = "py", .source = "x=1" },
    .{ .key = "rs", .source = "fn f(){}" },
    .{ .key = "sh", .source = "true" },
    .{ .key = "java", .source = "class A{}" },
    .{ .key = "scala", .source = "class A" },
    .{ .key = "agda", .source = "" },
    .{ .key = "html", .source = "<p>" },
    .{ .key = "embedded_template", .source = "" },
    .{ .key = "regex", .source = "a" },
    .{ .key = "css", .source = "a{}" },
    .{ .key = "jsdoc", .source = "/** */" },
    .{ .key = "ql", .source = "" },
    .{ .key = "query", .source = "" },
    .{ .key = "lisp", .source = "()" },
    .{ .key = "tf", .source = "" },
    .{ .key = "hcl", .source = "" },
    .{ .key = "hlsl", .source = "int a;" },
    .{ .key = "tcl", .source = "" },
    .{ .key = "chatl", .source = "" },
    .{ .key = "wgsl_bevy", .source = "" },
    .{ .key = "move", .source = "" },
    .{ .key = "kt", .source = "fun f(){}" },
    .{ .key = "vim", .source = "" },
    .{ .key = "hyprlang", .source = "" },
    .{ .key = "gstlaunch", .source = "" },
    .{ .key = "slang", .source = "" },
    .{ .key = "dtd", .source = "" },
    .{ .key = "xml", .source = "<a/>" },
    .{ .key = "core_schema", .source = "" },
    .{ .key = "json_schema", .source = "" },
    .{ .key = "legacy_schema", .source = "" },
    .{ .key = "vue", .source = "" },
    .{ .key = "qmldir", .source = "" },
    .{ .key = "zig", .source = "const a=1;" },
    .{ .key = "test", .source = "" },
    .{ .key = "v", .source = "" },
    .{ .key = "tsx", .source = "<a/>" },
    .{ .key = "ts", .source = "let a=1" },
    .{ .key = "php", .source = "<?php" },
    .{ .key = "php_only", .source = "<?php" },
    .{ .key = "mli", .source = "" },
    .{ .key = "ml", .source = "let a=1" },
    .{ .key = "mly", .source = "" },
    .{ .key = "fluent", .source = "" },
    .{ .key = "tsq", .source = "" },
    .{ .key = "ql_dbscheme", .source = "" },
};

const query_entries: []const Entry = &.{
    .{ .key = "c", .source = "int a;" },
    .{ .key = "md", .source = "# hi" },
    .{ .key = "md_inline", .source = "**hi**" },
    .{ .key = "lua", .source = "x=1" },
    .{ .key = "cuda", .source = "int a;" },
    .{ .key = "glsl", .source = "int a;" },
    .{ .key = "diff", .source = "+a" },
    .{ .key = "ungrammar", .source = "A = 'a'" },
    .{ .key = "thrift", .source = "struct A{}" },
    .{ .key = "meson", .source = "x=1" },
    .{ .key = "gitattributes", .source = "* text" },
    .{ .key = "pymanifest", .source = "" },
    .{ .key = "poe_filter", .source = "" },
    .{ .key = "chatito", .source = "" },
    .{ .key = "ino", .source = "void setup(){}" },
    .{ .key = "capnp", .source = "struct A{}" },
    .{ .key = "kdl", .source = "node1" },
    .{ .key = "func", .source = "" },
    .{ .key = "gosum", .source = "" },
    .{ .key = "ron", .source = "()" },
    .{ .key = "po", .source = "" },
    .{ .key = "starlark", .source = "x=1" },
    .{ .key = "yuck", .source = "" },
    .{ .key = "smali", .source = ".class public A" },
    .{ .key = "bicep", .source = "" },
    .{ .key = "cpon", .source = "" },
    .{ .key = "firrtl", .source = "" },
    .{ .key = "luap", .source = "" },
    .{ .key = "squirrel", .source = "x=1" },
    .{ .key = "uxntal", .source = "" },
    .{ .key = "cairo", .source = "func main(){}" },
    .{ .key = "odin", .source = "main :: proc(){}" },
    .{ .key = "hare", .source = "export fn main() void;" },
    .{ .key = "pony", .source = "actor Main" },
    .{ .key = "tablegen", .source = "" },
    .{ .key = "luadoc", .source = "" },
    .{ .key = "puppet", .source = "$a=1" },
    .{ .key = "luau", .source = "x=1" },
    .{ .key = "objc", .source = "int a;" },
    .{ .key = "ispc", .source = "int a;" },
    .{ .key = "pem", .source = "" },
    .{ .key = "requirements", .source = "a" },
    .{ .key = "gpg", .source = "" },
    .{ .key = "bb", .source = "A = \"1\"" },
    .{ .key = "csv", .source = "a,b" },
    .{ .key = "psv", .source = "a|b" },
    .{ .key = "tsv", .source = "a\tb" },
    .{ .key = "printf", .source = "" },
    .{ .key = "re2c", .source = "" },
    .{ .key = "doxygen", .source = "" },
    .{ .key = "ssh_config", .source = "Host *" },
    .{ .key = "nqc", .source = "" },
    .{ .key = "kconfig", .source = "mainmenu \"x\"" },
    .{ .key = "gn", .source = "executable(\"a\") {}" },
    .{ .key = "udev", .source = "" },
    .{ .key = "xcompose", .source = "" },
    .{ .key = "linkerscript", .source = "" },
    .{ .key = "properties", .source = "key=value" },
    .{ .key = "readline", .source = "" },
    .{ .key = "Makefile", .source = "x=a" },
    .{ .key = "yaml", .source = "a: 1" },
    .{ .key = "toml", .source = "a=1" },
    .{ .key = "svelte", .source = "" },
    .{ .key = "scss", .source = "$a:1" },
    .{ .key = "cst", .source = "" },
    .{ .key = "jl", .source = "x=1" },
    .{ .key = "hs", .source = "x=1" },
    .{ .key = "cyberchef", .source = "" },
    .{ .key = "js", .source = "1" },
    .{ .key = "json", .source = "1" },
    .{ .key = "cpp", .source = "int a;" },
    .{ .key = "rb", .source = "x=1" },
    .{ .key = "go", .source = "package p" },
    .{ .key = "cs", .source = "class A{}" },
    .{ .key = "py", .source = "x=1" },
    .{ .key = "rs", .source = "fn f(){}" },
    .{ .key = "sh", .source = "true" },
    .{ .key = "java", .source = "class A{}" },
    .{ .key = "scala", .source = "class A" },
    .{ .key = "agda", .source = "" },
    .{ .key = "html", .source = "<p>" },
    .{ .key = "embedded_template", .source = "" },
    .{ .key = "regex", .source = "a" },
    .{ .key = "css", .source = "a{}" },
    .{ .key = "jsdoc", .source = "/** */" },
    .{ .key = "ql", .source = "" },
};

comptime {
    @setEvalBranchQuota(30000);
    for (parse_entries) |e| {
        if (!grammars.languages.has(e.key)) @compileError("unknown lang: " ++ e.key);
    }
    for (query_entries) |e| {
        if (!queries_mod.queries.has(e.key)) @compileError("unknown query: " ++ e.key);
    }
}

test "parse all languages" {
    try runParseTest(parse_entries);
}

test "execute highlight queries" {
    try runQueryTest(query_entries);
}
