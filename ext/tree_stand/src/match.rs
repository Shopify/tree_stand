use crate::capture::Capture;

#[magnus::wrap(class = "TreeSitter::Match", free_immediately, size)]
pub struct Match {
    pub captures: Vec<Capture>,
}
