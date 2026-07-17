const std = @import("std");
const Io = std.Io;

const ts = @import("tree-sitter");

pub const grammars = @import("grammars");
pub const queries = @import("queries");

pub fn getLang(lang: []const u8) ?*ts.Language {
    return (grammars.languages.get(lang) orelse return null)();
}

pub fn getQuery(lang: []const u8, query_type: []const u8) ?[]const u8 {
    return queries.getQuery(lang, query_type);
}
