use std::cell::RefCell;

use tree_sitter;
use crate::{tree::Tree, language::Language, error::Result};

#[magnus::wrap(class = "TreeSitter::Parser", free_immediately, size)]
pub struct Parser {
    pub ts_parser: RefCell<tree_sitter::Parser>,
}

impl Parser {
    pub fn new() -> Self {
        Self {
            ts_parser: RefCell::new(tree_sitter::Parser::new()),
        }
    }

    pub fn parse_string(&self, tree: Option<&Tree>, input: String) -> Result<Tree> {
        let mut parser = self.ts_parser.borrow_mut();

        let ts_tree = match tree {
            Some(t) => parser.parse(&input, Some(&t.ts_tree)),
            None => parser.parse(&input, None),
        }.ok_or_else(|| ts_error!(format!("Failed to parse: {input:?}")))?;

        Ok(Tree::new(ts_tree))
    }

    pub fn set_language(&self, language: &Language) -> Result<()> {
        // self.language = Some(language.clone());
        self.ts_parser.borrow_mut().set_language(language.ts_language)
            .map_err(|e| ts_error!(format!("Error setting language: {}", e)))
    }

    pub fn language(&self) -> Option<Language> {
        self.ts_parser
            .borrow()
            .language()
            .map(|l| Language::new(l))
    }
}
