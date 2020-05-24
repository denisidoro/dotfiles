use super::fs;
use super::transpiler;
use anyhow::Context;
use anyhow::Error;
use regex::Regex;

pub struct Transpiler {}

impl Transpiler {
    pub fn new() -> Self {
        Self {}
    }
}

impl transpiler::Transpiler for Transpiler {
    fn transpile(&self, lines: fs::Lines) -> Result<String, Error> {
        let mut result = String::new();
        let mut tmp: String;
        let re = Regex::new(r"\([^\)]+").context("Invalid regex")?;

        for line in lines {
            if let Ok(l) = line {
                tmp = l;
                if tmp.contains('(') && tmp.contains(')') && tmp.contains('{') {
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
}
