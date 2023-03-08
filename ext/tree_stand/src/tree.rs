use magnus::typed_data::Obj;

use crate::node::Node;

#[magnus::wrap(class = "TreeSitter::Tree", free_immediately, size)]
pub struct Tree {
    pub ts_tree: tree_sitter::Tree,
    pub document: String,
}

impl Tree {
    pub fn new(ts_tree: tree_sitter::Tree, document: String) -> Self {
        Self {
            ts_tree,
            document,
        }
    }

    pub fn root_node(&self) -> Obj<Node> {
        Node::new(
            self,
            Box::new(self.ts_tree.root_node()),
        )
    }
}
