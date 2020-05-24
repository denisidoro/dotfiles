use super::fs;
use anyhow::Error;

pub trait Transpiler {
    fn transpile(&self, lines: fs::Lines) -> Result<String, Error>;
}
