#[magnus::wrap(class = "TreeSitter::Capture", free_immediately, size)]
pub struct Capture {
    pub name: String,
}
