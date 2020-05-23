use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::{self, BufRead, BufWriter};
use std::path::Path;
use std::env;

type Lines = io::Lines<io::BufReader<File>>;

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = args.get(1).expect("Expected input file");
    let lines = read_lines(filename).expect("Unable to read lines from file");
    let result = transpile_error_propagation(lines);
    write_lines(filename, &result);
}

fn transpile_error_propagation(lines: Lines) -> String {
    let mut result = String::new();
    let mut tmp: String;
    let re = Regex::new(r"^(\s*)([^\s]*?)\s*:?=(.*)\?").expect("Invalid regex");

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

    result
}

fn read_lines<P>(filename: P) -> io::Result<Lines>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn write_lines<P>(filename: P, text: &str)
where
    P: AsRef<Path>,
{
    let f = File::create(filename).expect("Unable to create file");
    let mut f = BufWriter::new(f);
    f.write_all(text.as_bytes()).expect("Unable to write data");
}
