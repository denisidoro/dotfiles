mod bash;
mod fs;
mod go;
mod transpiler;

use anyhow::Context;
use anyhow::Error;
use fs::Extension;
use transpiler::Transpiler;

pub fn main(filename: &str) -> Result<(), Error> {
    let lines = fs::read_lines(filename).context("Unable to read lines from file")?;
    let extension = fs::extension_from_filename(filename).unwrap_or(Extension::Bash);

    let transpiler: Option<Box<dyn Transpiler>> = match extension {
        Extension::Go => Some(Box::new(go::Transpiler::new())),
        Extension::Bash => Some(Box::new(bash::Transpiler::new())),
    };

    if let Some(t) = transpiler {
        let result = t.transpile(lines)?;
        fs::write_lines(filename, &result)
    } else {
        Ok(())
    }
}
