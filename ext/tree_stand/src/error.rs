use magnus;

pub type Result<T> = std::result::Result<T, magnus::Error>;

#[macro_export]
macro_rules! ts_error {
    ($value:expr) => {
        magnus::error::Error::Error(
            magnus::ExceptionClass::from_value(
                *magnus::RClass::from_value(magnus::eval("TreeStand::Error").unwrap()).unwrap()
            ).unwrap(),
            $value.into()
        )
    };
}
