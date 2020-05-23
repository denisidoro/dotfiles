use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::{self, BufRead, BufWriter};
use std::path::Path;
use anyhow::Error;
use anyhow::Context;

type Lines = io::Lines<io::BufReader<File>>;

pub fn main(filename: &str) -> Result<(), Error> {
    let lines = read_lines(filename).context("Unable to read lines from file")?;
    let result = transpile_error_propagation(lines)?;
    write_lines(filename, &result)
}

fn transpile_error_propagation(lines: Lines) -> Result<String, Error> {
    let mut result = String::new();
    let mut tmp: String;
    let re = Regex::new(r"^(\s*)([^\s]*?)\s*:?=(.*)\?").context("Invalid regex")?;

    for line in lines {
        if let Ok(l) = line {
            tmp = l;
            if tmp.contains('?') && tmp.contains('=') {
                if let Some(captures) = re.captures(&tmp) {
                   tmp = format!("{padding}{var}, err :={assignment}\n{padding}if err != nil {{\n{padding}   return nil, err\n{padding}}}", 
                            padding = &captures[1],
                            var = &captures[2],
                            assignment = &captures[3]);
                }
            } 
            result.push_str(&tmp);
            result.push_str("\n");
        }
    }

    Ok(result)
}

fn read_lines<P>(filename: P) -> Result<Lines, Error>
where
    P: AsRef<Path>,
{
    let file = File::open(filename).context("Unable to open file")?;
    Ok(io::BufReader::new(file).lines())
}

fn write_lines<P>(filename: P, text: &str) -> Result<(), Error>
where
    P: AsRef<Path>,
{
    let f = File::create(filename).context("Unable to create file")?;
    let mut f = BufWriter::new(f);
    f.write_all(text.as_bytes()).context("Unable to write data")?;
    Ok(())
}
