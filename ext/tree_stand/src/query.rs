use magnus::RArray;
use tree_sitter;

use crate::{error::Result, language::Language, node::Node, r#match::Match};

#[magnus::wrap(class = "TreeSitter::Query", free_immediately, size)]
pub struct Query {
    pub ts_query: tree_sitter::Query,
}

impl Query {
    pub fn new(language: &Language, query: String) -> Result<Self> {
        let ts_query = tree_sitter::Query::new(language.ts_language, &query)
            .map_err(|e| ts_error!(format!("Failed to create query: {}", e)))?;
        Ok(Self { ts_query })
    }

    pub fn exec(&self, node: &Node) -> Result<RArray> {
        // let matches = Vec::new();
        // let mut cursor = tree_sitter::QueryCursor::new();

        // cursor.matches(self.ts_query, node.ts_node);
        let mut matches = Vec::<Match>::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        // cursor.set_byte_range(node.range().start_byte..node.range().end_byte);
        let query_matches = cursor.matches(&self.ts_query, *node.ts_node, node.tree.document.as_bytes());
        for m in query_matches {
            matches.push(Match::new(m));
        };
        Ok(RArray::from_vec(matches))
    }
}
