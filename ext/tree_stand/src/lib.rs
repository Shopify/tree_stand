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
use crate::node::Node;
use crate::r#match::Match;
use crate::capture::Capture;

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

    let cnode = mtree_sitter.define_class("Node", Default::default())?;
    cnode.define_method("fields", method!(Node::fields, 0))?;
    cnode.define_method("type", method!(Node::get_type, 0))?;
    cnode.define_method("error?", method!(Node::is_error, 0))?;
    cnode.define_method("each", method!(Node::each, 0))?;

    let cquery = mtree_sitter.define_class("Query", Default::default())?;
    cquery.define_singleton_method("new", function!(Query::new, 3))?;
    cquery.define_method("exec", method!(Query::exec, 1))?;
    cquery.define_method("capture_names", method!(Query::capture_names, 0))?;

    let cmatch = mtree_sitter.define_class("Match", Default::default())?;
    cmatch.define_method("captures", method!(Match::captures, 0))?;

    let ccapture = mtree_sitter.define_class("Capture", Default::default())?;
    ccapture.define_method("index", method!(Capture::index, 0))?;
    ccapture.define_method("node", method!(Capture::node, 0))?;

    Ok(())
}
