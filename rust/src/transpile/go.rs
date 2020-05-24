use super::fs;
use super::transpiler;
use anyhow::Error;
use regex::Regex;

pub struct Transpiler {}

impl Transpiler {
    pub fn new() -> Self {
        Self {}
    }
}

lazy_static! {
    static ref REGEX: Regex = Regex::new(r"^(\s*)([^\s]*?)\s*:?=(.*)\?").expect("Invalid regex");
}

impl transpiler::Transpiler for Transpiler {
    fn transpile(&self, lines: fs::Lines) -> Result<String, Error> {
        let mut result = String::new();

        for line in lines {
            if let Ok(l) = line {
                result.push_str(&transform(l));
                result.push_str("\n");
            }
        }

        Ok(result)
    }
}

fn transform(line: String) -> String {
    let mut result = line;
    if result.contains('?') && result.contains('=') {
        if let Some(captures) = REGEX.captures(&result) {
            result = format!("{padding}{var}, err :={assignment}\n{padding}if err != nil {{\n{padding}   return nil, err\n{padding}}}", 
                                padding = &captures[1],
                                var = &captures[2],
                                assignment = &captures[3]);
        }
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_transform_error_propagation() {
        let line = String::from("foo := bar()?");
        assert_eq!(
            "foo, err := bar()\nif err != nil {\n   return nil, err\n}",
            transform(line)
        );
    }

    #[test]
    fn test_transform_none() {
        let line = String::from("foo := bar()");
        assert_eq!(line.clone(), transform(line));
    }
}
