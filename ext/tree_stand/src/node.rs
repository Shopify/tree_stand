use magnus::{TypedData, DataTypeFunctions, DataType, r_typed_data::DataTypeBuilder, memoize};
use tree_sitter;

use crate::tree::Tree;

#[derive(DataTypeFunctions)]
pub struct Node<'tree> {
    pub tree: &'tree Tree,
    pub ts_node: Box<tree_sitter::Node<'tree>>,
}

unsafe impl Send for Node<'_> {}

impl Node<'_> {
    pub fn new(ts_node: tree_sitter::Node) -> Self {
        let node = Box::new(ts_node.clone());
        Self {
            tree,
            ts_node: node,
        }
    }
}

unsafe impl TypedData for Node<'_> {
    fn class() -> magnus::RClass {
        magnus::RClass::from_value(magnus::eval("TreeStand::Node").unwrap()).unwrap()
    }

    fn data_type() -> &'static DataType {
        memoize!(DataType: DataTypeBuilder::<Node>::new("foo")
            .build())
    }
}
