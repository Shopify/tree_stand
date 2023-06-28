use magnus::{
    typed_data::Obj,
    DataTypeFunctions,
    TypedData,
    DataType,
    block::{Yield, block_given},
    RClass,
    Value,
    Symbol
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

    pub fn get_type(&self) -> Symbol {
        Symbol::new(self.ts_node.kind().to_string())
    }

    pub fn is_error(&self) -> bool {
        self.ts_node.is_error()
    }

    pub fn start_byte(&self) -> usize {
        self.ts_node.start_byte()
    }

    pub fn end_byte(&self) -> usize {
        self.ts_node.end_byte()
    }

    pub fn start_point(&self) -> Result<Value, magnus::Error> {
        let point = self.ts_node.start_position();
        let point_class = RClass::from_value(magnus::eval("TreeSitter::Point")?).unwrap();
        point_class.new_instance((point.row, point.column))
    }

    pub fn end_point(&self) -> Result<Value, magnus::Error> {
        let point = self.ts_node.end_position();
        let point_class = RClass::from_value(magnus::eval("TreeSitter::Point")?).unwrap();
        point_class.new_instance((point.row, point.column))
    }

    pub fn fields(&self) -> Vec<String> {
        let count = self.ts_node.child_count().try_into().unwrap();
        (0..count)
            .filter_map(|i| self.ts_node.field_name_for_child(i))
            .map(|s| s.to_string())
            .collect()
    }

    pub fn each(&self) -> Yield<impl ExactSizeIterator + Iterator<Item = Obj<Node<'tree>>>> {
        if block_given() {
            let mut cursor = self.ts_node.walk();
            let nodes = self.ts_node
                .children(&mut cursor)
                .map(|ts_node| Self::new(self.tree, Box::new(ts_node)))
                .collect::<Vec<_>>();
            Yield::Iter(nodes.into_iter())
        } else {
            // let rb_self = self.into_value();
            // Yield::Enumerator(rb_self.enumeratorize("each", ()))
            panic!("no block given to Node#each")
        }
    }

    pub fn child_count(&self) -> usize {
        self.ts_node.child_count()
    }

    pub fn to_s(&self) -> String {
        self.ts_node.to_sexp()
    }

    pub fn field_name_for_child(&self, child_index: u32) -> Option<String> {
        self.ts_node.field_name_for_child(child_index).and_then(|s| Some(s.to_string()))
    }
}

unsafe impl TypedData for Node<'_> {
    fn class() -> RClass {
        use magnus::Class;

        *magnus::memoize!(RClass: {
            let class = RClass::from_value(magnus::eval("TreeSitter::Node").unwrap()).unwrap();
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
