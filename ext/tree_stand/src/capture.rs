use magnus::{
    DataTypeFunctions,
    TypedData,
    DataType, typed_data::Obj,
};

use crate::{node::Node, tree::Tree};

#[derive(DataTypeFunctions)]
pub struct Capture<'tree> {
    pub ts_tree: &'tree Tree,
    pub ts_capture: tree_sitter::QueryCapture<'tree>,
}

impl<'tree> Capture<'tree> {
    pub fn new(ts_tree: &'tree Tree, ts_capture: tree_sitter::QueryCapture<'tree>) -> Self {
        Self { ts_tree, ts_capture }
    }

    pub fn index(&self) -> u32 {
        self.ts_capture.index
    }

    pub fn node(&self) -> Obj<Node<'tree>> {
        Node::new(self.ts_tree, Box::new(self.ts_capture.node))
    }
}

unsafe impl magnus::IntoValueFromNative for Capture<'_> {}

// TypedData: Send + Sized,
unsafe impl Send for Capture<'_> {}

unsafe impl TypedData for Capture<'_> {

    fn class() -> magnus::RClass {
        use magnus::{Class, RClass};

        *magnus::memoize!(RClass: {
            let class = magnus::RClass::from_value(magnus::eval("TreeSitter::Capture").unwrap()).unwrap();
            class.undef_alloc_func();
            class
        })
    }

    fn data_type() -> &'static DataType {
        use magnus::typed_data::DataTypeBuilder;

        magnus::memoize!(DataType: DataTypeBuilder::<Capture>::new("ts-capture")
            .build())
    }
}
