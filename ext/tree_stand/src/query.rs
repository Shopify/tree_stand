use magnus::{
    RArray,
    DataTypeFunctions,
    TypedData,
    DataType,
};
use tree_sitter;

use crate::{error::Result, language::Language, node::Node, r#match::Match, tree::Tree};

#[derive(DataTypeFunctions)]
pub struct Query<'tree> {
    pub ts_tree: &'tree Tree,
    pub ts_query: tree_sitter::Query,
}

impl<'tree> Query<'tree> {
    pub fn new(ts_tree: &'tree Tree, language: &Language, query: String) -> Result<Self> {
        let ts_query = tree_sitter::Query::new(language.ts_language, &query)
            .map_err(|e| ts_error!(format!("Failed to create query: {}", e)))?;
        Ok(Self { ts_tree, ts_query })
    }

    pub fn capture_names(&self) -> Vec<String> {
        self.ts_query.capture_names().to_vec()
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
            matches.push(Match::new(self.ts_tree, m));
        };
        Ok(RArray::from_vec(matches))
    }
}

unsafe impl magnus::IntoValueFromNative for Query<'_> {}

// TypedData: Send + Sized,
unsafe impl Send for Query<'_> {}

unsafe impl TypedData for Query<'_> {

    fn class() -> magnus::RClass {
        use magnus::{Class, RClass};

        *magnus::memoize!(RClass: {
            let class = magnus::RClass::from_value(magnus::eval("TreeSitter::Query").unwrap()).unwrap();
            class.undef_alloc_func();
            class
        })
    }

    fn data_type() -> &'static DataType {
        use magnus::typed_data::DataTypeBuilder;

        magnus::memoize!(DataType: DataTypeBuilder::<Match>::new("ts-query")
            .build())
    }
}
