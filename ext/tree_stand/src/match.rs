use magnus::{
    DataTypeFunctions,
    TypedData,
    DataType,
};

#[derive(DataTypeFunctions)]
pub struct Match<'cursor, 'tree> {
    pub ts_match: tree_sitter::QueryMatch<'cursor, 'tree>,
}

impl<'cursor, 'tree> Match<'cursor, 'tree> {
    pub fn new(ts_match: tree_sitter::QueryMatch<'cursor, 'tree>) -> Self {
        Self { ts_match }
    }
}

unsafe impl magnus::IntoValueFromNative for Match<'_, '_> {}

// TypedData: Send + Sized,
unsafe impl Send for Match<'_, '_> {}

unsafe impl TypedData for Match<'_, '_> {

    fn class() -> magnus::RClass {
        use magnus::{Class, RClass};

        *magnus::memoize!(RClass: {
            let class = magnus::RClass::from_value(magnus::eval("TreeSitter::Match").unwrap()).unwrap();
            class.undef_alloc_func();
            class
        })
    }

    fn data_type() -> &'static DataType {
        use magnus::typed_data::DataTypeBuilder;

        magnus::memoize!(DataType: DataTypeBuilder::<Match>::new("ts-match")
            .build())
    }
}
