use magnus::{function, method, define_module, Module, Object};

#[macro_use]
mod error;
mod language;
mod parser;
mod tree;
mod node;
mod query;
mod r#match;
mod capture;

use crate::error::Result;
use crate::language::Language;
use crate::parser::Parser;
use crate::query::Query;
use crate::tree::Tree;

#[magnus::init]
fn init() -> Result<()> {
    let mtree_sitter = define_module("TreeSitter")?;

    let clanguage = mtree_sitter.define_class("Language", Default::default())?;
    clanguage.define_singleton_method("load", function!(Language::load, 2))?;

    let cparser = mtree_sitter.define_class("Parser", Default::default())?;
    cparser.define_singleton_method("new", function!(Parser::new, 0))?;
    cparser.define_method("language=", method!(Parser::set_language, 1))?;
    cparser.define_method("language", method!(Parser::language, 0))?;
    cparser.define_method("parse_string", method!(Parser::parse_string, 2))?;

    let ctree = mtree_sitter.define_class("Tree", Default::default())?;
    ctree.define_method("root_node", method!(Tree::root_node, 0))?;

    mtree_sitter.define_class("Node", Default::default())?;

    let cquery = mtree_sitter.define_class("Query", Default::default())?;
    cquery.define_singleton_method("new", function!(Query::new, 2))?;
    // cquery.define_method("exec", method!(Query::exec, 1))?;

    mtree_sitter.define_class("Match", Default::default())?;
    mtree_sitter.define_class("Capture", Default::default())?;

    Ok(())
}
