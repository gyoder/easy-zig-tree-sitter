const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mod = b.addModule("eazy_zig_tree_sitter", .{
        .root_source_file = b.path("src/root.zig"),
    });

    const exe = b.addExecutable(.{
        .name = "eazy_zig_tree_sitter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "eazy_zig_tree_sitter", .module = mod },
            },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const tree_sitter = b.dependency("tree_sitter", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("tree-sitter", tree_sitter.module("tree_sitter"));
    mod.addImport("tree-sitter", tree_sitter.module("tree_sitter"));

    const use_all_langs = b.option(bool, "use_all_langs", "Build and Include all language grammars") orelse true;
    const use_langs = b.option([]const []const u8, "use_langs", "List of langs to build (ie. `md`, `c`, `zig`)") orelse &[_][]const u8{};

    var gb = GrammarBuilder{
        .b = b,
        .mod = mod,
        .target = target,
        .optimize = optimize,
        .use_all_langs = use_all_langs,
        .use_langs = use_langs,
    };

    // ========================
    // Add Grammar Dependencies
    // ========================

    const ts_c = b.dependency("tree_sitter_c", .{});
    gb.addGrammarChecked(ts_c, "", "c", "tree_sitter_c", false, "queries/highlights.scm");

    const ts_md = b.dependency("tree_sitter_markdown", .{});
    gb.addGrammarChecked(ts_md, "tree-sitter-markdown", "md", "tree_sitter_markdown", true, "queries/highlights.scm");
    gb.addGrammarChecked(ts_md, "tree-sitter-markdown-inline", "md_inline", "tree_sitter_markdown_inline", true, "queries/highlights.scm");

    const ts_lua = b.dependency("tree_sitter_lua", .{});
    gb.addGrammarChecked(ts_lua, "", "lua", "tree_sitter_lua", true, "queries/highlights.scm");

    mod.addImport("grammars", gb.buildGrammarsModule());
    mod.addImport("queries", gb.buildQueriesModule());
}

const GrammarEntry = struct {
    key: []const u8,
    symbol: []const u8,
};

const QueryEntry = struct {
    key: []const u8,
    module: *std.Build.Module,
};

const GrammarBuilder = struct {
    b: *std.Build,
    mod: *std.Build.Module,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    grammars: std.ArrayList(GrammarEntry) = .empty,
    queries: std.ArrayList(QueryEntry) = .empty,
    grammars_module: ?*std.Build.Module = null,
    queries_module: ?*std.Build.Module = null,
    use_all_langs: bool,
    use_langs: []const []const u8,

    fn addGrammarChecked(
        self: *GrammarBuilder,
        dep: *std.Build.Dependency,
        subdir: []const u8,
        key: []const u8,
        symbol: []const u8,
        has_scanner: bool,
        embed_query: ?[]const u8,
    ) void {
        if (self.use_all_langs or
            for (self.use_langs) |lang| {
                if (std.mem.eql(u8, lang, key)) break true;
            } else false)
        {
            self.addGrammar(
                dep,
                subdir,
                key,
                symbol,
                has_scanner,
                embed_query,
            );
        }
    }

    fn addGrammar(
        self: *GrammarBuilder,
        dep: *std.Build.Dependency,
        subdir: []const u8,
        key: []const u8,
        symbol: []const u8,
        has_scanner: bool,
        embed_query: ?[]const u8,
    ) void {
        const b = self.b;
        const src_dir = if (subdir.len == 0) dep.path("src") else dep.path(b.pathJoin(&.{ subdir, "src" }));

        const lib = b.addLibrary(.{
            .name = symbol,
            .linkage = .static,
            .root_module = b.createModule(.{
                .target = self.target,
                .optimize = self.optimize,
                .link_libc = true,
            }),
        });
        const files: []const []const u8 = if (has_scanner) &.{ "parser.c", "scanner.c" } else &.{"parser.c"};
        lib.root_module.addCSourceFiles(.{
            .root = src_dir,
            .files = files,
            .flags = &.{"-std=c11"},
        });
        lib.root_module.addIncludePath(src_dir);
        self.mod.linkLibrary(lib);

        if (embed_query) |query_rel_path| {
            const full_query_path = if (subdir.len == 0) dep.path(query_rel_path) else dep.path(b.pathJoin(&.{ subdir, query_rel_path }));
            const query_mod = b.createModule(.{ .root_source_file = full_query_path });
            self.queries.append(b.allocator, .{ .key = key, .module = query_mod }) catch @panic("OOM");
        }

        self.grammars.append(b.allocator, .{ .key = key, .symbol = symbol }) catch @panic("OOM");
    }

    /// makes the `grammar` submodule
    fn buildGrammarsModule(self: *GrammarBuilder) *std.Build.Module {
        if (self.grammars_module) |m| return m;
        const b = self.b;
        const tree_sitter = b.dependency("tree_sitter", .{ .target = self.target, .optimize = self.optimize });

        var src: std.ArrayList(u8) = .empty;
        src.appendSlice(b.allocator, "const std = @import(\"std\");\nconst ts = @import(\"tree-sitter\");\n\n") catch @panic("OOM");
        for (self.grammars.items) |g| {
            src.appendSlice(b.allocator, b.fmt(
                "pub extern fn {s}() callconv(.c) *ts.Language;\n",
                .{g.symbol},
            )) catch @panic("OOM");
        }
        src.appendSlice(b.allocator, "\npub const languages = std.StaticStringMap(*const fn () callconv(.c) *ts.Language).initComptime(.{\n") catch @panic("OOM");
        for (self.grammars.items) |g| {
            src.appendSlice(b.allocator, b.fmt(
                "    .{{ \"{s}\", {s} }},\n",
                .{ g.key, g.symbol },
            )) catch @panic("OOM");
        }
        src.appendSlice(b.allocator, "});\n") catch @panic("OOM");

        const wf = b.addWriteFiles();
        self.grammars_module = b.createModule(.{
            .root_source_file = wf.add("grammars.zig", src.items),
            .imports = &.{
                .{ .name = "tree-sitter", .module = tree_sitter.module("tree_sitter") },
            },
        });
        return self.grammars_module.?;
    }

    /// makes the `queries` sub module
    fn buildQueriesModule(self: *GrammarBuilder) *std.Build.Module {
        if (self.queries_module) |m| return m;
        const b = self.b;

        var src: std.ArrayList(u8) = .empty;
        for (self.queries.items) |q| {
            src.appendSlice(b.allocator, b.fmt(
                "pub const {s}_query = @embedFile(\"{s}_query\");\n",
                .{ q.key, q.key },
            )) catch @panic("OOM");
        }
        src.appendSlice(b.allocator, "\npub const queries = @import(\"std\").StaticStringMap([]const u8).initComptime(.{\n") catch @panic("OOM");
        for (self.queries.items) |q| {
            src.appendSlice(b.allocator, b.fmt(
                "    .{{ \"{s}\", {s}_query }},\n",
                .{ q.key, q.key },
            )) catch @panic("OOM");
        }
        src.appendSlice(b.allocator, "});\n") catch @panic("OOM");

        var imports: std.ArrayList(std.Build.Module.Import) = .empty;
        for (self.queries.items) |q| {
            imports.append(b.allocator, .{ .name = b.fmt("{s}_query", .{q.key}), .module = q.module }) catch @panic("OOM");
        }

        const wf = b.addWriteFiles();
        self.queries_module = b.createModule(.{
            .root_source_file = wf.add("queries.zig", src.items),
            .imports = imports.items,
        });
        return self.queries_module.?;
    }
};
