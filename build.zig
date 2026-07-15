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

    const use_third_party = b.option(bool, "third-party", "Include third-party community grammars (not from tree-sitter or tree-sitter-grammars orgs)") orelse false;

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
    gb.addGrammarChecked(ts_c, "", "c", "tree_sitter_c", false, "queries/highlights.scm");

    const ts_md = b.dependency("tree_sitter_markdown", .{});
    gb.addGrammarChecked(ts_md, "tree-sitter-markdown", "md", "tree_sitter_markdown", true, "queries/highlights.scm");
    gb.addGrammarChecked(ts_md, "tree-sitter-markdown-inline", "md_inline", "tree_sitter_markdown_inline", true, "queries/highlights.scm");

    const ts_lua = b.dependency("tree_sitter_lua", .{});
    gb.addGrammarChecked(ts_lua, "", "lua", "tree_sitter_lua", true, "queries/highlights.scm");

    const ts_query = b.dependency("tree_sitter_query", .{});
    gb.addGrammarChecked(ts_query, "", "query", "tree_sitter_query", false, null);

    const ts_commonlisp = b.dependency("tree_sitter_commonlisp", .{});
    gb.addGrammarChecked(ts_commonlisp, "", "lisp", "tree_sitter_commonlisp", false, null);

    const ts_hcl = b.dependency("tree_sitter_hcl", .{});
    gb.addGrammarChecked(ts_hcl, "dialects/terraform", "tf", "tree_sitter_terraform", true, null);
    gb.addGrammarChecked(ts_hcl, "", "hcl", "tree_sitter_hcl", true, null);

    const ts_cuda = b.dependency("tree_sitter_cuda", .{});
    gb.addGrammarChecked(ts_cuda, "", "cuda", "tree_sitter_cuda", true, "queries/highlights.scm");

    const ts_glsl = b.dependency("tree_sitter_glsl", .{});
    gb.addGrammarChecked(ts_glsl, "", "glsl", "tree_sitter_glsl", false, "queries/highlights.scm");

    const ts_diff = b.dependency("tree_sitter_diff", .{});
    gb.addGrammarChecked(ts_diff, "", "diff", "tree_sitter_diff", false, "queries/highlights.scm");

    const ts_hlsl = b.dependency("tree_sitter_hlsl", .{});
    gb.addGrammarChecked(ts_hlsl, "", "hlsl", "tree_sitter_hlsl", true, null);

    const ts_ungrammar = b.dependency("tree_sitter_ungrammar", .{});
    gb.addGrammarChecked(ts_ungrammar, "", "ungrammar", "tree_sitter_ungrammar", false, "queries/highlights.scm");

    const ts_thrift = b.dependency("tree_sitter_thrift", .{});
    gb.addGrammarChecked(ts_thrift, "", "thrift", "tree_sitter_thrift", false, "queries/highlights.scm");

    const ts_meson = b.dependency("tree_sitter_meson", .{});
    gb.addGrammarChecked(ts_meson, "", "meson", "tree_sitter_meson", false, "queries/highlights.scm");

    const ts_gitattributes = b.dependency("tree_sitter_gitattributes", .{});
    gb.addGrammarChecked(ts_gitattributes, "", "gitattributes", "tree_sitter_gitattributes", false, "queries/highlights.scm");

    const ts_pymanifest = b.dependency("tree_sitter_pymanifest", .{});
    gb.addGrammarChecked(ts_pymanifest, "", "pymanifest", "tree_sitter_pymanifest", false, "queries/highlights.scm");

    const ts_poe_filter = b.dependency("tree_sitter_poe_filter", .{});
    gb.addGrammarChecked(ts_poe_filter, "", "poe_filter", "tree_sitter_poe_filter", false, "queries/highlights.scm");

    const ts_tcl = b.dependency("tree_sitter_tcl", .{});
    gb.addGrammarChecked(ts_tcl, "", "tcl", "tree_sitter_tcl", true, null);

    const ts_chatito = b.dependency("tree_sitter_chatito", .{});
    gb.addGrammarChecked(ts_chatito, "extensions/chatl", "chatl", "tree_sitter_chatl", false, null);
    gb.addGrammarChecked(ts_chatito, "", "chatito", "tree_sitter_chatito", false, "queries/highlights.scm");

    const ts_arduino = b.dependency("tree_sitter_arduino", .{});
    gb.addGrammarChecked(ts_arduino, "", "ino", "tree_sitter_arduino", true, "queries/highlights.scm");

    const ts_wgsl_bevy = b.dependency("tree_sitter_wgsl_bevy", .{});
    gb.addGrammarChecked(ts_wgsl_bevy, "", "wgsl_bevy", "tree_sitter_wgsl_bevy", true, null);


    const ts_capnp = b.dependency("tree_sitter_capnp", .{});
    gb.addGrammarChecked(ts_capnp, "", "capnp", "tree_sitter_capnp", false, "queries/highlights.scm");

    const ts_kdl = b.dependency("tree_sitter_kdl", .{});
    gb.addGrammarChecked(ts_kdl, "", "kdl", "tree_sitter_kdl", true, "queries/highlights.scm");

    const ts_func = b.dependency("tree_sitter_func", .{});
    gb.addGrammarChecked(ts_func, "", "func", "tree_sitter_func", false, "queries/highlights.scm");

    const ts_move = b.dependency("tree_sitter_move", .{});
    gb.addGrammarChecked(ts_move, "", "move", "tree_sitter_move", false, null);

    const ts_go_sum = b.dependency("tree_sitter_go_sum", .{});
    gb.addGrammarChecked(ts_go_sum, "", "gosum", "tree_sitter_gosum", false, "queries/highlights.scm");

    const ts_ron = b.dependency("tree_sitter_ron", .{});
    gb.addGrammarChecked(ts_ron, "", "ron", "tree_sitter_ron", true, "queries/highlights.scm");

    const ts_po = b.dependency("tree_sitter_po", .{});
    gb.addGrammarChecked(ts_po, "", "po", "tree_sitter_po", false, "queries/highlights.scm");

    const ts_starlark = b.dependency("tree_sitter_starlark", .{});
    gb.addGrammarChecked(ts_starlark, "", "starlark", "tree_sitter_starlark", true, "queries/highlights.scm");

    const ts_yuck = b.dependency("tree_sitter_yuck", .{});
    gb.addGrammarChecked(ts_yuck, "", "yuck", "tree_sitter_yuck", true, "queries/highlights.scm");

    const ts_smali = b.dependency("tree_sitter_smali", .{});
    gb.addGrammarChecked(ts_smali, "", "smali", "tree_sitter_smali", true, "queries/highlights.scm");

    const ts_bicep = b.dependency("tree_sitter_bicep", .{});
    gb.addGrammarChecked(ts_bicep, "", "bicep", "tree_sitter_bicep", true, "queries/highlights.scm");

    const ts_cpon = b.dependency("tree_sitter_cpon", .{});
    gb.addGrammarChecked(ts_cpon, "", "cpon", "tree_sitter_cpon", false, "queries/highlights.scm");

    const ts_firrtl = b.dependency("tree_sitter_firrtl", .{});
    gb.addGrammarChecked(ts_firrtl, "", "firrtl", "tree_sitter_firrtl", true, "queries/highlights.scm");

    const ts_luap = b.dependency("tree_sitter_luap", .{});
    gb.addGrammarChecked(ts_luap, "", "luap", "tree_sitter_luap", false, "queries/highlights.scm");

    const ts_squirrel = b.dependency("tree_sitter_squirrel", .{});
    gb.addGrammarChecked(ts_squirrel, "", "squirrel", "tree_sitter_squirrel", true, "queries/highlights.scm");

    const ts_uxntal = b.dependency("tree_sitter_uxntal", .{});
    gb.addGrammarChecked(ts_uxntal, "", "uxntal", "tree_sitter_uxntal", true, "queries/highlights.scm");

    const ts_cairo = b.dependency("tree_sitter_cairo", .{});
    gb.addGrammarChecked(ts_cairo, "", "cairo", "tree_sitter_cairo", true, "queries/highlights.scm");

    const ts_odin = b.dependency("tree_sitter_odin", .{});
    gb.addGrammarChecked(ts_odin, "", "odin", "tree_sitter_odin", true, "queries/highlights.scm");

    const ts_hare = b.dependency("tree_sitter_hare", .{});
    gb.addGrammarChecked(ts_hare, "", "hare", "tree_sitter_hare", false, "queries/highlights.scm");

    const ts_pony = b.dependency("tree_sitter_pony", .{});
    gb.addGrammarChecked(ts_pony, "", "pony", "tree_sitter_pony", true, "queries/highlights.scm");

    const ts_tablegen = b.dependency("tree_sitter_tablegen", .{});
    gb.addGrammarChecked(ts_tablegen, "", "tablegen", "tree_sitter_tablegen", true, "queries/highlights.scm");

    const ts_luadoc = b.dependency("tree_sitter_luadoc", .{});
    gb.addGrammarChecked(ts_luadoc, "", "luadoc", "tree_sitter_luadoc", false, "queries/highlights.scm");

    const ts_kotlin = b.dependency("tree_sitter_kotlin", .{});
    gb.addGrammarChecked(ts_kotlin, "", "kt", "tree_sitter_kotlin", true, null);

    const ts_vim = b.dependency("tree_sitter_vim", .{});
    gb.addGrammarChecked(ts_vim, "", "vim", "tree_sitter_vim", true, null);

    const ts_puppet = b.dependency("tree_sitter_puppet", .{});
    gb.addGrammarChecked(ts_puppet, "", "puppet", "tree_sitter_puppet", false, "queries/highlights.scm");

    const ts_luau = b.dependency("tree_sitter_luau", .{});
    gb.addGrammarChecked(ts_luau, "", "luau", "tree_sitter_luau", true, "queries/highlights.scm");

    const ts_objc = b.dependency("tree_sitter_objc", .{});
    gb.addGrammarChecked(ts_objc, "", "objc", "tree_sitter_objc", false, "queries/highlights.scm");

    const ts_ispc = b.dependency("tree_sitter_ispc", .{});
    gb.addGrammarChecked(ts_ispc, "", "ispc", "tree_sitter_ispc", false, "queries/highlights.scm");

    const ts_pem = b.dependency("tree_sitter_pem", .{});
    gb.addGrammarChecked(ts_pem, "", "pem", "tree_sitter_pem", false, "queries/highlights.scm");

    const ts_requirements = b.dependency("tree_sitter_requirements", .{});
    gb.addGrammarChecked(ts_requirements, "", "requirements", "tree_sitter_requirements", false, "queries/highlights.scm");

    const ts_xml = b.dependency("tree_sitter_xml", .{});
    gb.addGrammarChecked(ts_xml, "dtd", "dtd", "tree_sitter_dtd", true, null);
    gb.addGrammarChecked(ts_xml, "xml", "xml", "tree_sitter_xml", true, null);

    const ts_gpg_config = b.dependency("tree_sitter_gpg_config", .{});
    gb.addGrammarChecked(ts_gpg_config, "", "gpg", "tree_sitter_gpg", false, "queries/highlights.scm");

    const ts_bitbake = b.dependency("tree_sitter_bitbake", .{});
    gb.addGrammarChecked(ts_bitbake, "", "bb", "tree_sitter_bitbake", true, "queries/highlights.scm");

    const ts_csv = b.dependency("tree_sitter_csv", .{});
    gb.addGrammarChecked(ts_csv, "csv", "csv", "tree_sitter_csv", false, "queries/highlights.scm");
    gb.addGrammarChecked(ts_csv, "psv", "psv", "tree_sitter_psv", false, "queries/highlights.scm");
    gb.addGrammarChecked(ts_csv, "tsv", "tsv", "tree_sitter_tsv", false, "queries/highlights.scm");

    const ts_hyprlang = b.dependency("tree_sitter_hyprlang", .{});
    gb.addGrammarChecked(ts_hyprlang, "", "hyprlang", "tree_sitter_hyprlang", false, null);

    const ts_printf = b.dependency("tree_sitter_printf", .{});
    gb.addGrammarChecked(ts_printf, "", "printf", "tree_sitter_printf", false, "queries/highlights.scm");

    const ts_gstlaunch = b.dependency("tree_sitter_gstlaunch", .{});
    gb.addGrammarChecked(ts_gstlaunch, "", "gstlaunch", "tree_sitter_gstlaunch", false, null);

    const ts_re2c = b.dependency("tree_sitter_re2c", .{});
    gb.addGrammarChecked(ts_re2c, "", "re2c", "tree_sitter_re2c", false, "queries/highlights.scm");

    const ts_doxygen = b.dependency("tree_sitter_doxygen", .{});
    gb.addGrammarChecked(ts_doxygen, "", "doxygen", "tree_sitter_doxygen", true, "queries/highlights.scm");

    const ts_zsh = b.dependency("tree_sitter_zsh", .{});
    gb.addGrammarChecked(ts_zsh, "", "zsh", "tree_sitter_zsh", true, null);

    const ts_ssh_config = b.dependency("tree_sitter_ssh_config", .{});
    gb.addGrammarChecked(ts_ssh_config, "", "ssh_config", "tree_sitter_ssh_config", false, "queries/highlights.scm");

    const ts_nqc = b.dependency("tree_sitter_nqc", .{});
    gb.addGrammarChecked(ts_nqc, "", "nqc", "tree_sitter_nqc", false, "queries/highlights.scm");

    const ts_kconfig = b.dependency("tree_sitter_kconfig", .{});
    gb.addGrammarChecked(ts_kconfig, "", "kconfig", "tree_sitter_kconfig", true, "queries/highlights.scm");

    const ts_gn = b.dependency("tree_sitter_gn", .{});
    gb.addGrammarChecked(ts_gn, "", "gn", "tree_sitter_gn", true, "queries/highlights.scm");

    const ts_udev = b.dependency("tree_sitter_udev", .{});
    gb.addGrammarChecked(ts_udev, "", "udev", "tree_sitter_udev", false, "queries/highlights.scm");

    const ts_xcompose = b.dependency("tree_sitter_xcompose", .{});
    gb.addGrammarChecked(ts_xcompose, "", "xcompose", "tree_sitter_xcompose", false, "queries/highlights.scm");

    const ts_slang = b.dependency("tree_sitter_slang", .{});
    gb.addGrammarChecked(ts_slang, "", "slang", "tree_sitter_slang", true, null);

    const ts_linkerscript = b.dependency("tree_sitter_linkerscript", .{});
    gb.addGrammarChecked(ts_linkerscript, "", "linkerscript", "tree_sitter_linkerscript", false, "queries/highlights.scm");

    const ts_properties = b.dependency("tree_sitter_properties", .{});
    gb.addGrammarChecked(ts_properties, "", "properties", "tree_sitter_properties", true, "queries/highlights.scm");

    const ts_readline = b.dependency("tree_sitter_readline", .{});
    gb.addGrammarChecked(ts_readline, "", "readline", "tree_sitter_readline", false, "queries/highlights.scm");

    const ts_make = b.dependency("tree_sitter_make", .{});
    gb.addGrammarChecked(ts_make, "", "Makefile", "tree_sitter_make", false, "queries/highlights.scm");

    const ts_yaml = b.dependency("tree_sitter_yaml", .{});
    gb.addGrammarChecked(ts_yaml, "schema/core", "core_schema", "tree_sitter_core_schema", false, null);
    gb.addGrammarChecked(ts_yaml, "schema/json", "json_schema", "tree_sitter_json_schema", false, null);
    gb.addGrammarChecked(ts_yaml, "schema/legacy", "legacy_schema", "tree_sitter_legacy_schema", false, null);
    gb.addGrammarChecked(ts_yaml, "", "yaml", "tree_sitter_yaml", true, "queries/highlights.scm");

    const ts_toml = b.dependency("tree_sitter_toml", .{});
    gb.addGrammarChecked(ts_toml, "", "toml", "tree_sitter_toml", true, "queries/highlights.scm");

    const ts_vue = b.dependency("tree_sitter_vue", .{});
    gb.addGrammarChecked(ts_vue, "", "vue", "tree_sitter_vue", true, null);

    const ts_qmldir = b.dependency("tree_sitter_qmldir", .{});
    gb.addGrammarChecked(ts_qmldir, "", "qmldir", "tree_sitter_qmldir", false, null);

    const ts_zig = b.dependency("fork_zig", .{});
    gb.addGrammarChecked(ts_zig, "", "zig", "tree_sitter_zig", false, null);


    const ts_svelte = b.dependency("tree_sitter_svelte", .{});
    gb.addGrammarChecked(ts_svelte, "", "svelte", "tree_sitter_svelte", true, "queries/highlights.scm");

    const ts_test = b.dependency("tree_sitter_test", .{});
    gb.addGrammarChecked(ts_test, "", "test", "tree_sitter_test", true, null);

    const ts_scss = b.dependency("tree_sitter_scss", .{});
    gb.addGrammarChecked(ts_scss, "", "scss", "tree_sitter_scss", true, "queries/highlights.scm");

    const ts_cst = b.dependency("tree_sitter_cst", .{});
    gb.addGrammarChecked(ts_cst, "", "cst", "tree_sitter_cst", false, "queries/highlights.scm");

    const ts_julia = b.dependency("tree_sitter_julia", .{});
    gb.addGrammarChecked(ts_julia, "", "jl", "tree_sitter_julia", true, "queries/highlights.scm");

    const ts_haskell = b.dependency("tree_sitter_haskell", .{});
    gb.addGrammarChecked(ts_haskell, "", "hs", "tree_sitter_haskell", true, "queries/highlights.scm");

    const ts_cyberchef = b.dependency("tree_sitter_cyberchef", .{});
    gb.addGrammarChecked(ts_cyberchef, "", "cyberchef", "tree_sitter_cyberchef", false, "queries/highlights.scm");

    const ts_javascript = b.dependency("tree_sitter_javascript", .{});
    gb.addGrammarChecked(ts_javascript, "", "js", "tree_sitter_javascript", true, "queries/highlights.scm");

    const ts_json = b.dependency("tree_sitter_json", .{});
    gb.addGrammarChecked(ts_json, "", "json", "tree_sitter_json", false, "queries/highlights.scm");

    const ts_cpp = b.dependency("tree_sitter_cpp", .{});
    gb.addGrammarChecked(ts_cpp, "", "cpp", "tree_sitter_cpp", true, "queries/highlights.scm");

    const ts_ruby = b.dependency("tree_sitter_ruby", .{});
    gb.addGrammarChecked(ts_ruby, "", "rb", "tree_sitter_ruby", true, "queries/highlights.scm");

    const ts_go = b.dependency("tree_sitter_go", .{});
    gb.addGrammarChecked(ts_go, "", "go", "tree_sitter_go", false, "queries/highlights.scm");

    const ts_c_sharp = b.dependency("tree_sitter_c_sharp", .{});
    gb.addGrammarChecked(ts_c_sharp, "", "cs", "tree_sitter_c_sharp", true, "queries/highlights.scm");

    const ts_python = b.dependency("tree_sitter_python", .{});
    gb.addGrammarChecked(ts_python, "", "py", "tree_sitter_python", true, "queries/highlights.scm");

    const ts_typescript = b.dependency("tree_sitter_typescript", .{});
    gb.addGrammarChecked(ts_typescript, "tsx", "tsx", "tree_sitter_tsx", true, null);
    gb.addGrammarChecked(ts_typescript, "typescript", "ts", "tree_sitter_typescript", true, null);

    const ts_rust = b.dependency("tree_sitter_rust", .{});
    gb.addGrammarChecked(ts_rust, "", "rs", "tree_sitter_rust", true, "queries/highlights.scm");

    const ts_bash = b.dependency("tree_sitter_bash", .{});
    gb.addGrammarChecked(ts_bash, "", "sh", "tree_sitter_bash", true, "queries/highlights.scm");

    const ts_php = b.dependency("tree_sitter_php", .{});
    gb.addGrammarChecked(ts_php, "php", "php", "tree_sitter_php", true, null);
    gb.addGrammarChecked(ts_php, "php_only", "php_only", "tree_sitter_php_only", true, null);

    const ts_java = b.dependency("tree_sitter_java", .{});
    gb.addGrammarChecked(ts_java, "", "java", "tree_sitter_java", false, "queries/highlights.scm");

    const ts_scala = b.dependency("tree_sitter_scala", .{});
    gb.addGrammarChecked(ts_scala, "", "scala", "tree_sitter_scala", true, "queries/highlights.scm");

    const ts_ocaml = b.dependency("tree_sitter_ocaml", .{});
    gb.addGrammarChecked(ts_ocaml, "grammars/interface", "mli", "tree_sitter_ocaml_interface", true, null);
    gb.addGrammarChecked(ts_ocaml, "grammars/ocaml", "ml", "tree_sitter_ocaml", true, null);
    gb.addGrammarChecked(ts_ocaml, "grammars/type", "mly", "tree_sitter_ocaml_type", true, null);

    const ts_agda = b.dependency("tree_sitter_agda", .{});
    gb.addGrammarChecked(ts_agda, "", "agda", "tree_sitter_agda", true, "queries/highlights.scm");

    const ts_fluent = b.dependency("tree_sitter_fluent", .{});
    gb.addGrammarChecked(ts_fluent, "", "fluent", "tree_sitter_fluent", true, null);

    const ts_html = b.dependency("tree_sitter_html", .{});
    gb.addGrammarChecked(ts_html, "", "html", "tree_sitter_html", true, "queries/highlights.scm");

    const ts_embedded_template = b.dependency("tree_sitter_embedded_template", .{});
    gb.addGrammarChecked(ts_embedded_template, "", "embedded_template", "tree_sitter_embedded_template", false, "queries/highlights.scm");

    const ts_regex = b.dependency("tree_sitter_regex", .{});
    gb.addGrammarChecked(ts_regex, "", "regex", "tree_sitter_regex", false, "queries/highlights.scm");

    const ts_css = b.dependency("tree_sitter_css", .{});
    gb.addGrammarChecked(ts_css, "", "css", "tree_sitter_css", true, "queries/highlights.scm");

    const ts_verilog = b.dependency("tree_sitter_verilog", .{});
    gb.addGrammarChecked(ts_verilog, "", "v", "tree_sitter_verilog", false, null);

    const ts_jsdoc = b.dependency("tree_sitter_jsdoc", .{});
    gb.addGrammarChecked(ts_jsdoc, "", "jsdoc", "tree_sitter_jsdoc", true, "queries/highlights.scm");

    const ts_ql = b.dependency("tree_sitter_ql", .{});
    gb.addGrammarChecked(ts_ql, "", "ql", "tree_sitter_ql", false, "queries/highlights.scm");

    const ts_tsq = b.dependency("tree_sitter_tsq", .{});
    gb.addGrammarChecked(ts_tsq, "", "tsq", "tree_sitter_tsq", false, null);

    const ts_ql_dbscheme = b.dependency("tree_sitter_ql_dbscheme", .{});
    gb.addGrammarChecked(ts_ql_dbscheme, "", "ql_dbscheme", "tree_sitter_ql_dbscheme", false, null);

    // ============================
    // Third-Party Grammars (gated by --third-party flag)
    // ============================

    const tp_ada = b.dependency("tp_ada", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ada, "", "ada", "ada", false, null);
    }

    const tp_angular = b.dependency("tp_angular", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_angular, "", "angular", "angular", true, null);
    }

    const tp_apex = b.dependency("tp_apex", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_apex, "apex", "apex", "apex", false, null);
    }

    const tp_asm = b.dependency("tp_asm", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_asm, "", "asm", "asm", false, null);
    }

    const tp_astro = b.dependency("tp_astro", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_astro, "", "astro", "astro", true, null);
    }

    const tp_authzed = b.dependency("tp_authzed", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_authzed, "", "authzed", "authzed", false, null);
    }

    const tp_awk = b.dependency("tp_awk", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_awk, "", "awk", "awk", true, null);
    }

    const tp_bass = b.dependency("tp_bass", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_bass, "", "bass", "bass", false, null);
    }

    const tp_beancount = b.dependency("tp_beancount", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_beancount, "", "beancount", "beancount", true, null);
    }

    const tp_bibtex = b.dependency("tp_bibtex", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_bibtex, "", "bibtex", "bibtex", false, null);
    }

    const tp_blade = b.dependency("tp_blade", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_blade, "", "blade", "blade", true, null);
    }

    const tp_bp = b.dependency("tp_bp", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_bp, "", "bp", "bp", false, null);
    }

    const tp_brightscript = b.dependency("tp_brightscript", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_brightscript, "", "brightscript", "brightscript", false, null);
    }

    const tp_caddy = b.dependency("tp_caddy", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_caddy, "", "caddy", "caddy", true, null);
    }

    const tp_circom = b.dependency("tp_circom", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_circom, "", "circom", "circom", false, null);
    }

    const tp_clojure = b.dependency("tp_clojure", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_clojure, "", "clojure", "clojure", false, null);
    }

    const tp_cmake = b.dependency("tp_cmake", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_cmake, "", "cmake", "cmake", true, null);
    }

    const tp_comment = b.dependency("tp_comment", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_comment, "", "comment", "comment", true, null);
    }

    const tp_cooklang = b.dependency("tp_cooklang", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_cooklang, "", "cooklang", "cooklang", true, null);
    }

    const tp_corn = b.dependency("tp_corn", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_corn, "", "corn", "corn", false, null);
    }

    const tp_cue = b.dependency("tp_cue", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_cue, "", "cue", "cue", true, null);
    }

    const tp_cylc = b.dependency("tp_cylc", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_cylc, "", "cylc", "cylc", false, null);
    }

    const tp_d = b.dependency("tp_d", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_d, "", "d", "d", true, null);
    }

    const tp_dart = b.dependency("tp_dart", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_dart, "", "dart", "dart", true, null);
    }

    const tp_desktop = b.dependency("tp_desktop", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_desktop, "", "desktop", "desktop", false, null);
    }

    const tp_dhall = b.dependency("tp_dhall", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_dhall, "", "dhall", "dhall", true, null);
    }

    const tp_disassembly = b.dependency("tp_disassembly", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_disassembly, "", "disassembly", "disassembly", true, null);
    }

    const tp_djot = b.dependency("tp_djot", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_djot, "", "djot", "djot", true, null);
    }

    const tp_dockerfile = b.dependency("tp_dockerfile", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_dockerfile, "", "dockerfile", "dockerfile", true, null);
    }

    const tp_dot = b.dependency("tp_dot", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_dot, "", "dot", "dot", false, null);
    }

    const tp_earthfile = b.dependency("tp_earthfile", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_earthfile, "", "earthfile", "earthfile", true, null);
    }

    const tp_ebnf = b.dependency("tp_ebnf", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ebnf, "crates/tree-sitter-ebnf", "ebnf", "ebnf", false, null);
    }

    const tp_editorconfig = b.dependency("tp_editorconfig", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_editorconfig, "", "editorconfig", "editorconfig", true, null);
    }

    const tp_eds = b.dependency("tp_eds", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_eds, "", "eds", "eds", false, null);
    }

    const tp_eex = b.dependency("tp_eex", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_eex, "", "eex", "eex", false, null);
    }

    const tp_elixir = b.dependency("tp_elixir", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_elixir, "", "elixir", "elixir", true, null);
    }

    const tp_elm = b.dependency("tp_elm", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_elm, "", "elm", "elm", true, null);
    }

    const tp_elsa = b.dependency("tp_elsa", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_elsa, "", "elsa", "elsa", false, null);
    }

    const tp_elvish = b.dependency("tp_elvish", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_elvish, "", "elvish", "elvish", false, null);
    }

    const tp_enforce = b.dependency("tp_enforce", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_enforce, "", "enforce", "enforce", false, null);
    }

    const tp_erlang = b.dependency("tp_erlang", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_erlang, "", "erlang", "erlang", true, null);
    }

    const tp_facility = b.dependency("tp_facility", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_facility, "", "facility", "facility", false, null);
    }

    const tp_faust = b.dependency("tp_faust", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_faust, "", "faust", "faust", false, null);
    }

    const tp_fennel = b.dependency("tp_fennel", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_fennel, "", "fennel", "fennel", true, null);
    }

    const tp_fidl = b.dependency("tp_fidl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_fidl, "", "fidl", "fidl", false, null);
    }

    const tp_fish = b.dependency("tp_fish", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_fish, "", "fish", "fish", true, null);
    }

    const tp_foam = b.dependency("tp_foam", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_foam, "", "foam", "foam", true, null);
    }

    const tp_forth = b.dependency("tp_forth", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_forth, "", "forth", "forth", false, null);
    }

    const tp_fortran = b.dependency("tp_fortran", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_fortran, "", "fortran", "fortran", true, null);
    }

    const tp_fsh = b.dependency("tp_fsh", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_fsh, "", "fsh", "fsh", false, null);
    }

    const tp_fsharp = b.dependency("tp_fsharp", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_fsharp, "fsharp", "fsharp", "fsharp", true, null);
    }

    const tp_gap = b.dependency("tp_gap", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gap, "", "gap", "gap", true, null);
    }

    const tp_gaptst = b.dependency("tp_gaptst", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gaptst, "", "gaptst", "gaptst", true, null);
    }

    const tp_gdshader = b.dependency("tp_gdshader", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gdshader, "", "gdshader", "gdshader", false, null);
    }

    const tp_git_config = b.dependency("tp_git_config", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_git_config, "", "git_config", "git_config", false, null);
    }

    const tp_git_rebase = b.dependency("tp_git_rebase", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_git_rebase, "", "git_rebase", "git_rebase", false, null);
    }

    const tp_gitattributes = b.dependency("tp_gitattributes", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gitattributes, "", "gitattributes", "gitattributes", false, null);
    }

    const tp_gitcommit = b.dependency("tp_gitcommit", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gitcommit, "", "gitcommit", "gitcommit", true, null);
    }

    const tp_gitignore = b.dependency("tp_gitignore", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gitignore, "", "gitignore", "gitignore", false, null);
    }

    const tp_gleam = b.dependency("tp_gleam", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gleam, "", "gleam", "gleam", true, null);
    }

    const tp_glimmer = b.dependency("tp_glimmer", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_glimmer, "", "glimmer", "glimmer", true, null);
    }

    const tp_glimmer_javascript = b.dependency("tp_glimmer_javascript", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_glimmer_javascript, "", "glimmer_javascript", "glimmer_javascript", true, null);
    }

    const tp_glimmer_typescript = b.dependency("tp_glimmer_typescript", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_glimmer_typescript, "", "glimmer_typescript", "glimmer_typescript", true, null);
    }

    const tp_gnuplot = b.dependency("tp_gnuplot", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gnuplot, "", "gnuplot", "gnuplot", true, null);
    }

    const tp_goctl = b.dependency("tp_goctl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_goctl, "", "goctl", "goctl", false, null);
    }

    const tp_godot_resource = b.dependency("tp_godot_resource", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_godot_resource, "", "godot_resource", "godot_resource", true, null);
    }

    const tp_gomod = b.dependency("tp_gomod", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gomod, "", "gomod", "gomod", false, null);
    }

    const tp_gowork = b.dependency("tp_gowork", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gowork, "", "gowork", "gowork", false, null);
    }

    const tp_graphql = b.dependency("tp_graphql", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_graphql, "", "graphql", "graphql", false, null);
    }

    const tp_gren = b.dependency("tp_gren", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_gren, "", "gren", "gren", true, null);
    }

    const tp_groovy = b.dependency("tp_groovy", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_groovy, "", "groovy", "groovy", false, null);
    }

    const tp_hack = b.dependency("tp_hack", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_hack, "", "hack", "hack", true, null);
    }

    const tp_haskell_persistent = b.dependency("tp_haskell_persistent", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_haskell_persistent, "", "haskell_persistent", "haskell_persistent", true, null);
    }

    const tp_heex = b.dependency("tp_heex", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_heex, "", "heex", "heex", false, null);
    }

    const tp_hjson = b.dependency("tp_hjson", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_hjson, "", "hjson", "hjson", false, null);
    }

    const tp_hocon = b.dependency("tp_hocon", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_hocon, "", "hocon", "hocon", false, null);
    }

    const tp_hoon = b.dependency("tp_hoon", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_hoon, "", "hoon", "hoon", true, null);
    }

    const tp_htmldjango = b.dependency("tp_htmldjango", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_htmldjango, "", "htmldjango", "htmldjango", false, null);
    }

    const tp_http = b.dependency("tp_http", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_http, "", "http", "http", false, null);
    }

    const tp_hurl = b.dependency("tp_hurl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_hurl, "", "hurl", "hurl", false, null);
    }

    const tp_idl = b.dependency("tp_idl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_idl, "", "idl", "idl", false, null);
    }

    const tp_idris = b.dependency("tp_idris", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_idris, "", "idris", "idris", true, null);
    }

    const tp_ini = b.dependency("tp_ini", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ini, "", "ini", "ini", false, null);
    }

    const tp_inko = b.dependency("tp_inko", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_inko, "", "inko", "inko", false, null);
    }

    const tp_janet_simple = b.dependency("tp_janet_simple", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_janet_simple, "", "janet_simple", "janet_simple", true, null);
    }

    const tp_javadoc = b.dependency("tp_javadoc", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_javadoc, "", "javadoc", "javadoc", true, null);
    }

    const tp_jinja = b.dependency("tp_jinja", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_jinja, "tree-sitter-jinja", "jinja", "jinja", true, null);
    }

    const tp_jinja_inline = b.dependency("tp_jinja_inline", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_jinja_inline, "tree-sitter-jinja_inline", "jinja_inline", "jinja_inline", true, null);
    }

    const tp_jq = b.dependency("tp_jq", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_jq, "", "jq", "jq", false, null);
    }

    const tp_json5 = b.dependency("tp_json5", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_json5, "", "json5", "json5", false, null);
    }

    const tp_jsonnet = b.dependency("tp_jsonnet", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_jsonnet, "", "jsonnet", "jsonnet", true, null);
    }

    const tp_just = b.dependency("tp_just", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_just, "", "just", "just", true, null);
    }

    const tp_kcl = b.dependency("tp_kcl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_kcl, "", "kcl", "kcl", true, null);
    }

    const tp_koto = b.dependency("tp_koto", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_koto, "", "koto", "koto", true, null);
    }

    const tp_kusto = b.dependency("tp_kusto", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_kusto, "", "kusto", "kusto", false, null);
    }

    const tp_lalrpop = b.dependency("tp_lalrpop", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_lalrpop, "", "lalrpop", "lalrpop", true, null);
    }

    const tp_ledger = b.dependency("tp_ledger", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ledger, "", "ledger", "ledger", false, null);
    }

    const tp_leo = b.dependency("tp_leo", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_leo, "", "leo", "leo", false, null);
    }

    const tp_liquid = b.dependency("tp_liquid", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_liquid, "", "liquid", "liquid", true, null);
    }

    const tp_liquidsoap = b.dependency("tp_liquidsoap", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_liquidsoap, "", "liquidsoap", "liquidsoap", true, null);
    }

    const tp_llvm = b.dependency("tp_llvm", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_llvm, "", "llvm", "llvm", false, null);
    }

    const tp_m68k = b.dependency("tp_m68k", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_m68k, "", "m68k", "m68k", false, null);
    }

    const tp_menhir = b.dependency("tp_menhir", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_menhir, "", "menhir", "menhir", true, null);
    }

    const tp_mermaid = b.dependency("tp_mermaid", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_mermaid, "", "mermaid", "mermaid", false, null);
    }

    const tp_mlir = b.dependency("tp_mlir", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_mlir, "", "mlir", "mlir", false, null);
    }

    const tp_nasm = b.dependency("tp_nasm", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nasm, "", "nasm", "nasm", false, null);
    }

    const tp_nginx = b.dependency("tp_nginx", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nginx, "", "nginx", "nginx", true, null);
    }

    const tp_nickel = b.dependency("tp_nickel", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nickel, "", "nickel", "nickel", true, null);
    }

    const tp_nim = b.dependency("tp_nim", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nim, "", "nim", "nim", true, null);
    }

    const tp_nim_format_string = b.dependency("tp_nim_format_string", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nim_format_string, "", "nim_format_string", "nim_format_string", false, null);
    }

    const tp_ninja = b.dependency("tp_ninja", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ninja, "", "ninja", "ninja", false, null);
    }

    const tp_nix = b.dependency("tp_nix", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nix, "", "nix", "nix", true, null);
    }

    const tp_norg = b.dependency("tp_norg", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_norg, "", "norg", "norg", true, null);
    }

    const tp_nu = b.dependency("tp_nu", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_nu, "", "nu", "nu", true, null);
    }

    const tp_objdump = b.dependency("tp_objdump", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_objdump, "", "objdump", "objdump", true, null);
    }

    const tp_ocamllex = b.dependency("tp_ocamllex", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ocamllex, "", "ocamllex", "ocamllex", true, null);
    }

    const tp_pascal = b.dependency("tp_pascal", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_pascal, "", "pascal", "pascal", false, null);
    }

    const tp_passwd = b.dependency("tp_passwd", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_passwd, "", "passwd", "passwd", false, null);
    }

    const tp_phpdoc = b.dependency("tp_phpdoc", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_phpdoc, "", "phpdoc", "phpdoc", true, null);
    }

    const tp_pioasm = b.dependency("tp_pioasm", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_pioasm, "", "pioasm", "pioasm", true, null);
    }

    const tp_powershell = b.dependency("tp_powershell", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_powershell, "", "powershell", "powershell", true, null);
    }

    const tp_prisma = b.dependency("tp_prisma", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_prisma, "", "prisma", "prisma", false, null);
    }

    const tp_problog = b.dependency("tp_problog", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_problog, "grammars/problog", "problog", "problog", false, null);
    }

    const tp_prolog = b.dependency("tp_prolog", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_prolog, "grammars/prolog", "prolog", "prolog", false, null);
    }

    const tp_promql = b.dependency("tp_promql", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_promql, "", "promql", "promql", false, null);
    }

    const tp_proto = b.dependency("tp_proto", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_proto, "", "proto", "proto", false, null);
    }

    const tp_prql = b.dependency("tp_prql", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_prql, "", "prql", "prql", false, null);
    }

    const tp_pug = b.dependency("tp_pug", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_pug, "", "pug", "pug", true, null);
    }

    const tp_purescript = b.dependency("tp_purescript", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_purescript, "", "purescript", "purescript", true, null);
    }

    const tp_qmljs = b.dependency("tp_qmljs", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_qmljs, "", "qmljs", "qmljs", true, null);
    }

    const tp_r = b.dependency("tp_r", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_r, "", "r", "r", true, null);
    }

    const tp_racket = b.dependency("tp_racket", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_racket, "", "racket", "racket", true, null);
    }

    const tp_ralph = b.dependency("tp_ralph", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_ralph, "", "ralph", "ralph", false, null);
    }

    const tp_rasi = b.dependency("tp_rasi", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_rasi, "", "rasi", "rasi", false, null);
    }

    const tp_razor = b.dependency("tp_razor", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_razor, "", "razor", "razor", true, null);
    }

    const tp_rbs = b.dependency("tp_rbs", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_rbs, "", "rbs", "rbs", false, null);
    }

    const tp_rego = b.dependency("tp_rego", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_rego, "", "rego", "rego", false, null);
    }

    const tp_rescript = b.dependency("tp_rescript", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_rescript, "", "rescript", "rescript", true, null);
    }

    const tp_rnoweb = b.dependency("tp_rnoweb", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_rnoweb, "", "rnoweb", "rnoweb", true, null);
    }

    const tp_robot = b.dependency("tp_robot", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_robot, "", "robot", "robot", false, null);
    }

    const tp_robots = b.dependency("tp_robots", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_robots, "", "robots", "robots_txt", true, null);
    }

    const tp_roc = b.dependency("tp_roc", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_roc, "", "roc", "roc", true, null);
    }

    const tp_rst = b.dependency("tp_rst", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_rst, "", "rst", "rst", true, null);
    }

    const tp_scfg = b.dependency("tp_scfg", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_scfg, "", "scfg", "scfg", false, null);
    }

    const tp_scheme = b.dependency("tp_scheme", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_scheme, "", "scheme", "scheme", false, null);
    }

    const tp_sflog = b.dependency("tp_sflog", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_sflog, "sflog", "sflog", "sflog", false, null);
    }

    const tp_slim = b.dependency("tp_slim", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_slim, "", "slim", "slim", true, null);
    }

    const tp_slint = b.dependency("tp_slint", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_slint, "", "slint", "slint", true, null);
    }

    const tp_smithy = b.dependency("tp_smithy", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_smithy, "", "smithy", "smithy", false, null);
    }

    const tp_snakemake = b.dependency("tp_snakemake", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_snakemake, "", "snakemake", "snakemake", true, null);
    }

    const tp_solidity = b.dependency("tp_solidity", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_solidity, "", "solidity", "solidity", false, null);
    }

    const tp_soql = b.dependency("tp_soql", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_soql, "soql", "soql", "soql", false, null);
    }

    const tp_sosl = b.dependency("tp_sosl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_sosl, "sosl", "sosl", "sosl", false, null);
    }

    const tp_sourcepawn = b.dependency("tp_sourcepawn", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_sourcepawn, "", "sourcepawn", "sourcepawn", true, null);
    }

    const tp_sparql = b.dependency("tp_sparql", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_sparql, "", "sparql", "sparql", false, null);
    }

    const tp_strace = b.dependency("tp_strace", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_strace, "", "strace", "strace", false, null);
    }

    const tp_styled = b.dependency("tp_styled", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_styled, "", "styled", "styled", true, null);
    }

    const tp_supercollider = b.dependency("tp_supercollider", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_supercollider, "", "supercollider", "supercollider", true, null);
    }

    const tp_surface = b.dependency("tp_surface", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_surface, "", "surface", "surface", false, null);
    }

    const tp_sway = b.dependency("tp_sway", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_sway, "", "sway", "sway", true, null);
    }

    const tp_sxhkdrc = b.dependency("tp_sxhkdrc", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_sxhkdrc, "", "sxhkdrc", "sxhkdrc", false, null);
    }

    const tp_systemtap = b.dependency("tp_systemtap", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_systemtap, "", "systemtap", "systemtap", false, null);
    }

    const tp_tact = b.dependency("tp_tact", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_tact, "", "tact", "tact", false, null);
    }

    const tp_templ = b.dependency("tp_templ", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_templ, "", "templ", "templ", true, null);
    }

    const tp_tera = b.dependency("tp_tera", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_tera, "", "tera", "tera", true, null);
    }

    const tp_textproto = b.dependency("tp_textproto", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_textproto, "", "textproto", "textproto", false, null);
    }

    const tp_tiger = b.dependency("tp_tiger", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_tiger, "", "tiger", "tiger", true, null);
    }

    const tp_tlaplus = b.dependency("tp_tlaplus", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_tlaplus, "", "tlaplus", "tlaplus", true, null);
    }

    const tp_todotxt = b.dependency("tp_todotxt", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_todotxt, "", "todotxt", "todotxt", false, null);
    }

    const tp_turtle = b.dependency("tp_turtle", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_turtle, "", "turtle", "turtle", false, null);
    }

    const tp_twig = b.dependency("tp_twig", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_twig, "", "twig", "twig", false, null);
    }

    const tp_typespec = b.dependency("tp_typespec", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_typespec, "", "typespec", "typespec", false, null);
    }

    const tp_typoscript = b.dependency("tp_typoscript", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_typoscript, "", "typoscript", "typoscript", false, null);
    }

    const tp_typst = b.dependency("tp_typst", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_typst, "", "typst", "typst", true, null);
    }

    const tp_unison = b.dependency("tp_unison", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_unison, "", "unison", "unison", true, null);
    }

    const tp_usd = b.dependency("tp_usd", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_usd, "", "usd", "usd", false, null);
    }

    const tp_v = b.dependency("tp_v", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_v, "tree_sitter_v", "v", "v", false, null);
    }

    const tp_vala = b.dependency("tp_vala", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_vala, "", "vala", "vala", false, null);
    }

    const tp_vento = b.dependency("tp_vento", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_vento, "", "vento", "vento", true, null);
    }

    const tp_verilog = b.dependency("tp_verilog", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_verilog, "", "v", "systemverilog", false, null);
    }

    const tp_vhdl = b.dependency("tp_vhdl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_vhdl, "", "vhdl", "vhdl", true, null);
    }

    const tp_vhs = b.dependency("tp_vhs", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_vhs, "", "vhs", "vhs", false, null);
    }

    const tp_vimdoc = b.dependency("tp_vimdoc", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_vimdoc, "", "vimdoc", "vimdoc", false, null);
    }

    const tp_vrl = b.dependency("tp_vrl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_vrl, "", "vrl", "vrl", false, null);
    }

    const tp_wgsl = b.dependency("tp_wgsl", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_wgsl, "", "wgsl", "wgsl", true, null);
    }

    const tp_wing = b.dependency("tp_wing", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_wing, "", "wing", "wing", true, null);
    }

    const tp_wit = b.dependency("tp_wit", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_wit, "", "wit", "wit", true, null);
    }

    const tp_xresources = b.dependency("tp_xresources", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_xresources, "", "xresources", "xresources", false, null);
    }

    const tp_yang = b.dependency("tp_yang", .{});
    if (gb.use_third_party) {
        gb.addGrammarChecked(tp_yang, "", "yang", "yang", false, null);
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
    use_third_party: bool,

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
