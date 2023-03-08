use magnus::{
    typed_data::Obj,
    DataTypeFunctions,
    TypedData,
    DataType,
};

use crate::tree::Tree;

#[derive(DataTypeFunctions)]
pub struct Node<'tree> {
    pub tree: &'tree Tree,
    pub ts_node: Box<tree_sitter::Node<'tree>>,
}

// TypedData: Send + Sized,
unsafe impl Send for Node<'_> {}

impl<'tree> Node<'tree> {
    pub fn new(tree: &'tree Tree, ts_node: Box<tree_sitter::Node<'tree>>) -> Obj<Self> {
        Obj::wrap(Self { tree, ts_node })
    }
}

unsafe impl TypedData for Node<'_> {
    fn class() -> magnus::RClass {
        use magnus::{Class, RClass};

        *magnus::memoize!(RClass: {
            let class = magnus::RClass::from_value(magnus::eval("TreeSitter::Node").unwrap()).unwrap();
            class.undef_alloc_func();
            class
        })
    }

    fn data_type() -> &'static DataType {
        use magnus::typed_data::DataTypeBuilder;

        magnus::memoize!(DataType: DataTypeBuilder::<Node>::new("ts-node")
            .build())
    }
}
