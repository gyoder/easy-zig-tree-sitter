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

    const use_third_party = b.option(bool, "use_third_party", "Include third-party community grammars (not from tree-sitter or tree-sitter-grammars orgs)") orelse false;

    var gb = GrammarBuilder{
        .b = b,
        .mod = mod,
        .target = target,
        .optimize = optimize,
        .use_all_langs = use_all_langs,
        .use_langs = use_langs,
        .use_third_party = use_third_party,
    };

    // ========================
    // Add Grammar Dependencies
    // ========================

    const ts_c = b.dependency("tree_sitter_c", .{});
    const _h0 = gb.addGrammarChecked(ts_c, "", "c", "tree_sitter_c", false);
    _h0.addQuery("highlights", "queries/highlights.scm");
    _h0.addQuery("tags", "queries/tags.scm");

    const ts_md = b.dependency("tree_sitter_markdown", .{});
    const _h1 = gb.addGrammarChecked(ts_md, "tree-sitter-markdown", "md", "tree_sitter_markdown", true);
    _h1.addQuery("highlights", "tree-sitter-markdown/queries/highlights.scm");
    _h1.addQuery("injections", "tree-sitter-markdown/queries/injections.scm");
    const _h2 = gb.addGrammarChecked(ts_md, "tree-sitter-markdown-inline", "md_inline", "tree_sitter_markdown_inline", true);
    _h2.addQuery("highlights", "tree-sitter-markdown-inline/queries/highlights.scm");
    _h2.addQuery("injections", "tree-sitter-markdown-inline/queries/injections.scm");

    const ts_lua = b.dependency("tree_sitter_lua", .{});
    const _h3 = gb.addGrammarChecked(ts_lua, "", "lua", "tree_sitter_lua", true);
    _h3.addQuery("highlights", "queries/highlights.scm");
    _h3.addQuery("injections", "queries/injections.scm");
    _h3.addQuery("locals", "queries/locals.scm");
    _h3.addQuery("tags", "queries/tags.scm");

    const ts_query = b.dependency("tree_sitter_query", .{});
    const _gq = gb.addGrammarChecked(ts_query, "", "query", "tree_sitter_query", false);
    _gq.addQuery("highlights", "queries/query/highlights.scm");
    _gq.addQuery("folds", "queries/query/folds.scm");
    _gq.addQuery("injections", "queries/query/injections.scm");

    const ts_commonlisp = b.dependency("tree_sitter_commonlisp", .{});
    const _h_commonlisp = gb.addGrammarChecked(ts_commonlisp, "", "lisp", "tree_sitter_commonlisp", false);
    _h_commonlisp.addQuery("tags", "queries/tags.scm");

    const ts_hcl = b.dependency("tree_sitter_hcl", .{});
    _ = gb.addGrammarChecked(ts_hcl, "dialects/terraform", "tf", "tree_sitter_terraform", true);
    _ = gb.addGrammarChecked(ts_hcl, "", "hcl", "tree_sitter_hcl", true);

    const ts_cuda = b.dependency("tree_sitter_cuda", .{});
    const _h179 = gb.addGrammarChecked(ts_cuda, "", "cuda", "tree_sitter_cuda", true);
    _h179.addQuery("highlights", "queries/highlights.scm");

    const ts_glsl = b.dependency("tree_sitter_glsl", .{});
    const _h180 = gb.addGrammarChecked(ts_glsl, "", "glsl", "tree_sitter_glsl", false);
    _h180.addQuery("highlights", "queries/highlights.scm");

    const ts_diff = b.dependency("tree_sitter_diff", .{});
    const _h4 = gb.addGrammarChecked(ts_diff, "", "diff", "tree_sitter_diff", false);
    _h4.addQuery("highlights", "queries/highlights.scm");
    _h4.addQuery("injections", "queries/injections.scm");

    const ts_hlsl = b.dependency("tree_sitter_hlsl", .{});
    _ = gb.addGrammarChecked(ts_hlsl, "", "hlsl", "tree_sitter_hlsl", true);

    const ts_ungrammar = b.dependency("tree_sitter_ungrammar", .{});
    const _h5 = gb.addGrammarChecked(ts_ungrammar, "", "ungrammar", "tree_sitter_ungrammar", false);
    _h5.addQuery("highlights", "queries/highlights.scm");
    _h5.addQuery("injections", "queries/injections.scm");
    _h5.addQuery("folds", "queries/folds.scm");
    _h5.addQuery("indents", "queries/indents.scm");
    _h5.addQuery("locals", "queries/locals.scm");

    const ts_thrift = b.dependency("tree_sitter_thrift", .{});
    const _h6 = gb.addGrammarChecked(ts_thrift, "", "thrift", "tree_sitter_thrift", false);
    _h6.addQuery("highlights", "queries/highlights.scm");
    _h6.addQuery("injections", "queries/injections.scm");
    _h6.addQuery("folds", "queries/folds.scm");
    _h6.addQuery("indents", "queries/indents.scm");
    _h6.addQuery("locals", "queries/locals.scm");

    const ts_meson = b.dependency("tree_sitter_meson", .{});
    const _h7 = gb.addGrammarChecked(ts_meson, "", "meson", "tree_sitter_meson", false);
    _h7.addQuery("highlights", "queries/highlights.scm");
    _h7.addQuery("folds", "queries/folds.scm");

    const ts_gitattributes = b.dependency("tree_sitter_gitattributes", .{});
    const _h181 = gb.addGrammarChecked(ts_gitattributes, "", "gitattributes", "tree_sitter_gitattributes", false);
    _h181.addQuery("highlights", "queries/highlights.scm");

    const ts_pymanifest = b.dependency("tree_sitter_pymanifest", .{});
    const _h182 = gb.addGrammarChecked(ts_pymanifest, "", "pymanifest", "tree_sitter_pymanifest", false);
    _h182.addQuery("highlights", "queries/highlights.scm");

    const ts_poe_filter = b.dependency("tree_sitter_poe_filter", .{});
    const _h183 = gb.addGrammarChecked(ts_poe_filter, "", "poe_filter", "tree_sitter_poe_filter", false);
    _h183.addQuery("highlights", "queries/highlights.scm");

    const ts_tcl = b.dependency("tree_sitter_tcl", .{});
    const _h8 = gb.addGrammarChecked(ts_tcl, "", "tcl", "tree_sitter_tcl", true);
    _h8.addQuery("highlights", "queries/tcl/highlights.scm");
    _h8.addQuery("folds", "queries/tcl/folds.scm");
    _h8.addQuery("indents", "queries/tcl/indents.scm");

    const ts_chatito = b.dependency("tree_sitter_chatito", .{});
    const _h9 = gb.addGrammarChecked(ts_chatito, "extensions/chatl", "chatl", "tree_sitter_chatl", false);
    _h9.addQuery("highlights", "queries/highlights.scm");
    _h9.addQuery("tags", "queries/tags.scm");
    const _h10 = gb.addGrammarChecked(ts_chatito, "", "chatito", "tree_sitter_chatito", false);
    _h10.addQuery("highlights", "queries/highlights.scm");
    _h10.addQuery("tags", "queries/tags.scm");

    const ts_arduino = b.dependency("tree_sitter_arduino", .{});
    const _h11 = gb.addGrammarChecked(ts_arduino, "", "ino", "tree_sitter_arduino", true);
    _h11.addQuery("highlights", "queries/highlights.scm");
    _h11.addQuery("tags", "queries/tags.scm");

    const ts_wgsl_bevy = b.dependency("tree_sitter_wgsl_bevy", .{});
    _ = gb.addGrammarChecked(ts_wgsl_bevy, "", "wgsl_bevy", "tree_sitter_wgsl_bevy", true);

    const ts_capnp = b.dependency("tree_sitter_capnp", .{});
    const _h12 = gb.addGrammarChecked(ts_capnp, "", "capnp", "tree_sitter_capnp", false);
    _h12.addQuery("highlights", "queries/highlights.scm");
    _h12.addQuery("injections", "queries/injections.scm");
    _h12.addQuery("folds", "queries/folds.scm");
    _h12.addQuery("indents", "queries/indents.scm");
    _h12.addQuery("locals", "queries/locals.scm");

    const ts_kdl = b.dependency("tree_sitter_kdl", .{});
    const _h13 = gb.addGrammarChecked(ts_kdl, "", "kdl", "tree_sitter_kdl", true);
    _h13.addQuery("highlights", "queries/highlights.scm");
    _h13.addQuery("injections", "queries/injections.scm");
    _h13.addQuery("folds", "queries/folds.scm");
    _h13.addQuery("indents", "queries/indents.scm");
    _h13.addQuery("locals", "queries/locals.scm");

    const ts_func = b.dependency("tree_sitter_func", .{});
    const _h184 = gb.addGrammarChecked(ts_func, "", "func", "tree_sitter_func", false);
    _h184.addQuery("highlights", "queries/highlights.scm");

    const ts_move = b.dependency("tree_sitter_move", .{});
    _ = gb.addGrammarChecked(ts_move, "", "move", "tree_sitter_move", false);

    const ts_go_sum = b.dependency("tree_sitter_go_sum", .{});
    const _h185 = gb.addGrammarChecked(ts_go_sum, "", "gosum", "tree_sitter_gosum", false);
    _h185.addQuery("highlights", "queries/highlights.scm");

    const ts_ron = b.dependency("tree_sitter_ron", .{});
    const _h14 = gb.addGrammarChecked(ts_ron, "", "ron", "tree_sitter_ron", true);
    _h14.addQuery("highlights", "queries/highlights.scm");
    _h14.addQuery("injections", "queries/injections.scm");
    _h14.addQuery("folds", "queries/folds.scm");
    _h14.addQuery("indents", "queries/indents.scm");
    _h14.addQuery("locals", "queries/locals.scm");

    const ts_po = b.dependency("tree_sitter_po", .{});
    const _h15 = gb.addGrammarChecked(ts_po, "", "po", "tree_sitter_po", false);
    _h15.addQuery("highlights", "queries/highlights.scm");
    _h15.addQuery("injections", "queries/injections.scm");
    _h15.addQuery("folds", "queries/folds.scm");

    const ts_starlark = b.dependency("tree_sitter_starlark", .{});
    const _h16 = gb.addGrammarChecked(ts_starlark, "", "starlark", "tree_sitter_starlark", true);
    _h16.addQuery("highlights", "queries/highlights.scm");
    _h16.addQuery("injections", "queries/injections.scm");
    _h16.addQuery("folds", "queries/folds.scm");
    _h16.addQuery("indents", "queries/indents.scm");
    _h16.addQuery("locals", "queries/locals.scm");

    const ts_yuck = b.dependency("tree_sitter_yuck", .{});
    const _h17 = gb.addGrammarChecked(ts_yuck, "", "yuck", "tree_sitter_yuck", true);
    _h17.addQuery("highlights", "queries/highlights.scm");
    _h17.addQuery("injections", "queries/injections.scm");
    _h17.addQuery("folds", "queries/folds.scm");
    _h17.addQuery("indents", "queries/indents.scm");
    _h17.addQuery("locals", "queries/locals.scm");

    const ts_smali = b.dependency("tree_sitter_smali", .{});
    const _h18 = gb.addGrammarChecked(ts_smali, "", "smali", "tree_sitter_smali", true);
    _h18.addQuery("highlights", "queries/highlights.scm");
    _h18.addQuery("injections", "queries/injections.scm");
    _h18.addQuery("folds", "queries/folds.scm");
    _h18.addQuery("indents", "queries/indents.scm");
    _h18.addQuery("locals", "queries/locals.scm");

    const ts_bicep = b.dependency("tree_sitter_bicep", .{});
    const _h19 = gb.addGrammarChecked(ts_bicep, "", "bicep", "tree_sitter_bicep", true);
    _h19.addQuery("highlights", "queries/highlights.scm");
    _h19.addQuery("injections", "queries/injections.scm");
    _h19.addQuery("folds", "queries/folds.scm");
    _h19.addQuery("indents", "queries/indents.scm");
    _h19.addQuery("locals", "queries/locals.scm");

    const ts_cpon = b.dependency("tree_sitter_cpon", .{});
    const _h20 = gb.addGrammarChecked(ts_cpon, "", "cpon", "tree_sitter_cpon", false);
    _h20.addQuery("highlights", "queries/highlights.scm");
    _h20.addQuery("injections", "queries/injections.scm");
    _h20.addQuery("folds", "queries/folds.scm");
    _h20.addQuery("indents", "queries/indents.scm");
    _h20.addQuery("locals", "queries/locals.scm");

    const ts_firrtl = b.dependency("tree_sitter_firrtl", .{});
    const _h21 = gb.addGrammarChecked(ts_firrtl, "", "firrtl", "tree_sitter_firrtl", true);
    _h21.addQuery("highlights", "queries/highlights.scm");
    _h21.addQuery("injections", "queries/injections.scm");
    _h21.addQuery("folds", "queries/folds.scm");
    _h21.addQuery("indents", "queries/indents.scm");
    _h21.addQuery("locals", "queries/locals.scm");

    const ts_luap = b.dependency("tree_sitter_luap", .{});
    const _h186 = gb.addGrammarChecked(ts_luap, "", "luap", "tree_sitter_luap", false);
    _h186.addQuery("highlights", "queries/highlights.scm");

    const ts_squirrel = b.dependency("tree_sitter_squirrel", .{});
    const _h22 = gb.addGrammarChecked(ts_squirrel, "", "squirrel", "tree_sitter_squirrel", true);
    _h22.addQuery("highlights", "queries/highlights.scm");
    _h22.addQuery("injections", "queries/injections.scm");
    _h22.addQuery("folds", "queries/folds.scm");
    _h22.addQuery("indents", "queries/indents.scm");
    _h22.addQuery("locals", "queries/locals.scm");

    const ts_uxntal = b.dependency("tree_sitter_uxntal", .{});
    const _h23 = gb.addGrammarChecked(ts_uxntal, "", "uxntal", "tree_sitter_uxntal", true);
    _h23.addQuery("highlights", "queries/highlights.scm");
    _h23.addQuery("injections", "queries/injections.scm");
    _h23.addQuery("folds", "queries/folds.scm");
    _h23.addQuery("indents", "queries/indents.scm");
    _h23.addQuery("locals", "queries/locals.scm");

    const ts_cairo = b.dependency("tree_sitter_cairo", .{});
    const _h24 = gb.addGrammarChecked(ts_cairo, "", "cairo", "tree_sitter_cairo", true);
    _h24.addQuery("highlights", "queries/highlights.scm");
    _h24.addQuery("injections", "queries/injections.scm");
    _h24.addQuery("folds", "queries/folds.scm");
    _h24.addQuery("indents", "queries/indents.scm");
    _h24.addQuery("locals", "queries/locals.scm");

    const ts_odin = b.dependency("tree_sitter_odin", .{});
    const _h25 = gb.addGrammarChecked(ts_odin, "", "odin", "tree_sitter_odin", true);
    _h25.addQuery("highlights", "queries/highlights.scm");
    _h25.addQuery("injections", "queries/injections.scm");
    _h25.addQuery("folds", "queries/folds.scm");
    _h25.addQuery("indents", "queries/indents.scm");
    _h25.addQuery("locals", "queries/locals.scm");

    const ts_hare = b.dependency("tree_sitter_hare", .{});
    const _h26 = gb.addGrammarChecked(ts_hare, "", "hare", "tree_sitter_hare", false);
    _h26.addQuery("highlights", "queries/highlights.scm");
    _h26.addQuery("injections", "queries/injections.scm");
    _h26.addQuery("folds", "queries/folds.scm");
    _h26.addQuery("indents", "queries/indents.scm");
    _h26.addQuery("locals", "queries/locals.scm");

    const ts_pony = b.dependency("tree_sitter_pony", .{});
    const _h27 = gb.addGrammarChecked(ts_pony, "", "pony", "tree_sitter_pony", true);
    _h27.addQuery("highlights", "queries/highlights.scm");
    _h27.addQuery("injections", "queries/injections.scm");
    _h27.addQuery("folds", "queries/folds.scm");
    _h27.addQuery("indents", "queries/indents.scm");
    _h27.addQuery("locals", "queries/locals.scm");
    _h27.addQuery("tags", "queries/tags.scm");

    const ts_tablegen = b.dependency("tree_sitter_tablegen", .{});
    const _h28 = gb.addGrammarChecked(ts_tablegen, "", "tablegen", "tree_sitter_tablegen", true);
    _h28.addQuery("highlights", "queries/highlights.scm");
    _h28.addQuery("injections", "queries/injections.scm");
    _h28.addQuery("folds", "queries/folds.scm");
    _h28.addQuery("indents", "queries/indents.scm");
    _h28.addQuery("locals", "queries/locals.scm");

    const ts_luadoc = b.dependency("tree_sitter_luadoc", .{});
    const _h187 = gb.addGrammarChecked(ts_luadoc, "", "luadoc", "tree_sitter_luadoc", false);
    _h187.addQuery("highlights", "queries/highlights.scm");

    const ts_kotlin = b.dependency("tree_sitter_kotlin", .{});
    _ = gb.addGrammarChecked(ts_kotlin, "", "kt", "tree_sitter_kotlin", true);

    const ts_vim = b.dependency("tree_sitter_vim", .{});
    const _h29 = gb.addGrammarChecked(ts_vim, "", "vim", "tree_sitter_vim", true);
    _h29.addQuery("highlights", "queries/vim/highlights.scm");
    _h29.addQuery("injections", "queries/vim/injections.scm");
    _h29.addQuery("folds", "queries/vim/folds.scm");

    const ts_puppet = b.dependency("tree_sitter_puppet", .{});
    const _h30 = gb.addGrammarChecked(ts_puppet, "", "puppet", "tree_sitter_puppet", false);
    _h30.addQuery("highlights", "queries/highlights.scm");
    _h30.addQuery("injections", "queries/injections.scm");
    _h30.addQuery("folds", "queries/folds.scm");
    _h30.addQuery("indents", "queries/indents.scm");
    _h30.addQuery("locals", "queries/locals.scm");

    const ts_luau = b.dependency("tree_sitter_luau", .{});
    const _h31 = gb.addGrammarChecked(ts_luau, "", "luau", "tree_sitter_luau", true);
    _h31.addQuery("highlights", "queries/highlights.scm");
    _h31.addQuery("injections", "queries/injections.scm");
    _h31.addQuery("folds", "queries/folds.scm");
    _h31.addQuery("indents", "queries/indents.scm");
    _h31.addQuery("locals", "queries/locals.scm");

    const ts_objc = b.dependency("tree_sitter_objc", .{});
    const _h32 = gb.addGrammarChecked(ts_objc, "", "objc", "tree_sitter_objc", false);
    _h32.addQuery("highlights", "queries/highlights.scm");
    _h32.addQuery("injections", "queries/injections.scm");
    _h32.addQuery("folds", "queries/folds.scm");
    _h32.addQuery("indents", "queries/indents.scm");
    _h32.addQuery("locals", "queries/locals.scm");

    const ts_ispc = b.dependency("tree_sitter_ispc", .{});
    const _h33 = gb.addGrammarChecked(ts_ispc, "", "ispc", "tree_sitter_ispc", false);
    _h33.addQuery("highlights", "queries/highlights.scm");
    _h33.addQuery("injections", "queries/injections.scm");

    const ts_pem = b.dependency("tree_sitter_pem", .{});
    const _h188 = gb.addGrammarChecked(ts_pem, "", "pem", "tree_sitter_pem", false);
    _h188.addQuery("highlights", "queries/highlights.scm");

    const ts_requirements = b.dependency("tree_sitter_requirements", .{});
    const _h189 = gb.addGrammarChecked(ts_requirements, "", "requirements", "tree_sitter_requirements", false);
    _h189.addQuery("highlights", "queries/highlights.scm");

    const ts_xml = b.dependency("tree_sitter_xml", .{});
    const _h190 = gb.addGrammarChecked(ts_xml, "dtd", "dtd", "tree_sitter_dtd", true);
    _h190.addQuery("highlights", "queries/dtd/highlights.scm");
    const _h191 = gb.addGrammarChecked(ts_xml, "xml", "xml", "tree_sitter_xml", true);
    _h191.addQuery("highlights", "queries/xml/highlights.scm");

    const ts_gpg_config = b.dependency("tree_sitter_gpg_config", .{});
    const _h192 = gb.addGrammarChecked(ts_gpg_config, "", "gpg", "tree_sitter_gpg", false);
    _h192.addQuery("highlights", "queries/highlights.scm");

    const ts_bitbake = b.dependency("tree_sitter_bitbake", .{});
    const _h34 = gb.addGrammarChecked(ts_bitbake, "", "bb", "tree_sitter_bitbake", true);
    _h34.addQuery("highlights", "queries/highlights.scm");
    _h34.addQuery("injections", "queries/injections.scm");
    _h34.addQuery("folds", "queries/folds.scm");
    _h34.addQuery("indents", "queries/indents.scm");
    _h34.addQuery("locals", "queries/locals.scm");

    const ts_csv = b.dependency("tree_sitter_csv", .{});
    const _h193 = gb.addGrammarChecked(ts_csv, "csv", "csv", "tree_sitter_csv", false);
    _h193.addQuery("highlights", "csv/queries/highlights.scm");
    const _h194 = gb.addGrammarChecked(ts_csv, "psv", "psv", "tree_sitter_psv", false);
    _h194.addQuery("highlights", "psv/queries/highlights.scm");
    const _h195 = gb.addGrammarChecked(ts_csv, "tsv", "tsv", "tree_sitter_tsv", false);
    _h195.addQuery("highlights", "tsv/queries/highlights.scm");

    const ts_hyprlang = b.dependency("tree_sitter_hyprlang", .{});
    const _gh = gb.addGrammarChecked(ts_hyprlang, "", "hyprlang", "tree_sitter_hyprlang", false);
    _gh.addQuery("highlights", "queries/hyprlang/highlights.scm");
    _gh.addQuery("folds", "queries/hyprlang/folds.scm");
    _gh.addQuery("indents", "queries/hyprlang/indents.scm");
    _gh.addQuery("injections", "queries/hyprlang/injections.scm");

    const ts_printf = b.dependency("tree_sitter_printf", .{});
    const _h196 = gb.addGrammarChecked(ts_printf, "", "printf", "tree_sitter_printf", false);
    _h196.addQuery("highlights", "queries/highlights.scm");

    const ts_gstlaunch = b.dependency("tree_sitter_gstlaunch", .{});
    _ = gb.addGrammarChecked(ts_gstlaunch, "", "gstlaunch", "tree_sitter_gstlaunch", false);

    const ts_re2c = b.dependency("tree_sitter_re2c", .{});
    const _h35 = gb.addGrammarChecked(ts_re2c, "", "re2c", "tree_sitter_re2c", false);
    _h35.addQuery("highlights", "queries/highlights.scm");
    _h35.addQuery("injections", "queries/injections.scm");
    _h35.addQuery("folds", "queries/folds.scm");
    _h35.addQuery("indents", "queries/indents.scm");
    _h35.addQuery("locals", "queries/locals.scm");

    const ts_doxygen = b.dependency("tree_sitter_doxygen", .{});
    const _h36 = gb.addGrammarChecked(ts_doxygen, "", "doxygen", "tree_sitter_doxygen", true);
    _h36.addQuery("highlights", "queries/highlights.scm");
    _h36.addQuery("injections", "queries/injections.scm");
    _h36.addQuery("indents", "queries/indents.scm");

    const ts_zsh = b.dependency("tree_sitter_zsh", .{});
    _ = gb.addGrammarChecked(ts_zsh, "", "zsh", "tree_sitter_zsh", true);

    const ts_ssh_config = b.dependency("tree_sitter_ssh_config", .{});
    const _h37 = gb.addGrammarChecked(ts_ssh_config, "", "ssh_config", "tree_sitter_ssh_config", false);
    _h37.addQuery("highlights", "queries/highlights.scm");
    _h37.addQuery("injections", "queries/injections.scm");

    const ts_nqc = b.dependency("tree_sitter_nqc", .{});
    const _h38 = gb.addGrammarChecked(ts_nqc, "", "nqc", "tree_sitter_nqc", false);
    _h38.addQuery("highlights", "queries/highlights.scm");
    _h38.addQuery("injections", "queries/injections.scm");
    _h38.addQuery("folds", "queries/folds.scm");
    _h38.addQuery("indents", "queries/indents.scm");
    _h38.addQuery("locals", "queries/locals.scm");

    const ts_kconfig = b.dependency("tree_sitter_kconfig", .{});
    const _h39 = gb.addGrammarChecked(ts_kconfig, "", "kconfig", "tree_sitter_kconfig", true);
    _h39.addQuery("highlights", "queries/highlights.scm");
    _h39.addQuery("injections", "queries/injections.scm");
    _h39.addQuery("folds", "queries/folds.scm");
    _h39.addQuery("indents", "queries/indents.scm");
    _h39.addQuery("locals", "queries/locals.scm");

    const ts_gn = b.dependency("tree_sitter_gn", .{});
    const _h40 = gb.addGrammarChecked(ts_gn, "", "gn", "tree_sitter_gn", true);
    _h40.addQuery("highlights", "queries/highlights.scm");
    _h40.addQuery("injections", "queries/injections.scm");
    _h40.addQuery("folds", "queries/folds.scm");
    _h40.addQuery("indents", "queries/indents.scm");
    _h40.addQuery("locals", "queries/locals.scm");

    const ts_udev = b.dependency("tree_sitter_udev", .{});
    const _h41 = gb.addGrammarChecked(ts_udev, "", "udev", "tree_sitter_udev", false);
    _h41.addQuery("highlights", "queries/highlights.scm");
    _h41.addQuery("injections", "queries/injections.scm");
    _h41.addQuery("tags", "queries/tags.scm");

    const ts_xcompose = b.dependency("tree_sitter_xcompose", .{});
    const _h197 = gb.addGrammarChecked(ts_xcompose, "", "xcompose", "tree_sitter_xcompose", false);
    _h197.addQuery("highlights", "queries/highlights.scm");

    const ts_slang = b.dependency("tree_sitter_slang", .{});
    _ = gb.addGrammarChecked(ts_slang, "", "slang", "tree_sitter_slang", true);

    const ts_linkerscript = b.dependency("tree_sitter_linkerscript", .{});
    const _h42 = gb.addGrammarChecked(ts_linkerscript, "", "linkerscript", "tree_sitter_linkerscript", false);
    _h42.addQuery("highlights", "queries/highlights.scm");
    _h42.addQuery("injections", "queries/injections.scm");
    _h42.addQuery("folds", "queries/folds.scm");
    _h42.addQuery("indents", "queries/indents.scm");
    _h42.addQuery("locals", "queries/locals.scm");

    const ts_properties = b.dependency("tree_sitter_properties", .{});
    const _h43 = gb.addGrammarChecked(ts_properties, "", "properties", "tree_sitter_properties", true);
    _h43.addQuery("highlights", "queries/highlights.scm");
    _h43.addQuery("tags", "queries/tags.scm");

    const ts_readline = b.dependency("tree_sitter_readline", .{});
    const _h44 = gb.addGrammarChecked(ts_readline, "", "readline", "tree_sitter_readline", false);
    _h44.addQuery("highlights", "queries/highlights.scm");
    _h44.addQuery("injections", "queries/injections.scm");
    _h44.addQuery("indents", "queries/indents.scm");

    const ts_make = b.dependency("tree_sitter_make", .{});
    const _h45 = gb.addGrammarChecked(ts_make, "", "Makefile", "tree_sitter_make", false);
    _h45.addQuery("highlights", "queries/highlights.scm");
    _h45.addQuery("injections", "queries/injections.scm");
    _h45.addQuery("folds", "queries/folds.scm");

    const ts_yaml = b.dependency("tree_sitter_yaml", .{});
    const _h198 = gb.addGrammarChecked(ts_yaml, "schema/core", "core_schema", "tree_sitter_core_schema", false);
    _h198.addQuery("highlights", "queries/highlights.scm");
    const _h199 = gb.addGrammarChecked(ts_yaml, "schema/json", "json_schema", "tree_sitter_json_schema", false);
    _h199.addQuery("highlights", "queries/highlights.scm");
    const _h200 = gb.addGrammarChecked(ts_yaml, "schema/legacy", "legacy_schema", "tree_sitter_legacy_schema", false);
    _h200.addQuery("highlights", "queries/highlights.scm");
    const _h201 = gb.addGrammarChecked(ts_yaml, "", "yaml", "tree_sitter_yaml", true);
    _h201.addQuery("highlights", "queries/highlights.scm");

    const ts_toml = b.dependency("tree_sitter_toml", .{});
    const _h202 = gb.addGrammarChecked(ts_toml, "", "toml", "tree_sitter_toml", true);
    _h202.addQuery("highlights", "queries/highlights.scm");

    const ts_vue = b.dependency("tree_sitter_vue", .{});
    const _h46 = gb.addGrammarChecked(ts_vue, "", "vue", "tree_sitter_vue", true);
    _h46.addQuery("highlights", "queries/vue/highlights.scm");
    _h46.addQuery("injections", "queries/vue/injections.scm");
    _h46.addQuery("folds", "queries/vue/folds.scm");
    _h46.addQuery("indents", "queries/vue/indents.scm");

    const ts_qmldir = b.dependency("tree_sitter_qmldir", .{});
    const _h47 = gb.addGrammarChecked(ts_qmldir, "", "qmldir", "tree_sitter_qmldir", false);
    _h47.addQuery("highlights", "queries/highlights.scm");
    _h47.addQuery("injections", "queries/injections.scm");

    const ts_zig = b.dependency("fork_zig", .{});
    const _h48 = gb.addGrammarChecked(ts_zig, "", "zig", "tree_sitter_zig", false);
    _h48.addQuery("highlights", "queries/highlights.scm");
    _h48.addQuery("injections", "queries/injections.scm");
    _h48.addQuery("folds", "queries/folds.scm");
    _h48.addQuery("indents", "queries/indents.scm");
    _h48.addQuery("locals", "queries/locals.scm");

    const ts_svelte = b.dependency("tree_sitter_svelte", .{});
    const _h49 = gb.addGrammarChecked(ts_svelte, "", "svelte", "tree_sitter_svelte", true);
    _h49.addQuery("highlights", "queries/highlights.scm");
    _h49.addQuery("injections", "queries/injections.scm");
    _h49.addQuery("folds", "queries/folds.scm");
    _h49.addQuery("indents", "queries/indents.scm");
    _h49.addQuery("locals", "queries/locals.scm");

    const ts_test = b.dependency("tree_sitter_test", .{});
    const _h50 = gb.addGrammarChecked(ts_test, "", "test", "tree_sitter_test", true);
    _h50.addQuery("highlights", "queries/test/highlights.scm");
    _h50.addQuery("injections", "queries/test/injections.scm");
    _h50.addQuery("folds", "queries/test/folds.scm");

    const ts_scss = b.dependency("tree_sitter_scss", .{});
    const _h203 = gb.addGrammarChecked(ts_scss, "", "scss", "tree_sitter_scss", true);
    _h203.addQuery("highlights", "queries/highlights.scm");

    const ts_cst = b.dependency("tree_sitter_cst", .{});
    const _h204 = gb.addGrammarChecked(ts_cst, "", "cst", "tree_sitter_cst", false);
    _h204.addQuery("highlights", "queries/highlights.scm");

    const ts_julia = b.dependency("tree_sitter_julia", .{});
    const _h51 = gb.addGrammarChecked(ts_julia, "", "jl", "tree_sitter_julia", true);
    _h51.addQuery("highlights", "queries/highlights.scm");
    _h51.addQuery("injections", "queries/injections.scm");
    _h51.addQuery("locals", "queries/locals.scm");

    const ts_haskell = b.dependency("tree_sitter_haskell", .{});
    const _h52 = gb.addGrammarChecked(ts_haskell, "", "haskell", "tree_sitter_haskell", true);
    _h52.addQuery("highlights", "queries/highlights.scm");
    _h52.addQuery("injections", "queries/injections.scm");
    _h52.addQuery("locals", "queries/locals.scm");

    const ts_cyberchef = b.dependency("tree_sitter_cyberchef", .{});
    const _h205 = gb.addGrammarChecked(ts_cyberchef, "", "cyberchef", "tree_sitter_cyberchef", false);
    _h205.addQuery("highlights", "queries/highlights.scm");

    const ts_javascript = b.dependency("tree_sitter_javascript", .{});
    const _h53 = gb.addGrammarChecked(ts_javascript, "", "js", "tree_sitter_javascript", true);
    _h53.addQuery("highlights", "queries/highlights.scm");
    _h53.addQuery("injections", "queries/injections.scm");
    _h53.addQuery("locals", "queries/locals.scm");
    _h53.addQuery("tags", "queries/tags.scm");

    const ts_json = b.dependency("tree_sitter_json", .{});
    const _h206 = gb.addGrammarChecked(ts_json, "", "json", "tree_sitter_json", false);
    _h206.addQuery("highlights", "queries/highlights.scm");

    const ts_cpp = b.dependency("tree_sitter_cpp", .{});
    const _h54 = gb.addGrammarChecked(ts_cpp, "", "cpp", "tree_sitter_cpp", true);
    _h54.addQuery("highlights", "queries/highlights.scm");
    _h54.addQuery("injections", "queries/injections.scm");
    _h54.addQuery("tags", "queries/tags.scm");

    const ts_ruby = b.dependency("tree_sitter_ruby", .{});
    const _h55 = gb.addGrammarChecked(ts_ruby, "", "rb", "tree_sitter_ruby", true);
    _h55.addQuery("highlights", "queries/highlights.scm");
    _h55.addQuery("locals", "queries/locals.scm");
    _h55.addQuery("tags", "queries/tags.scm");

    const ts_go = b.dependency("tree_sitter_go", .{});
    const _h56 = gb.addGrammarChecked(ts_go, "", "go", "tree_sitter_go", false);
    _h56.addQuery("highlights", "queries/highlights.scm");
    _h56.addQuery("tags", "queries/tags.scm");

    const ts_c_sharp = b.dependency("tree_sitter_c_sharp", .{});
    const _h57 = gb.addGrammarChecked(ts_c_sharp, "", "cs", "tree_sitter_c_sharp", true);
    _h57.addQuery("highlights", "queries/highlights.scm");
    _h57.addQuery("tags", "queries/tags.scm");

    const ts_python = b.dependency("tree_sitter_python", .{});
    const _h58 = gb.addGrammarChecked(ts_python, "", "py", "tree_sitter_python", true);
    _h58.addQuery("highlights", "queries/highlights.scm");
    _h58.addQuery("tags", "queries/tags.scm");

    const ts_typescript = b.dependency("tree_sitter_typescript", .{});
    const _h59 = gb.addGrammarChecked(ts_typescript, "tsx", "tsx", "tree_sitter_tsx", true);
    _h59.addQuery("highlights", "queries/highlights.scm");
    _h59.addQuery("locals", "queries/locals.scm");
    _h59.addQuery("tags", "queries/tags.scm");
    const _h60 = gb.addGrammarChecked(ts_typescript, "typescript", "ts", "tree_sitter_typescript", true);
    _h60.addQuery("highlights", "queries/highlights.scm");
    _h60.addQuery("locals", "queries/locals.scm");
    _h60.addQuery("tags", "queries/tags.scm");

    const ts_rust = b.dependency("tree_sitter_rust", .{});
    const _h61 = gb.addGrammarChecked(ts_rust, "", "rs", "tree_sitter_rust", true);
    _h61.addQuery("highlights", "queries/highlights.scm");
    _h61.addQuery("injections", "queries/injections.scm");
    _h61.addQuery("tags", "queries/tags.scm");

    const ts_bash = b.dependency("tree_sitter_bash", .{});
    const _h207 = gb.addGrammarChecked(ts_bash, "", "sh", "tree_sitter_bash", true);
    _h207.addQuery("highlights", "queries/highlights.scm");

    const ts_php = b.dependency("tree_sitter_php", .{});
    const _h62 = gb.addGrammarChecked(ts_php, "php", "php", "tree_sitter_php", true);
    _h62.addQuery("highlights", "queries/highlights.scm");
    _h62.addQuery("injections", "queries/injections.scm");
    _h62.addQuery("tags", "queries/tags.scm");
    const _h63 = gb.addGrammarChecked(ts_php, "php_only", "php_only", "tree_sitter_php_only", true);
    _h63.addQuery("highlights", "queries/highlights.scm");
    _h63.addQuery("injections", "queries/injections.scm");
    _h63.addQuery("tags", "queries/tags.scm");

    const ts_java = b.dependency("tree_sitter_java", .{});
    const _h64 = gb.addGrammarChecked(ts_java, "", "java", "tree_sitter_java", false);
    _h64.addQuery("highlights", "queries/highlights.scm");
    _h64.addQuery("tags", "queries/tags.scm");

    const ts_scala = b.dependency("tree_sitter_scala", .{});
    const _h65 = gb.addGrammarChecked(ts_scala, "", "scala", "tree_sitter_scala", true);
    _h65.addQuery("highlights", "queries/highlights.scm");
    _h65.addQuery("indents", "queries/indents.scm");
    _h65.addQuery("locals", "queries/locals.scm");
    _h65.addQuery("tags", "queries/tags.scm");

    const ts_ocaml = b.dependency("tree_sitter_ocaml", .{});
    const _h66 = gb.addGrammarChecked(ts_ocaml, "grammars/interface", "mli", "tree_sitter_ocaml_interface", true);
    _h66.addQuery("highlights", "queries/highlights.scm");
    _h66.addQuery("locals", "queries/locals.scm");
    _h66.addQuery("tags", "queries/tags.scm");
    const _h67 = gb.addGrammarChecked(ts_ocaml, "grammars/ocaml", "ml", "tree_sitter_ocaml", true);
    _h67.addQuery("highlights", "queries/highlights.scm");
    _h67.addQuery("locals", "queries/locals.scm");
    _h67.addQuery("tags", "queries/tags.scm");
    const _h68 = gb.addGrammarChecked(ts_ocaml, "grammars/type", "mly", "tree_sitter_ocaml_type", true);
    _h68.addQuery("highlights", "queries/highlights.scm");
    _h68.addQuery("locals", "queries/locals.scm");
    _h68.addQuery("tags", "queries/tags.scm");

    const ts_agda = b.dependency("tree_sitter_agda", .{});
    const _h208 = gb.addGrammarChecked(ts_agda, "", "agda", "tree_sitter_agda", true);
    _h208.addQuery("highlights", "queries/highlights.scm");

    const ts_fluent = b.dependency("tree_sitter_fluent", .{});
    _ = gb.addGrammarChecked(ts_fluent, "", "fluent", "tree_sitter_fluent", true);

    const ts_html = b.dependency("tree_sitter_html", .{});
    const _h69 = gb.addGrammarChecked(ts_html, "", "html", "tree_sitter_html", true);
    _h69.addQuery("highlights", "queries/highlights.scm");
    _h69.addQuery("injections", "queries/injections.scm");

    const ts_embedded_template = b.dependency("tree_sitter_embedded_template", .{});
    const _h209 = gb.addGrammarChecked(ts_embedded_template, "", "embedded_template", "tree_sitter_embedded_template", false);
    _h209.addQuery("highlights", "queries/highlights.scm");

    const ts_regex = b.dependency("tree_sitter_regex", .{});
    const _h210 = gb.addGrammarChecked(ts_regex, "", "regex", "tree_sitter_regex", false);
    _h210.addQuery("highlights", "queries/highlights.scm");

    const ts_css = b.dependency("tree_sitter_css", .{});
    const _h211 = gb.addGrammarChecked(ts_css, "", "css", "tree_sitter_css", true);
    _h211.addQuery("highlights", "queries/highlights.scm");

    const ts_verilog = b.dependency("tree_sitter_verilog", .{});
    _ = gb.addGrammarChecked(ts_verilog, "", "v", "tree_sitter_verilog", false);

    const ts_jsdoc = b.dependency("tree_sitter_jsdoc", .{});
    const _h212 = gb.addGrammarChecked(ts_jsdoc, "", "jsdoc", "tree_sitter_jsdoc", true);
    _h212.addQuery("highlights", "queries/highlights.scm");

    const ts_ql = b.dependency("tree_sitter_ql", .{});
    const _h70 = gb.addGrammarChecked(ts_ql, "", "ql", "tree_sitter_ql", false);
    _h70.addQuery("highlights", "queries/highlights.scm");
    _h70.addQuery("tags", "queries/tags.scm");

    const ts_tsq = b.dependency("tree_sitter_tsq", .{});
    _ = gb.addGrammarChecked(ts_tsq, "", "tsq", "tree_sitter_tsq", false);

    const ts_ql_dbscheme = b.dependency("tree_sitter_ql_dbscheme", .{});
    _ = gb.addGrammarChecked(ts_ql_dbscheme, "", "ql_dbscheme", "tree_sitter_ql_dbscheme", false);

    // ============================
    // Third-Party Grammars (gated by --third-party flag)
    // ============================

    const tp_ada = b.dependency("tp_ada", .{});
    if (gb.use_third_party) {
        const _h71 = gb.addGrammarChecked(tp_ada, "", "ada", "tree_sitter_ada", false);
        _h71.addQuery("highlights", "queries/highlights.scm");
        _h71.addQuery("folds", "queries/folds.scm");
        _h71.addQuery("locals", "queries/locals.scm");
    }

    const tp_angular = b.dependency("tp_angular", .{});
    if (gb.use_third_party) {
        const _h72 = gb.addGrammarChecked(tp_angular, "", "angular", "tree_sitter_angular", true);
        _h72.addQuery("highlights", "queries/highlights.scm");
        _h72.addQuery("injections", "queries/injections.scm");
        _h72.addQuery("folds", "queries/folds.scm");
        _h72.addQuery("indents", "queries/indents.scm");
    }

    const tp_apex = b.dependency("tp_apex", .{});
    if (gb.use_third_party) {
        const _h73 = gb.addGrammarChecked(tp_apex, "apex", "apex", "tree_sitter_apex", false);
        _h73.addQuery("highlights", "apex/queries/highlights.scm");
        _h73.addQuery("locals", "apex/queries/locals.scm");
        _h73.addQuery("tags", "apex/queries/tags.scm");
    }

    const tp_asm = b.dependency("tp_asm", .{});
    if (gb.use_third_party) {
        const _h74 = gb.addGrammarChecked(tp_asm, "", "asm", "tree_sitter_asm", false);
        _h74.addQuery("highlights", "queries/asm/highlights.scm");
        _h74.addQuery("injections", "queries/asm/injections.scm");
    }

    const tp_astro = b.dependency("tp_astro", .{});
    if (gb.use_third_party) {
        const _h75 = gb.addGrammarChecked(tp_astro, "", "astro", "tree_sitter_astro", true);
        _h75.addQuery("highlights", "queries/highlights.scm");
        _h75.addQuery("injections", "queries/injections.scm");
    }

    const tp_authzed = b.dependency("tp_authzed", .{});
    if (gb.use_third_party) {
        const _h76 = gb.addGrammarChecked(tp_authzed, "", "authzed", "tree_sitter_authzed", false);
        _h76.addQuery("highlights", "queries/highlights.scm");
        _h76.addQuery("injections", "queries/injections.scm");
    }

    const tp_awk = b.dependency("tp_awk", .{});
    if (gb.use_third_party) {
        const _h213 = gb.addGrammarChecked(tp_awk, "", "awk", "tree_sitter_awk", true);
        _h213.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_bass = b.dependency("tp_bass", .{});
    if (gb.use_third_party) {
        const _h_bass = gb.addGrammarChecked(tp_bass, "", "bass", "tree_sitter_bass", false);
        _h_bass.addQuery("injections", "queries/injections.scm");
        _h_bass.addQuery("folds", "queries/folds.scm");
        _h_bass.addQuery("indents", "queries/indents.scm");
        _h_bass.addQuery("locals", "queries/locals.scm");
    }

    const tp_beancount = b.dependency("tp_beancount", .{});
    if (gb.use_third_party) {
        const _h77 = gb.addGrammarChecked(tp_beancount, "", "beancount", "tree_sitter_beancount", true);
        _h77.addQuery("highlights", "queries/highlights.scm");
        _h77.addQuery("folds", "queries/folds.scm");
        _h77.addQuery("indents", "queries/indents.scm");
        _h77.addQuery("locals", "queries/locals.scm");
        _h77.addQuery("tags", "queries/tags.scm");
    }

    const tp_bibtex = b.dependency("tp_bibtex", .{});
    if (gb.use_third_party) {
        const _h78 = gb.addGrammarChecked(tp_bibtex, "", "bibtex", "tree_sitter_bibtex", false);
        _h78.addQuery("highlights", "queries/highlights.scm");
        _h78.addQuery("locals", "queries/locals.scm");
        _h78.addQuery("tags", "queries/tags.scm");
    }

    const tp_blade = b.dependency("tp_blade", .{});
    if (gb.use_third_party) {
        const _h79 = gb.addGrammarChecked(tp_blade, "", "blade", "tree_sitter_blade", true);
        _h79.addQuery("highlights", "queries/highlights.scm");
        _h79.addQuery("injections", "queries/injections.scm");
    }

    const tp_bp = b.dependency("tp_bp", .{});
    if (gb.use_third_party) {
        const _h80 = gb.addGrammarChecked(tp_bp, "", "bp", "tree_sitter_bp", false);
        _h80.addQuery("highlights", "queries/highlights.scm");
        _h80.addQuery("injections", "queries/injections.scm");
        _h80.addQuery("folds", "queries/folds.scm");
        _h80.addQuery("indents", "queries/indents.scm");
        _h80.addQuery("locals", "queries/locals.scm");
    }

    const tp_brightscript = b.dependency("tp_brightscript", .{});
    if (gb.use_third_party) {
        const _h81 = gb.addGrammarChecked(tp_brightscript, "", "brightscript", "tree_sitter_brightscript", false);
        _h81.addQuery("highlights", "queries/highlights.scm");
        _h81.addQuery("injections", "queries/injections.scm");
        _h81.addQuery("folds", "queries/folds.scm");
        _h81.addQuery("indents", "queries/indents.scm");
    }

    const tp_caddy = b.dependency("tp_caddy", .{});
    if (gb.use_third_party) {
        const _h82 = gb.addGrammarChecked(tp_caddy, "", "caddy", "tree_sitter_caddy", true);
        _h82.addQuery("highlights", "queries/highlights.scm");
        _h82.addQuery("injections", "queries/injections.scm");
        _h82.addQuery("folds", "queries/folds.scm");
        _h82.addQuery("indents", "queries/indents.scm");
    }

    const tp_circom = b.dependency("tp_circom", .{});
    if (gb.use_third_party) {
        const _h83 = gb.addGrammarChecked(tp_circom, "", "circom", "tree_sitter_circom", false);
        _h83.addQuery("highlights", "queries/highlights.scm");
        _h83.addQuery("locals", "queries/locals.scm");
    }

    const tp_clojure = b.dependency("tp_clojure", .{});
    if (gb.use_third_party) {
        const _h214 = gb.addGrammarChecked(tp_clojure, "", "clojure", "tree_sitter_clojure", false);
        _h214.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_cmake = b.dependency("tp_cmake", .{});
    if (gb.use_third_party) {
        const _h84 = gb.addGrammarChecked(tp_cmake, "", "cmake", "tree_sitter_cmake", true);
        _h84.addQuery("highlights", "queries/highlights.scm");
        _h84.addQuery("injections", "queries/injections.scm");
        _h84.addQuery("folds", "queries/folds.scm");
        _h84.addQuery("indents", "queries/indents.scm");
    }

    const tp_comment = b.dependency("tp_comment", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_comment, "", "comment", "tree_sitter_comment", true);
    }

    const tp_cooklang = b.dependency("tp_cooklang", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_cooklang, "", "cooklang", "tree_sitter_cooklang", true);
    }

    const tp_corn = b.dependency("tp_corn", .{});
    if (gb.use_third_party) {
        const _h85 = gb.addGrammarChecked(tp_corn, "", "corn", "tree_sitter_corn", false);
        _h85.addQuery("highlights", "queries/highlights.scm");
        _h85.addQuery("folds", "queries/folds.scm");
        _h85.addQuery("indents", "queries/indents.scm");
        _h85.addQuery("locals", "queries/locals.scm");
    }

    const tp_cue = b.dependency("tp_cue", .{});
    if (gb.use_third_party) {
        const _h86 = gb.addGrammarChecked(tp_cue, "", "cue", "tree_sitter_cue", true);
        _h86.addQuery("highlights", "queries/highlights.scm");
        _h86.addQuery("injections", "queries/injections.scm");
        _h86.addQuery("folds", "queries/folds.scm");
        _h86.addQuery("indents", "queries/indents.scm");
        _h86.addQuery("locals", "queries/locals.scm");
    }

    const tp_cylc = b.dependency("tp_cylc", .{});
    if (gb.use_third_party) {
        const _h87 = gb.addGrammarChecked(tp_cylc, "", "cylc", "tree_sitter_cylc", false);
        _h87.addQuery("highlights", "queries/highlights.scm");
        _h87.addQuery("injections", "queries/injections.scm");
    }

    const tp_d = b.dependency("tp_d", .{});
    if (gb.use_third_party) {
        const _h88 = gb.addGrammarChecked(tp_d, "", "d", "tree_sitter_d", true);
        _h88.addQuery("highlights", "queries/highlights.scm");
        _h88.addQuery("injections", "queries/injections.scm");
        _h88.addQuery("indents", "queries/indents.scm");
        _h88.addQuery("tags", "queries/tags.scm");
    }

    const tp_dart = b.dependency("tp_dart", .{});
    if (gb.use_third_party) {
        const _h89 = gb.addGrammarChecked(tp_dart, "", "dart", "tree_sitter_dart", true);
        _h89.addQuery("highlights", "queries/highlights.scm");
        _h89.addQuery("tags", "queries/tags.scm");
    }

    const tp_desktop = b.dependency("tp_desktop", .{});
    if (gb.use_third_party) {
        const _h90 = gb.addGrammarChecked(tp_desktop, "", "desktop", "tree_sitter_desktop", false);
        _h90.addQuery("highlights", "queries/desktop/highlights.scm");
        _h90.addQuery("injections", "queries/desktop/injections.scm");
    }

    const tp_dhall = b.dependency("tp_dhall", .{});
    if (gb.use_third_party) {
        const _h91 = gb.addGrammarChecked(tp_dhall, "", "dhall", "tree_sitter_dhall", true);
        _h91.addQuery("highlights", "queries/highlights.scm");
        _h91.addQuery("injections", "queries/injections.scm");
    }

    const tp_disassembly = b.dependency("tp_disassembly", .{});
    if (gb.use_third_party) {
        const _h215 = gb.addGrammarChecked(tp_disassembly, "", "disassembly", "tree_sitter_disassembly", true);
        _h215.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_djot = b.dependency("tp_djot", .{});
    if (gb.use_third_party) {
        const _h92 = gb.addGrammarChecked(tp_djot, "", "djot", "tree_sitter_djot", true);
        _h92.addQuery("highlights", "queries/highlights.scm");
        _h92.addQuery("injections", "queries/injections.scm");
        _h92.addQuery("folds", "queries/folds.scm");
        _h92.addQuery("indents", "queries/indents.scm");
        _h92.addQuery("locals", "queries/locals.scm");
    }

    const tp_dockerfile = b.dependency("tp_dockerfile", .{});
    if (gb.use_third_party) {
        const _h216 = gb.addGrammarChecked(tp_dockerfile, "", "dockerfile", "tree_sitter_dockerfile", true);
        _h216.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_dot = b.dependency("tp_dot", .{});
    if (gb.use_third_party) {
        const _h93 = gb.addGrammarChecked(tp_dot, "", "dot", "tree_sitter_dot", false);
        _h93.addQuery("highlights", "queries/highlights.scm");
        _h93.addQuery("injections", "queries/injections.scm");
    }

    const tp_earthfile = b.dependency("tp_earthfile", .{});
    if (gb.use_third_party) {
        const _h94 = gb.addGrammarChecked(tp_earthfile, "", "earthfile", "tree_sitter_earthfile", true);
        _h94.addQuery("highlights", "queries/highlights.scm");
        _h94.addQuery("injections", "queries/injections.scm");
    }

    const tp_ebnf = b.dependency("tp_ebnf", .{});
    if (gb.use_third_party) {
        const _h217 = gb.addGrammarChecked(tp_ebnf, "crates/tree-sitter-ebnf", "ebnf", "tree_sitter_ebnf", false);
        _h217.addQuery("highlights", "crates/tree-sitter-ebnf/queries/highlights.scm");
    }

    const tp_editorconfig = b.dependency("tp_editorconfig", .{});
    if (gb.use_third_party) {
        const _h218 = gb.addGrammarChecked(tp_editorconfig, "", "editorconfig", "tree_sitter_editorconfig", true);
        _h218.addQuery("highlights", "queries/editorconfig/highlights.scm");
    }

    const tp_eds = b.dependency("tp_eds", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_eds, "", "eds", "tree_sitter_eds", false);
    }

    const tp_eex = b.dependency("tp_eex", .{});
    if (gb.use_third_party) {
        const _h95 = gb.addGrammarChecked(tp_eex, "", "eex", "tree_sitter_eex", false);
        _h95.addQuery("highlights", "queries/highlights.scm");
        _h95.addQuery("injections", "queries/injections.scm");
    }

    const tp_elixir = b.dependency("tp_elixir", .{});
    if (gb.use_third_party) {
        const _h96 = gb.addGrammarChecked(tp_elixir, "", "elixir", "tree_sitter_elixir", true);
        _h96.addQuery("highlights", "queries/highlights.scm");
        _h96.addQuery("injections", "queries/injections.scm");
        _h96.addQuery("tags", "queries/tags.scm");
    }

    const tp_elm = b.dependency("tp_elm", .{});
    if (gb.use_third_party) {
        const _h97 = gb.addGrammarChecked(tp_elm, "", "elm", "tree_sitter_elm", true);
        _h97.addQuery("highlights", "queries/highlights.scm");
        _h97.addQuery("injections", "queries/injections.scm");
        _h97.addQuery("locals", "queries/locals.scm");
        _h97.addQuery("tags", "queries/tags.scm");
    }

    const tp_elsa = b.dependency("tp_elsa", .{});
    if (gb.use_third_party) {
        const _h98 = gb.addGrammarChecked(tp_elsa, "", "elsa", "tree_sitter_elsa", false);
        _h98.addQuery("highlights", "queries/highlights.scm");
        _h98.addQuery("injections", "queries/injections.scm");
        _h98.addQuery("folds", "queries/folds.scm");
        _h98.addQuery("indents", "queries/indents.scm");
        _h98.addQuery("locals", "queries/locals.scm");
    }

    const tp_elvish = b.dependency("tp_elvish", .{});
    if (gb.use_third_party) {
        const _h99 = gb.addGrammarChecked(tp_elvish, "", "elvish", "tree_sitter_elvish", false);
        _h99.addQuery("highlights", "queries/highlights.scm");
        _h99.addQuery("injections", "queries/injections.scm");
    }

    const tp_enforce = b.dependency("tp_enforce", .{});
    if (gb.use_third_party) {
        const _h100 = gb.addGrammarChecked(tp_enforce, "", "enforce", "tree_sitter_enforce", false);
        _h100.addQuery("highlights", "queries/highlights.scm");
        _h100.addQuery("injections", "queries/injections.scm");
        _h100.addQuery("folds", "queries/folds.scm");
        _h100.addQuery("indents", "queries/indents.scm");
        _h100.addQuery("locals", "queries/locals.scm");
        _h100.addQuery("tags", "queries/tags.scm");
    }

    const tp_erlang = b.dependency("tp_erlang", .{});
    if (gb.use_third_party) {
        const _h219 = gb.addGrammarChecked(tp_erlang, "", "erl", "tree_sitter_erlang", true);
        _h219.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_facility = b.dependency("tp_facility", .{});
    if (gb.use_third_party) {
        const _h101 = gb.addGrammarChecked(tp_facility, "", "facility", "tree_sitter_facility", false);
        _h101.addQuery("highlights", "queries/highlights.scm");
        _h101.addQuery("injections", "queries/injections.scm");
        _h101.addQuery("folds", "queries/folds.scm");
        _h101.addQuery("indents", "queries/indents.scm");
    }

    const tp_faust = b.dependency("tp_faust", .{});
    if (gb.use_third_party) {
        const _h102 = gb.addGrammarChecked(tp_faust, "", "faust", "tree_sitter_faust", false);
        _h102.addQuery("highlights", "queries/highlights.scm");
        _h102.addQuery("injections", "queries/injections.scm");
        _h102.addQuery("locals", "queries/locals.scm");
    }

    const tp_fennel = b.dependency("tp_fennel", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_fennel, "", "fennel", "tree_sitter_fennel", true);
    }

    const tp_fidl = b.dependency("tp_fidl", .{});
    if (gb.use_third_party) {
        const _h103 = gb.addGrammarChecked(tp_fidl, "", "fidl", "tree_sitter_fidl", false);
        _h103.addQuery("highlights", "queries/highlights.scm");
        _h103.addQuery("injections", "queries/injections.scm");
        _h103.addQuery("folds", "queries/folds.scm");
    }

    const tp_fish = b.dependency("tp_fish", .{});
    if (gb.use_third_party) {
        const _h220 = gb.addGrammarChecked(tp_fish, "", "fish", "tree_sitter_fish", true);
        _h220.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_foam = b.dependency("tp_foam", .{});
    if (gb.use_third_party) {
        const _h104 = gb.addGrammarChecked(tp_foam, "", "foam", "tree_sitter_foam", true);
        _h104.addQuery("highlights", "queries/highlights.scm");
        _h104.addQuery("injections", "queries/injections.scm");
        _h104.addQuery("folds", "queries/folds.scm");
        _h104.addQuery("indents", "queries/indents.scm");
        _h104.addQuery("locals", "queries/locals.scm");
    }

    const tp_forth = b.dependency("tp_forth", .{});
    if (gb.use_third_party) {
        const _h221 = gb.addGrammarChecked(tp_forth, "", "forth", "tree_sitter_forth", false);
        _h221.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_fortran = b.dependency("tp_fortran", .{});
    if (gb.use_third_party) {
        const _h105 = gb.addGrammarChecked(tp_fortran, "", "f90", "tree_sitter_fortran", true);
        _h105.addQuery("highlights", "queries/highlights.scm");
        _h105.addQuery("folds", "queries/folds.scm");
        _h105.addQuery("indents", "queries/indents.scm");
        _h105.addQuery("locals", "queries/locals.scm");
        _h105.addQuery("tags", "queries/tags.scm");
    }

    const tp_fsh = b.dependency("tp_fsh", .{});
    if (gb.use_third_party) {
        const _h222 = gb.addGrammarChecked(tp_fsh, "", "fsh", "tree_sitter_fsh", false);
        _h222.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_fsharp = b.dependency("tp_fsharp", .{});
    if (gb.use_third_party) {
        const _h106 = gb.addGrammarChecked(tp_fsharp, "fsharp", "fs", "tree_sitter_fsharp", true);
        _h106.addQuery("highlights", "queries/highlights.scm");
        _h106.addQuery("injections", "queries/injections.scm");
        _h106.addQuery("indents", "queries/indents.scm");
        _h106.addQuery("locals", "queries/locals.scm");
        _h106.addQuery("tags", "queries/tags.scm");
    }

    const tp_gap = b.dependency("tp_gap", .{});
    if (gb.use_third_party) {
        const _h107 = gb.addGrammarChecked(tp_gap, "", "gap", "tree_sitter_gap", true);
        _h107.addQuery("highlights", "queries/highlights.scm");
        _h107.addQuery("folds", "queries/folds.scm");
        _h107.addQuery("locals", "queries/locals.scm");
        _h107.addQuery("tags", "queries/tags.scm");
    }

    const tp_gaptst = b.dependency("tp_gaptst", .{});
    if (gb.use_third_party) {
        const _h108 = gb.addGrammarChecked(tp_gaptst, "", "gaptst", "tree_sitter_gaptst", true);
        _h108.addQuery("highlights", "queries/highlights.scm");
        _h108.addQuery("injections", "queries/injections.scm");
        _h108.addQuery("folds", "queries/folds.scm");
    }

    const tp_gdshader = b.dependency("tp_gdshader", .{});
    if (gb.use_third_party) {
        const _h223 = gb.addGrammarChecked(tp_gdshader, "", "gdshader", "tree_sitter_gdshader", false);
        _h223.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_git_config = b.dependency("tp_git_config", .{});
    if (gb.use_third_party) {
        const _h224 = gb.addGrammarChecked(tp_git_config, "", "git_config", "tree_sitter_git_config", false);
        _h224.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_git_rebase = b.dependency("tp_git_rebase", .{});
    if (gb.use_third_party) {
        const _h225 = gb.addGrammarChecked(tp_git_rebase, "", "git_rebase", "tree_sitter_git_rebase", false);
        _h225.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_gitcommit = b.dependency("tp_gitcommit", .{});
    if (gb.use_third_party) {
        const _h109 = gb.addGrammarChecked(tp_gitcommit, "", "gitcommit", "tree_sitter_gitcommit", true);
        _h109.addQuery("highlights", "queries/highlights.scm");
        _h109.addQuery("injections", "queries/injections.scm");
    }

    const tp_gitignore = b.dependency("tp_gitignore", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_gitignore, "", "gitignore", "tree_sitter_gitignore", false);
    }

    const tp_gleam = b.dependency("tp_gleam", .{});
    if (gb.use_third_party) {
        const _h110 = gb.addGrammarChecked(tp_gleam, "", "gleam", "tree_sitter_gleam", true);
        _h110.addQuery("highlights", "queries/highlights.scm");
        _h110.addQuery("injections", "queries/injections.scm");
        _h110.addQuery("locals", "queries/locals.scm");
        _h110.addQuery("tags", "queries/tags.scm");
    }

    const tp_gnuplot = b.dependency("tp_gnuplot", .{});
    if (gb.use_third_party) {
        const _h111 = gb.addGrammarChecked(tp_gnuplot, "", "gnuplot", "tree_sitter_gnuplot", true);
        _h111.addQuery("highlights", "queries/highlights.scm");
        _h111.addQuery("injections", "queries/injections.scm");
        _h111.addQuery("folds", "queries/folds.scm");
    }

    const tp_goctl = b.dependency("tp_goctl", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_goctl, "", "goctl", "tree_sitter_goctl", false);
    }

    const tp_godot_resource = b.dependency("tp_godot_resource", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_godot_resource, "", "godot_resource", "tree_sitter_godot_resource", true);
    }

    const tp_gomod = b.dependency("tp_gomod", .{});
    if (gb.use_third_party) {
        const _h226 = gb.addGrammarChecked(tp_gomod, "", "gomod", "tree_sitter_gomod", false);
        _h226.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_gowork = b.dependency("tp_gowork", .{});
    if (gb.use_third_party) {
        const _h227 = gb.addGrammarChecked(tp_gowork, "", "gowork", "tree_sitter_gowork", false);
        _h227.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_graphql = b.dependency("tp_graphql", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_graphql, "", "gql", "tree_sitter_graphql", false);
    }

    const tp_gren = b.dependency("tp_gren", .{});
    if (gb.use_third_party) {
        const _h112 = gb.addGrammarChecked(tp_gren, "", "gren", "tree_sitter_gren", true);
        _h112.addQuery("highlights", "queries/highlights.scm");
        _h112.addQuery("injections", "queries/injections.scm");
        _h112.addQuery("locals", "queries/locals.scm");
        _h112.addQuery("tags", "queries/tags.scm");
    }

    const tp_groovy = b.dependency("tp_groovy", .{});
    if (gb.use_third_party) {
        const _h113 = gb.addGrammarChecked(tp_groovy, "", "groovy", "tree_sitter_groovy", false);
        _h113.addQuery("highlights", "queries/highlights.scm");
        _h113.addQuery("injections", "queries/injections.scm");
        _h113.addQuery("folds", "queries/folds.scm");
        _h113.addQuery("indents", "queries/indents.scm");
        _h113.addQuery("locals", "queries/locals.scm");
    }

    const tp_hack = b.dependency("tp_hack", .{});
    if (gb.use_third_party) {
        const _h228 = gb.addGrammarChecked(tp_hack, "", "hack", "tree_sitter_hack", true);
        _h228.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_haskell_persistent = b.dependency("tp_haskell_persistent", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_haskell_persistent, "", "haskell_persistent", "tree_sitter_haskell_persistent", true);
    }

    const tp_heex = b.dependency("tp_heex", .{});
    if (gb.use_third_party) {
        const _h114 = gb.addGrammarChecked(tp_heex, "", "heex", "tree_sitter_heex", false);
        _h114.addQuery("highlights", "queries/highlights.scm");
        _h114.addQuery("injections", "queries/injections.scm");
    }

    const tp_hjson = b.dependency("tp_hjson", .{});
    if (gb.use_third_party) {
        const _h229 = gb.addGrammarChecked(tp_hjson, "", "hjson", "tree_sitter_hjson", false);
        _h229.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_hocon = b.dependency("tp_hocon", .{});
    if (gb.use_third_party) {
        const _h230 = gb.addGrammarChecked(tp_hocon, "", "hocon", "tree_sitter_hocon", false);
        _h230.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_hoon = b.dependency("tp_hoon", .{});
    if (gb.use_third_party) {
        const _h231 = gb.addGrammarChecked(tp_hoon, "", "hoon", "tree_sitter_hoon", true);
        _h231.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_htmldjango = b.dependency("tp_htmldjango", .{});
    if (gb.use_third_party) {
        const _h115 = gb.addGrammarChecked(tp_htmldjango, "", "htmldjango", "tree_sitter_htmldjango", false);
        _h115.addQuery("highlights", "queries/highlights.scm");
        _h115.addQuery("injections", "queries/injections.scm");
    }

    const tp_http = b.dependency("tp_http", .{});
    if (gb.use_third_party) {
        const _h116 = gb.addGrammarChecked(tp_http, "", "http", "tree_sitter_http", false);
        _h116.addQuery("highlights", "queries/highlights.scm");
        _h116.addQuery("injections", "queries/injections.scm");
    }

    const tp_hurl = b.dependency("tp_hurl", .{});
    if (gb.use_third_party) {
        const _h117 = gb.addGrammarChecked(tp_hurl, "", "hurl", "tree_sitter_hurl", false);
        _h117.addQuery("highlights", "queries/highlights.scm");
        _h117.addQuery("injections", "queries/injections.scm");
        _h117.addQuery("folds", "queries/folds.scm");
        _h117.addQuery("indents", "queries/indents.scm");
    }

    const tp_idl = b.dependency("tp_idl", .{});
    if (gb.use_third_party) {
        const _h118 = gb.addGrammarChecked(tp_idl, "", "idl", "tree_sitter_idl", false);
        _h118.addQuery("highlights", "queries/highlights.scm");
        _h118.addQuery("injections", "queries/injections.scm");
        _h118.addQuery("indents", "queries/indents.scm");
    }

    const tp_idris = b.dependency("tp_idris", .{});
    if (gb.use_third_party) {
        const _h119 = gb.addGrammarChecked(tp_idris, "", "idris", "tree_sitter_idris", true);
        _h119.addQuery("highlights", "queries/highlights.scm");
        _h119.addQuery("injections", "queries/injections.scm");
        _h119.addQuery("locals", "queries/locals.scm");
    }

    const tp_ini = b.dependency("tp_ini", .{});
    if (gb.use_third_party) {
        const _h120 = gb.addGrammarChecked(tp_ini, "", "ini", "tree_sitter_ini", false);
        _h120.addQuery("highlights", "queries/highlights.scm");
        _h120.addQuery("folds", "queries/folds.scm");
    }

    const tp_inko = b.dependency("tp_inko", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_inko, "", "inko", "tree_sitter_inko", false);
    }

    const tp_janet_simple = b.dependency("tp_janet_simple", .{});
    if (gb.use_third_party) {
        const _h232 = gb.addGrammarChecked(tp_janet_simple, "", "janet_simple", "tree_sitter_janet_simple", true);
        _h232.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_javadoc = b.dependency("tp_javadoc", .{});
    if (gb.use_third_party) {
        const _h121 = gb.addGrammarChecked(tp_javadoc, "", "javadoc", "tree_sitter_javadoc", true);
        _h121.addQuery("highlights", "queries/highlights.scm");
        _h121.addQuery("injections", "queries/injections.scm");
    }

    const tp_jinja = b.dependency("tp_jinja", .{});
    if (gb.use_third_party) {
        const _h122 = gb.addGrammarChecked(tp_jinja, "tree-sitter-jinja", "jinja", "tree_sitter_jinja", true);
        _h122.addQuery("highlights", "tree-sitter-jinja/queries/highlights.scm");
        _h122.addQuery("injections", "tree-sitter-jinja/queries/injections.scm");
    }

    const tp_jinja_inline = b.dependency("tp_jinja_inline", .{});
    if (gb.use_third_party) {
        const _h233 = gb.addGrammarChecked(tp_jinja_inline, "tree-sitter-jinja_inline", "jinja_inline", "tree_sitter_jinja_inline", true);
        _h233.addQuery("highlights", "tree-sitter-jinja_inline/queries/highlights.scm");
    }

    const tp_jq = b.dependency("tp_jq", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_jq, "", "jq", "tree_sitter_jq", false);
    }

    const tp_json5 = b.dependency("tp_json5", .{});
    if (gb.use_third_party) {
        const _h234 = gb.addGrammarChecked(tp_json5, "", "json5", "tree_sitter_json5", false);
        _h234.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_jsonnet = b.dependency("tp_jsonnet", .{});
    if (gb.use_third_party) {
        const _h235 = gb.addGrammarChecked(tp_jsonnet, "", "jsonnet", "tree_sitter_jsonnet", true);
        _h235.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_just = b.dependency("tp_just", .{});
    if (gb.use_third_party) {
        const _h123 = gb.addGrammarChecked(tp_just, "", "just", "tree_sitter_just", true);
        _h123.addQuery("highlights", "queries/just/highlights.scm");
        _h123.addQuery("injections", "queries/just/injections.scm");
        _h123.addQuery("folds", "queries/just/folds.scm");
        _h123.addQuery("indents", "queries/just/indents.scm");
        _h123.addQuery("locals", "queries/just/locals.scm");
    }

    const tp_kcl = b.dependency("tp_kcl", .{});
    if (gb.use_third_party) {
        const _h236 = gb.addGrammarChecked(tp_kcl, "", "kcl", "tree_sitter_kcl", true);
        _h236.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_koto = b.dependency("tp_koto", .{});
    if (gb.use_third_party) {
        const _h124 = gb.addGrammarChecked(tp_koto, "", "koto", "tree_sitter_koto", true);
        _h124.addQuery("highlights", "queries/highlights.scm");
        _h124.addQuery("injections", "queries/injections.scm");
        _h124.addQuery("folds", "queries/folds.scm");
        _h124.addQuery("locals", "queries/locals.scm");
    }

    const tp_kusto = b.dependency("tp_kusto", .{});
    if (gb.use_third_party) {
        const _h237 = gb.addGrammarChecked(tp_kusto, "", "kusto", "tree_sitter_kusto", false);
        _h237.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_lalrpop = b.dependency("tp_lalrpop", .{});
    if (gb.use_third_party) {
        const _h125 = gb.addGrammarChecked(tp_lalrpop, "", "lalrpop", "tree_sitter_lalrpop", true);
        _h125.addQuery("highlights", "queries/highlights.scm");
        _h125.addQuery("injections", "queries/injections.scm");
        _h125.addQuery("locals", "queries/locals.scm");
    }

    const tp_ledger = b.dependency("tp_ledger", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_ledger, "", "ledger", "tree_sitter_ledger", false);
    }

    const tp_leo = b.dependency("tp_leo", .{});
    if (gb.use_third_party) {
        const _h126 = gb.addGrammarChecked(tp_leo, "", "leo", "tree_sitter_leo", false);
        _h126.addQuery("highlights", "queries/highlights.scm");
        _h126.addQuery("injections", "queries/injections.scm");
    }

    const tp_liquid = b.dependency("tp_liquid", .{});
    if (gb.use_third_party) {
        const _h127 = gb.addGrammarChecked(tp_liquid, "", "liquid", "tree_sitter_liquid", true);
        _h127.addQuery("highlights", "queries/highlights.scm");
        _h127.addQuery("injections", "queries/injections.scm");
    }

    const tp_liquidsoap = b.dependency("tp_liquidsoap", .{});
    if (gb.use_third_party) {
        const _h128 = gb.addGrammarChecked(tp_liquidsoap, "", "liquidsoap", "tree_sitter_liquidsoap", true);
        _h128.addQuery("highlights", "queries/highlights.scm");
        _h128.addQuery("locals", "queries/locals.scm");
    }

    const tp_llvm = b.dependency("tp_llvm", .{});
    if (gb.use_third_party) {
        const _h238 = gb.addGrammarChecked(tp_llvm, "", "llvm", "tree_sitter_llvm", false);
        _h238.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_m68k = b.dependency("tp_m68k", .{});
    if (gb.use_third_party) {
        const _h129 = gb.addGrammarChecked(tp_m68k, "", "m68k", "tree_sitter_m68k", false);
        _h129.addQuery("highlights", "queries/highlights.scm");
        _h129.addQuery("folds", "queries/folds.scm");
    }

    const tp_menhir = b.dependency("tp_menhir", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_menhir, "", "menhir", "tree_sitter_menhir", true);
    }

    const tp_mermaid = b.dependency("tp_mermaid", .{});
    if (gb.use_third_party) {
        const _h239 = gb.addGrammarChecked(tp_mermaid, "", "mermaid", "tree_sitter_mermaid", false);
        _h239.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_mlir = b.dependency("tp_mlir", .{});
    if (gb.use_third_party) {
        const _h130 = gb.addGrammarChecked(tp_mlir, "", "mlir", "tree_sitter_mlir", false);
        _h130.addQuery("highlights", "queries/highlights.scm");
        _h130.addQuery("locals", "queries/locals.scm");
    }

    const tp_nasm = b.dependency("tp_nasm", .{});
    if (gb.use_third_party) {
        const _h131 = gb.addGrammarChecked(tp_nasm, "", "nasm", "tree_sitter_nasm", false);
        _h131.addQuery("highlights", "queries/highlights.scm");
        _h131.addQuery("injections", "queries/injections.scm");
    }

    const tp_nginx = b.dependency("tp_nginx", .{});
    if (gb.use_third_party) {
        const _h132 = gb.addGrammarChecked(tp_nginx, "", "nginx", "tree_sitter_nginx", true);
        _h132.addQuery("highlights", "queries/highlights.scm");
        _h132.addQuery("injections", "queries/injections.scm");
        _h132.addQuery("folds", "queries/folds.scm");
    }

    const tp_nickel = b.dependency("tp_nickel", .{});
    if (gb.use_third_party) {
        const _h133 = gb.addGrammarChecked(tp_nickel, "", "nickel", "tree_sitter_nickel", true);
        _h133.addQuery("highlights", "queries/highlights.scm");
        _h133.addQuery("injections", "queries/injections.scm");
    }

    const tp_nim = b.dependency("tp_nim", .{});
    if (gb.use_third_party) {
        const _h240 = gb.addGrammarChecked(tp_nim, "", "nim", "tree_sitter_nim", true);
        _h240.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_nim_format_string = b.dependency("tp_nim_format_string", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_nim_format_string, "", "nim_format_string", "tree_sitter_nim_format_string", false);
    }

    const tp_ninja = b.dependency("tp_ninja", .{});
    if (gb.use_third_party) {
        const _h134 = gb.addGrammarChecked(tp_ninja, "", "ninja", "tree_sitter_ninja", false);
        _h134.addQuery("highlights", "queries/highlights.scm");
        _h134.addQuery("folds", "queries/folds.scm");
        _h134.addQuery("indents", "queries/indents.scm");
    }

    const tp_nix = b.dependency("tp_nix", .{});
    if (gb.use_third_party) {
        const _h135 = gb.addGrammarChecked(tp_nix, "", "nix", "tree_sitter_nix", true);
        _h135.addQuery("highlights", "queries/highlights.scm");
        _h135.addQuery("injections", "queries/injections.scm");
        _h135.addQuery("locals", "queries/locals.scm");
        _h135.addQuery("tags", "queries/tags.scm");
    }

    const tp_nu = b.dependency("tp_nu", .{});
    if (gb.use_third_party) {
        const _h136 = gb.addGrammarChecked(tp_nu, "", "nu", "tree_sitter_nu", true);
        _h136.addQuery("highlights", "queries/nu/highlights.scm");
        _h136.addQuery("injections", "queries/nu/injections.scm");
        _h136.addQuery("folds", "queries/nu/folds.scm");
        _h136.addQuery("indents", "queries/nu/indents.scm");
    }

    const tp_objdump = b.dependency("tp_objdump", .{});
    if (gb.use_third_party) {
        const _h241 = gb.addGrammarChecked(tp_objdump, "", "objdump", "tree_sitter_objdump", true);
        _h241.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_ocamllex = b.dependency("tp_ocamllex", .{});
    if (gb.use_third_party) {
        const _h137 = gb.addGrammarChecked(tp_ocamllex, "", "ocamllex", "tree_sitter_ocamllex", true);
        _h137.addQuery("highlights", "queries/highlights.scm");
        _h137.addQuery("injections", "queries/injections.scm");
    }

    const tp_pascal = b.dependency("tp_pascal", .{});
    if (gb.use_third_party) {
        const _h138 = gb.addGrammarChecked(tp_pascal, "", "pascal", "tree_sitter_pascal", false);
        _h138.addQuery("highlights", "queries/highlights.scm");
        _h138.addQuery("locals", "queries/locals.scm");
    }

    const tp_passwd = b.dependency("tp_passwd", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_passwd, "", "passwd", "tree_sitter_passwd", false);
    }

    const tp_phpdoc = b.dependency("tp_phpdoc", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_phpdoc, "", "phpdoc", "tree_sitter_phpdoc", true);
    }

    const tp_pioasm = b.dependency("tp_pioasm", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_pioasm, "", "pioasm", "tree_sitter_pioasm", true);
    }

    const tp_powershell = b.dependency("tp_powershell", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_powershell, "", "powershell", "tree_sitter_powershell", true);
    }

    const tp_prisma = b.dependency("tp_prisma", .{});
    if (gb.use_third_party) {
        const _h242 = gb.addGrammarChecked(tp_prisma, "", "prisma", "tree_sitter_prisma", false);
        _h242.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_problog = b.dependency("tp_problog", .{});
    if (gb.use_third_party) {
        const _h243 = gb.addGrammarChecked(tp_problog, "grammars/problog", "problog", "tree_sitter_problog", false);
        _h243.addQuery("highlights", "grammars/problog/queries/highlights.scm");
        _h243.addQuery("injections", "queries/injections.scm");
        _h243.addQuery("folds", "queries/folds.scm");
        _h243.addQuery("indents", "queries/indents.scm");
    }

    const tp_prolog = b.dependency("tp_prolog", .{});
    if (gb.use_third_party) {
        const _h244 = gb.addGrammarChecked(tp_prolog, "grammars/prolog", "prolog", "tree_sitter_prolog", false);
        _h244.addQuery("highlights", "grammars/prolog/queries/highlights.scm");
        _h244.addQuery("injections", "queries/injections.scm");
        _h244.addQuery("folds", "queries/folds.scm");
        _h244.addQuery("indents", "queries/indents.scm");
    }

    const tp_promql = b.dependency("tp_promql", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_promql, "", "promql", "tree_sitter_promql", false);
    }

    const tp_proto = b.dependency("tp_proto", .{});
    if (gb.use_third_party) {
        const _h139 = gb.addGrammarChecked(tp_proto, "", "proto", "tree_sitter_proto", false);
        _h139.addQuery("highlights", "queries/highlights.scm");
        _h139.addQuery("folds", "queries/folds.scm");
    }

    const tp_prql = b.dependency("tp_prql", .{});
    if (gb.use_third_party) {
        const _h140 = gb.addGrammarChecked(tp_prql, "", "prql", "tree_sitter_prql", false);
        _h140.addQuery("highlights", "queries/highlights.scm");
        _h140.addQuery("injections", "queries/injections.scm");
    }

    const tp_pug = b.dependency("tp_pug", .{});
    if (gb.use_third_party) {
        const _h245 = gb.addGrammarChecked(tp_pug, "", "pug", "tree_sitter_pug", true);
        _h245.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_purescript = b.dependency("tp_purescript", .{});
    if (gb.use_third_party) {
        const _h141 = gb.addGrammarChecked(tp_purescript, "", "purescript", "tree_sitter_purescript", true);
        _h141.addQuery("highlights", "queries/highlights.scm");
        _h141.addQuery("injections", "queries/injections.scm");
        _h141.addQuery("locals", "queries/locals.scm");
    }

    const tp_qmljs = b.dependency("tp_qmljs", .{});
    if (gb.use_third_party) {
        const _h142 = gb.addGrammarChecked(tp_qmljs, "", "qmljs", "tree_sitter_qmljs", true);
        _h142.addQuery("highlights", "queries/highlights.scm");
        _h142.addQuery("locals", "queries/locals.scm");
    }

    const tp_r = b.dependency("tp_r", .{});
    if (gb.use_third_party) {
        const _h143 = gb.addGrammarChecked(tp_r, "", "r", "tree_sitter_r", true);
        _h143.addQuery("highlights", "queries/highlights.scm");
        _h143.addQuery("locals", "queries/locals.scm");
        _h143.addQuery("tags", "queries/tags.scm");
    }

    const tp_racket = b.dependency("tp_racket", .{});
    if (gb.use_third_party) {
        const _h144 = gb.addGrammarChecked(tp_racket, "", "racket", "tree_sitter_racket", true);
        _h144.addQuery("highlights", "queries/highlights.scm");
        _h144.addQuery("locals", "queries/locals.scm");
        _h144.addQuery("tags", "queries/tags.scm");
    }

    const tp_ralph = b.dependency("tp_ralph", .{});
    if (gb.use_third_party) {
        const _h145 = gb.addGrammarChecked(tp_ralph, "", "ralph", "tree_sitter_ralph", false);
        _h145.addQuery("highlights", "queries/highlights.scm");
        _h145.addQuery("injections", "queries/injections.scm");
    }

    const tp_rasi = b.dependency("tp_rasi", .{});
    if (gb.use_third_party) {
        const _h146 = gb.addGrammarChecked(tp_rasi, "", "rasi", "tree_sitter_rasi", false);
        _h146.addQuery("highlights", "queries/highlights.scm");
        _h146.addQuery("locals", "queries/locals.scm");
    }

    const tp_razor = b.dependency("tp_razor", .{});
    if (gb.use_third_party) {
        const _h147 = gb.addGrammarChecked(tp_razor, "", "razor", "tree_sitter_razor", true);
        _h147.addQuery("highlights", "queries/highlights.scm");
        _h147.addQuery("injections", "queries/injections.scm");
    }

    const tp_rbs = b.dependency("tp_rbs", .{});
    if (gb.use_third_party) {
        const _h148 = gb.addGrammarChecked(tp_rbs, "", "rbs", "tree_sitter_rbs", false);
        _h148.addQuery("highlights", "queries/highlights.scm");
        _h148.addQuery("injections", "queries/injections.scm");
        _h148.addQuery("folds", "queries/folds.scm");
        _h148.addQuery("indents", "queries/indents.scm");
    }

    const tp_rego = b.dependency("tp_rego", .{});
    if (gb.use_third_party) {
        const _h149 = gb.addGrammarChecked(tp_rego, "", "rego", "tree_sitter_rego", false);
        _h149.addQuery("highlights", "queries/highlights.scm");
        _h149.addQuery("locals", "queries/locals.scm");
    }

    const tp_rescript = b.dependency("tp_rescript", .{});
    if (gb.use_third_party) {
        const _h150 = gb.addGrammarChecked(tp_rescript, "", "rescript", "tree_sitter_rescript", true);
        _h150.addQuery("highlights", "queries/highlights.scm");
        _h150.addQuery("injections", "queries/injections.scm");
        _h150.addQuery("locals", "queries/locals.scm");
    }

    const tp_rnoweb = b.dependency("tp_rnoweb", .{});
    if (gb.use_third_party) {
        const _h_rnoweb = gb.addGrammarChecked(tp_rnoweb, "", "rnoweb", "tree_sitter_rnoweb", true);
        _h_rnoweb.addQuery("injections", "queries/injections.scm");
    }

    const tp_robot = b.dependency("tp_robot", .{});
    if (gb.use_third_party) {
        const _h151 = gb.addGrammarChecked(tp_robot, "", "robot", "tree_sitter_robot", false);
        _h151.addQuery("highlights", "queries/highlights.scm");
        _h151.addQuery("folds", "queries/folds.scm");
        _h151.addQuery("indents", "queries/indents.scm");
    }

    const tp_robots = b.dependency("tp_robots", .{});
    if (gb.use_third_party) {
        const _h_robots = gb.addGrammarChecked(tp_robots, "", "robots", "tree_sitter_robots_txt", true);
        _h_robots.addQuery("injections", "queries/injections.scm");
    }

    const tp_roc = b.dependency("tp_roc", .{});
    if (gb.use_third_party) {
        const _h152 = gb.addGrammarChecked(tp_roc, "", "roc", "tree_sitter_roc", true);
        _h152.addQuery("highlights", "queries/highlights.scm");
        _h152.addQuery("injections", "queries/injections.scm");
        _h152.addQuery("indents", "queries/indents.scm");
        _h152.addQuery("locals", "queries/locals.scm");
        _h152.addQuery("tags", "queries/tags.scm");
    }

    const tp_rst = b.dependency("tp_rst", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_rst, "", "rst", "tree_sitter_rst", true);
    }

    const tp_scfg = b.dependency("tp_scfg", .{});
    if (gb.use_third_party) {
        const _h246 = gb.addGrammarChecked(tp_scfg, "", "scfg", "tree_sitter_scfg", false);
        _h246.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_scheme = b.dependency("tp_scheme", .{});
    if (gb.use_third_party) {
        const _h247 = gb.addGrammarChecked(tp_scheme, "", "scheme", "tree_sitter_scheme", false);
        _h247.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_sflog = b.dependency("tp_sflog", .{});
    if (gb.use_third_party) {
        const _h248 = gb.addGrammarChecked(tp_sflog, "sflog", "sflog", "tree_sitter_sflog", false);
        _h248.addQuery("highlights", "sflog/queries/highlights.scm");
    }

    const tp_slim = b.dependency("tp_slim", .{});
    if (gb.use_third_party) {
        const _h153 = gb.addGrammarChecked(tp_slim, "", "slim", "tree_sitter_slim", true);
        _h153.addQuery("highlights", "queries/highlights.scm");
        _h153.addQuery("injections", "queries/injections.scm");
        _h153.addQuery("folds", "queries/folds.scm");
        _h153.addQuery("indents", "queries/indents.scm");
        _h153.addQuery("locals", "queries/locals.scm");
    }

    const tp_slint = b.dependency("tp_slint", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_slint, "", "slint", "tree_sitter_slint", true);
    }

    const tp_smithy = b.dependency("tp_smithy", .{});
    if (gb.use_third_party) {
        const _h249 = gb.addGrammarChecked(tp_smithy, "", "smithy", "tree_sitter_smithy", false);
        _h249.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_snakemake = b.dependency("tp_snakemake", .{});
    if (gb.use_third_party) {
        const _h154 = gb.addGrammarChecked(tp_snakemake, "", "snakemake", "tree_sitter_snakemake", true);
        _h154.addQuery("highlights", "queries/snakemake/highlights.scm");
        _h154.addQuery("injections", "queries/snakemake/injections.scm");
        _h154.addQuery("folds", "queries/snakemake/folds.scm");
        _h154.addQuery("indents", "queries/snakemake/indents.scm");
        _h154.addQuery("locals", "queries/snakemake/locals.scm");
    }

    const tp_solidity = b.dependency("tp_solidity", .{});
    if (gb.use_third_party) {
        const _h155 = gb.addGrammarChecked(tp_solidity, "", "solidity", "tree_sitter_solidity", false);
        _h155.addQuery("highlights", "queries/highlights.scm");
        _h155.addQuery("locals", "queries/locals.scm");
        _h155.addQuery("tags", "queries/tags.scm");
    }

    const tp_soql = b.dependency("tp_soql", .{});
    if (gb.use_third_party) {
        const _h250 = gb.addGrammarChecked(tp_soql, "soql", "soql", "tree_sitter_soql", false);
        _h250.addQuery("highlights", "soql/queries/highlights.scm");
    }

    const tp_sosl = b.dependency("tp_sosl", .{});
    if (gb.use_third_party) {
        const _h251 = gb.addGrammarChecked(tp_sosl, "sosl", "sosl", "tree_sitter_sosl", false);
        _h251.addQuery("highlights", "sosl/queries/highlights.scm");
    }

    const tp_sourcepawn = b.dependency("tp_sourcepawn", .{});
    if (gb.use_third_party) {
        const _h156 = gb.addGrammarChecked(tp_sourcepawn, "", "sourcepawn", "tree_sitter_sourcepawn", true);
        _h156.addQuery("highlights", "queries/highlights.scm");
        _h156.addQuery("injections", "queries/injections.scm");
        _h156.addQuery("locals", "queries/locals.scm");
        _h156.addQuery("tags", "queries/tags.scm");
    }

    const tp_sparql = b.dependency("tp_sparql", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_sparql, "", "sparql", "tree_sitter_sparql", false);
    }

    const tp_strace = b.dependency("tp_strace", .{});
    if (gb.use_third_party) {
        const _h252 = gb.addGrammarChecked(tp_strace, "", "strace", "tree_sitter_strace", false);
        _h252.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_styled = b.dependency("tp_styled", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_styled, "", "styled", "tree_sitter_styled", true);
    }

    const tp_supercollider = b.dependency("tp_supercollider", .{});
    if (gb.use_third_party) {
        const _h157 = gb.addGrammarChecked(tp_supercollider, "", "supercollider", "tree_sitter_supercollider", true);
        _h157.addQuery("highlights", "queries/highlights.scm");
        _h157.addQuery("injections", "queries/injections.scm");
        _h157.addQuery("folds", "queries/folds.scm");
        _h157.addQuery("indents", "queries/indents.scm");
        _h157.addQuery("locals", "queries/locals.scm");
    }

    const tp_surface = b.dependency("tp_surface", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_surface, "", "surface", "tree_sitter_surface", false);
    }

    const tp_sway = b.dependency("tp_sway", .{});
    if (gb.use_third_party) {
        const _h158 = gb.addGrammarChecked(tp_sway, "", "sway", "tree_sitter_sway", true);
        _h158.addQuery("highlights", "queries/highlights.scm");
        _h158.addQuery("injections", "queries/injections.scm");
        _h158.addQuery("indents", "queries/indents.scm");
        _h158.addQuery("locals", "queries/locals.scm");
    }

    const tp_sxhkdrc = b.dependency("tp_sxhkdrc", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_sxhkdrc, "", "sxhkdrc", "tree_sitter_sxhkdrc", false);
    }

    const tp_systemtap = b.dependency("tp_systemtap", .{});
    if (gb.use_third_party) {
        const _h159 = gb.addGrammarChecked(tp_systemtap, "", "systemtap", "tree_sitter_systemtap", false);
        _h159.addQuery("highlights", "queries/highlights.scm");
        _h159.addQuery("locals", "queries/locals.scm");
    }

    const tp_tact = b.dependency("tp_tact", .{});
    if (gb.use_third_party) {
        const _h160 = gb.addGrammarChecked(tp_tact, "", "tact", "tree_sitter_tact", false);
        _h160.addQuery("highlights", "queries/highlights.scm");
        _h160.addQuery("injections", "queries/injections.scm");
        _h160.addQuery("locals", "queries/locals.scm");
        _h160.addQuery("tags", "queries/tags.scm");
    }

    const tp_templ = b.dependency("tp_templ", .{});
    if (gb.use_third_party) {
        const _h161 = gb.addGrammarChecked(tp_templ, "", "templ", "tree_sitter_templ", true);
        _h161.addQuery("highlights", "queries/templ/highlights.scm");
        _h161.addQuery("injections", "queries/templ/injections.scm");
        _h161.addQuery("folds", "queries/templ/folds.scm");
        _h161.addQuery("indents", "queries/templ/indents.scm");
    }

    const tp_tera = b.dependency("tp_tera", .{});
    if (gb.use_third_party) {
        const _h162 = gb.addGrammarChecked(tp_tera, "", "tera", "tree_sitter_tera", true);
        _h162.addQuery("highlights", "queries/highlights.scm");
        _h162.addQuery("injections", "queries/injections.scm");
        _h162.addQuery("locals", "queries/locals.scm");
    }

    const tp_textproto = b.dependency("tp_textproto", .{});
    if (gb.use_third_party) {
        const _h163 = gb.addGrammarChecked(tp_textproto, "", "textproto", "tree_sitter_textproto", false);
        _h163.addQuery("highlights", "queries/highlights.scm");
        _h163.addQuery("folds", "queries/folds.scm");
        _h163.addQuery("indents", "queries/indents.scm");
    }

    const tp_tiger = b.dependency("tp_tiger", .{});
    if (gb.use_third_party) {
        const _h164 = gb.addGrammarChecked(tp_tiger, "", "tiger", "tree_sitter_tiger", true);
        _h164.addQuery("highlights", "queries/highlights.scm");
        _h164.addQuery("injections", "queries/injections.scm");
        _h164.addQuery("folds", "queries/folds.scm");
        _h164.addQuery("indents", "queries/indents.scm");
        _h164.addQuery("locals", "queries/locals.scm");
        _h164.addQuery("tags", "queries/tags.scm");
    }

    const tp_tlaplus = b.dependency("tp_tlaplus", .{});
    if (gb.use_third_party) {
        const _h165 = gb.addGrammarChecked(tp_tlaplus, "", "tlaplus", "tree_sitter_tlaplus", true);
        _h165.addQuery("highlights", "queries/highlights.scm");
        _h165.addQuery("locals", "queries/locals.scm");
    }

    const tp_todotxt = b.dependency("tp_todotxt", .{});
    if (gb.use_third_party) {
        const _h253 = gb.addGrammarChecked(tp_todotxt, "", "todotxt", "tree_sitter_todotxt", false);
        _h253.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_turtle = b.dependency("tp_turtle", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_turtle, "", "turtle", "tree_sitter_turtle", false);
    }

    const tp_twig = b.dependency("tp_twig", .{});
    if (gb.use_third_party) {
        const _h166 = gb.addGrammarChecked(tp_twig, "", "twig", "tree_sitter_twig", false);
        _h166.addQuery("highlights", "queries/highlights.scm");
        _h166.addQuery("injections", "queries/injections.scm");
    }

    const tp_typespec = b.dependency("tp_typespec", .{});
    if (gb.use_third_party) {
        const _h167 = gb.addGrammarChecked(tp_typespec, "", "typespec", "tree_sitter_typespec", false);
        _h167.addQuery("highlights", "queries/highlights.scm");
        _h167.addQuery("injections", "queries/injections.scm");
        _h167.addQuery("folds", "queries/folds.scm");
        _h167.addQuery("indents", "queries/indents.scm");
    }

    const tp_typoscript = b.dependency("tp_typoscript", .{});
    if (gb.use_third_party) {
        const _h168 = gb.addGrammarChecked(tp_typoscript, "", "typoscript", "tree_sitter_typoscript", false);
        _h168.addQuery("highlights", "queries/highlights.scm");
        _h168.addQuery("injections", "queries/injections.scm");
    }

    const tp_typst = b.dependency("tp_typst", .{});
    if (gb.use_third_party) {
        const _h169 = gb.addGrammarChecked(tp_typst, "", "typst", "tree_sitter_typst", true);
        _h169.addQuery("highlights", "queries/typst/highlights.scm");
        _h169.addQuery("injections", "queries/typst/injections.scm");
    }

    const tp_unison = b.dependency("tp_unison", .{});
    if (gb.use_third_party) {
        const _h254 = gb.addGrammarChecked(tp_unison, "", "unison", "tree_sitter_unison", true);
        _h254.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_usd = b.dependency("tp_usd", .{});
    if (gb.use_third_party) {
        const _h255 = gb.addGrammarChecked(tp_usd, "", "usd", "tree_sitter_usd", false);
        _h255.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_v = b.dependency("tp_v", .{});
    if (gb.use_third_party) {
        const _h256 = gb.addGrammarChecked(tp_v, "tree_sitter_v", "vlang", "tree_sitter_v", false);
        _h256.addQuery("highlights", "tree_sitter_v/queries/highlights.scm");
    }

    const tp_vala = b.dependency("tp_vala", .{});
    if (gb.use_third_party) {
        const _h170 = gb.addGrammarChecked(tp_vala, "", "vala", "tree_sitter_vala", false);
        _h170.addQuery("highlights", "queries/highlights.scm");
        _h170.addQuery("locals", "queries/locals.scm");
    }

    const tp_vento = b.dependency("tp_vento", .{});
    if (gb.use_third_party) {
        const _h171 = gb.addGrammarChecked(tp_vento, "", "vento", "tree_sitter_vento", true);
        _h171.addQuery("highlights", "queries/highlights.scm");
        _h171.addQuery("injections", "queries/injections.scm");
    }

    const tp_verilog = b.dependency("tp_verilog", .{});
    if (gb.use_third_party) {
        const _h257 = gb.addGrammarChecked(tp_verilog, "", "systemverilog", "tree_sitter_systemverilog", false);
        _h257.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_vhdl = b.dependency("tp_vhdl", .{});
    if (gb.use_third_party) {
        _ = gb.addGrammarChecked(tp_vhdl, "", "vhdl", "tree_sitter_vhdl", true);
    }

    const tp_vhs = b.dependency("tp_vhs", .{});
    if (gb.use_third_party) {
        const _h258 = gb.addGrammarChecked(tp_vhs, "", "vhs", "tree_sitter_vhs", false);
        _h258.addQuery("highlights", "queries/highlights.scm");
    }

    const tp_vimdoc = b.dependency("tp_vimdoc", .{});
    if (gb.use_third_party) {
        const _h172 = gb.addGrammarChecked(tp_vimdoc, "", "vimdoc", "tree_sitter_vimdoc", false);
        _h172.addQuery("highlights", "queries/vimdoc/highlights.scm");
        _h172.addQuery("injections", "queries/vimdoc/injections.scm");
    }

    const tp_vrl = b.dependency("tp_vrl", .{});
    if (gb.use_third_party) {
        const _h173 = gb.addGrammarChecked(tp_vrl, "", "vrl", "tree_sitter_vrl", false);
        _h173.addQuery("highlights", "queries/highlights.scm");
        _h173.addQuery("injections", "queries/injections.scm");
        _h173.addQuery("folds", "queries/folds.scm");
        _h173.addQuery("indents", "queries/indents.scm");
        _h173.addQuery("locals", "queries/locals.scm");
    }

    const tp_wgsl = b.dependency("tp_wgsl", .{});
    if (gb.use_third_party) {
        const _h174 = gb.addGrammarChecked(tp_wgsl, "", "wgsl", "tree_sitter_wgsl", true);
        _h174.addQuery("highlights", "queries/highlights.scm");
        _h174.addQuery("folds", "queries/folds.scm");
    }

    const tp_wing = b.dependency("tp_wing", .{});
    if (gb.use_third_party) {
        const _h175 = gb.addGrammarChecked(tp_wing, "", "wing", "tree_sitter_wing", true);
        _h175.addQuery("highlights", "queries/highlights.scm");
        _h175.addQuery("folds", "queries/folds.scm");
        _h175.addQuery("locals", "queries/locals.scm");
    }

    const tp_wit = b.dependency("tp_wit", .{});
    if (gb.use_third_party) {
        const _h176 = gb.addGrammarChecked(tp_wit, "", "wit", "tree_sitter_wit", true);
        _h176.addQuery("highlights", "queries/highlights.scm");
        _h176.addQuery("injections", "queries/injections.scm");
        _h176.addQuery("folds", "queries/folds.scm");
    }

    const tp_xresources = b.dependency("tp_xresources", .{});
    if (gb.use_third_party) {
        const _h177 = gb.addGrammarChecked(tp_xresources, "", "xresources", "tree_sitter_xresources", false);
        _h177.addQuery("highlights", "queries/xresources/highlights.scm");
        _h177.addQuery("injections", "queries/xresources/injections.scm");
    }

    const tp_yang = b.dependency("tp_yang", .{});
    if (gb.use_third_party) {
        const _h178 = gb.addGrammarChecked(tp_yang, "", "yang", "tree_sitter_yang", false);
        _h178.addQuery("highlights", "queries/highlights.scm");
        _h178.addQuery("injections", "queries/injections.scm");
        _h178.addQuery("folds", "queries/folds.scm");
        _h178.addQuery("indents", "queries/indents.scm");
    }

    mod.addImport("grammars", gb.buildGrammarsModule());
    mod.addImport("queries", gb.buildQueriesModule());

    const test_step = b.step("test", "Run language tests");
    {
        const test_mod = b.createModule(.{
            .root_source_file = b.path("src/tests.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "eazy_zig_tree_sitter", .module = mod },
                .{ .name = "tree-sitter", .module = tree_sitter.module("tree_sitter") },
                .{ .name = "grammars", .module = gb.buildGrammarsModule() },
                .{ .name = "queries", .module = gb.buildQueriesModule() },
            },
        });
        const test_exe = b.addTest(.{ .root_module = test_mod });
        test_step.dependOn(&test_exe.step);
    }

    if (use_third_party) {
        const tp_test_mod = b.createModule(.{
            .root_source_file = b.path("src/third_party_tests.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "eazy_zig_tree_sitter", .module = mod },
                .{ .name = "tree-sitter", .module = tree_sitter.module("tree_sitter") },
                .{ .name = "grammars", .module = gb.buildGrammarsModule() },
            },
        });
        const tp_test_exe = b.addTest(.{ .root_module = tp_test_mod });
        test_step.dependOn(&tp_test_exe.step);
    }
}

const GrammarEntry = struct {
    key: []const u8,
    symbol: []const u8,
};

const GrammarHandle = struct {
    builder: *GrammarBuilder,
    dep: *std.Build.Dependency,
    key: []const u8,
    active: bool,

    fn addQuery(self: GrammarHandle, query_type: []const u8, rel_path: []const u8) void {
        if (!self.active) return;
        const b = self.builder.b;
        const query_mod = b.createModule(.{ .root_source_file = self.dep.path(rel_path) });
        self.builder.queries.append(b.allocator, .{ .key = self.key, .query_type = query_type, .module = query_mod }) catch @panic("OOM");
    }
};

const QueryEntry = struct {
    key: []const u8,
    query_type: []const u8,
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
    use_third_party: bool,
    empty_root: ?std.Build.LazyPath = null,

    fn addGrammarChecked(
        self: *GrammarBuilder,
        dep: *std.Build.Dependency,
        subdir: []const u8,
        key: []const u8,
        symbol: []const u8,
        has_scanner: bool,
    ) GrammarHandle {
        if (self.use_all_langs or
            for (self.use_langs) |lang| {
                if (std.mem.eql(u8, lang, key)) break true;
            } else false)
        {
            return self.addGrammar(dep, subdir, key, symbol, has_scanner);
        }
        return .{
            .builder = self,
            .dep = undefined,
            .key = key,
            .active = false,
        };
    }

    fn addGrammar(
        self: *GrammarBuilder,
        dep: *std.Build.Dependency,
        subdir: []const u8,
        key: []const u8,
        symbol: []const u8,
        has_scanner: bool,
    ) GrammarHandle {
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

        self.grammars.append(b.allocator, .{ .key = key, .symbol = symbol }) catch @panic("OOM");

        return .{
            .builder = self,
            .dep = dep,
            .key = key,
            .active = true,
        };
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
        src.appendSlice(b.allocator, "const std = @import(\"std\");\n") catch @panic("OOM");

        for (self.queries.items) |q| {
            src.appendSlice(b.allocator, b.fmt(
                "pub const {s}_{s} = @embedFile(\"{s}_{s}\");\n",
                .{ q.key, q.query_type, q.key, q.query_type },
            )) catch @panic("OOM");
        }

        src.appendSlice(b.allocator, "\npub const QueryData = struct { key: []const u8, query_type: []const u8, query: []const u8 };\n") catch @panic("OOM");

        src.appendSlice(b.allocator, "\npub const all_queries = [_]QueryData{\n") catch @panic("OOM");
        for (self.queries.items) |q| {
            src.appendSlice(b.allocator, b.fmt(
                "    .{{ .key = \"{s}\", .query_type = \"{s}\", .query = {s}_{s} }},\n",
                .{ q.key, q.query_type, q.key, q.query_type },
            )) catch @panic("OOM");
        }
        src.appendSlice(b.allocator, "};\n") catch @panic("OOM");

        src.appendSlice(b.allocator,
            \\pub fn getQuery(key: []const u8, query_type: []const u8) ?[]const u8 {
            \\    for (all_queries) |q| {
            \\        if (std.mem.eql(u8, q.key, key) and std.mem.eql(u8, q.query_type, query_type)) return q.query;
            \\    }
            \\    return null;
            \\}
            \\
        ) catch @panic("OOM");

        src.appendSlice(b.allocator, "\npub const queries = std.StaticStringMap([]const u8).initComptime(.{\n") catch @panic("OOM");
        for (self.queries.items) |q| {
            if (std.mem.eql(u8, q.query_type, "highlights")) {
                src.appendSlice(b.allocator, b.fmt(
                    "    .{{ \"{s}\", {s}_highlights }},\n",
                    .{ q.key, q.key },
                )) catch @panic("OOM");
            }
        }
        src.appendSlice(b.allocator, "});\n") catch @panic("OOM");

        var imports: std.ArrayList(std.Build.Module.Import) = .empty;
        for (self.queries.items) |q| {
            imports.append(b.allocator, .{ .name = b.fmt("{s}_{s}", .{ q.key, q.query_type }), .module = q.module }) catch @panic("OOM");
        }

        const wf = b.addWriteFiles();
        self.queries_module = b.createModule(.{
            .root_source_file = wf.add("queries.zig", src.items),
            .imports = imports.items,
        });
        return self.queries_module.?;
    }
};
