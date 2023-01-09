use tree_sitter;
use libloading::{Library, Symbol};

use crate::error::Result;

#[derive(Clone)]
#[magnus::wrap(class = "TreeSitter::Language", free_immediately, size)]
pub struct Language {
    pub ts_language: tree_sitter::Language,
}

impl Language {
    pub fn new(ts_language: tree_sitter::Language) -> Self {
        Self { ts_language }
    }

    pub fn load(name: String, filepath: String) -> Result<Self> {
        let symbol_name = format!("tree_sitter_{}", name);

        let library = unsafe {
            Library::new(filepath)
                .map_err(|e| ts_error!(format!("failed to load library: {e}")))?
        };

        let ts_language = unsafe {
            let language_fn: Symbol<unsafe extern fn() -> tree_sitter::Language> = library.get(symbol_name.as_bytes())
                .map_err(|e| ts_error!(format!("failed to load symbol: {e}")))?;
            language_fn()
        };

        // Make sure the library is not unloaded.
        std::mem::forget(library);

        Ok(Self::new(ts_language))
    }
}
