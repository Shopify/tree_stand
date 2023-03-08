// use magnus::{TypedData, DataTypeFunctions, DataType, r_typed_data::DataTypeBuilder, memoize, RTypedData};
// use tree_sitter;

// use crate::tree::Tree;

// TypedData can't be derived for generic types
// #[magnus::wrap(class = "TreeSitter::Node", free_immediately, size)]
// #[derive(DataTypeFunctions)]
// pub struct Node<'tree> {
//     tree: Tree,
//     pub ts_node: Box<tree_sitter::Node<'tree>>,
// }

// // TypedData: Send + Sized,
// unsafe impl Send for Node<'_> {}

// impl Node<'_> {
//     pub fn new(tree: Tree, ts_node: tree_sitter::Node) -> RTypedData {
//         let node = Box::new(ts_node.clone());
//         typed_data::Obj::wrap(
//             Self {
//                 tree,
//                 ts_node: node,
//             }
//         )
//     }
// }

// unsafe impl TypedData for Node<'_> {
//     fn class() -> magnus::RClass {
//         magnus::RClass::from_value(magnus::eval("TreeStand::Node").unwrap()).unwrap()
//     }

//     fn data_type() -> &'static DataType {
//         memoize!(DataType: DataTypeBuilder::<Node>::new("foo")
//             .build())
//     }
// }
