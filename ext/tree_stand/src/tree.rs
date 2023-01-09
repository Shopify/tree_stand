use magnus::RTypedData;
use tree_sitter;

use crate::node::Node;

#[magnus::wrap(class = "TreeSitter::Tree", free_immediately, size)]
pub struct Tree {
    pub ts_tree: tree_sitter::Tree,
}

impl Tree {
    pub fn new(ts_tree: tree_sitter::Tree) -> Self {
        Self {
            ts_tree,
        }
    }

    pub fn root_node(&self) -> RTypedData {
        let node = Node::new(self.ts_tree.root_node());
        RTypedData::wrap(node)
    }
}
