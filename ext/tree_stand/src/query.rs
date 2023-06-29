use magnus::{
    DataTypeFunctions,
    TypedData,
    DataType, block::{Yield, block_given},
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

    pub fn capture_index_for_name(&self, name: String) -> Option<u32> {
        self.ts_query.capture_index_for_name(&name)
    }

    pub fn exec(&self, node: &'tree Node) -> Yield<impl Iterator<Item = Match>> {
        let mut ts_cursor = tree_sitter::QueryCursor::new();
        let items = ts_cursor
            .matches(&self.ts_query, *node.ts_node, node.tree.document.as_bytes())
            .map(|m| Match::new(self.ts_tree, m));

        if block_given() {
            Yield::Iter(items.into_iter())
        } else {
            panic!("no block given to Query#exec")
        }
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
