use anyhow::Context;
use anyhow::Error;
use std::ffi::OsStr;
use std::fs::File;
use std::io::prelude::*;
use std::io::{self, BufRead, BufWriter};
use std::path::Path;

pub type Lines = io::Lines<io::BufReader<File>>;

pub enum Extension {
    Go,
    Bash,
}

pub fn read_lines<P>(filename: P) -> Result<Lines, Error>
where
    P: AsRef<Path>,
{
    let file = File::open(filename).context("Unable to open file")?;
    Ok(io::BufReader::new(file).lines())
}

pub fn write_lines<P>(filename: P, text: &str) -> Result<(), Error>
where
    P: AsRef<Path>,
{
    let f = File::create(filename).context("Unable to create file")?;
    let mut f = BufWriter::new(f);
    f.write_all(text.as_bytes())
        .context("Unable to write data")?;
    Ok(())
}

pub fn extension_from_filename(filename: &str) -> Option<Extension> {
    let extension_str = Path::new(filename).extension().and_then(OsStr::to_str);
    if let Some(e) = extension_str {
        match e {
            "go" => Some(Extension::Go),
            "bash" | "sh" | "zsh" => Some(Extension::Bash),
            _ => None,
        }
    } else {
        None
    }
}
