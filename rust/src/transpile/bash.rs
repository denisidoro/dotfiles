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
    static ref REGEX: Regex = Regex::new(r"(\s*)([^\s]*)\(([^\)]+)").expect("Invalid regex");
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
    if result.contains('(') && result.contains(')') && result.contains('{') {
        let tmp_result = result.clone();
        if let Some(captures) = REGEX.captures(&tmp_result) {
            let padding = &captures[1];
            let fnname = &captures[2];

            result = format!(
                "{padding}{fnname}() {{\n",
                padding = padding,
                fnname = fnname
            );

            let split = (&captures[3]).split(',');
            let args: Vec<&str> = split.collect();

            for (i, arg) in args.into_iter().enumerate() {
                result.push_str(&format!(
                    "{padding}   local -r {arg}=\"${index}\"\n",
                    padding = padding,
                    arg = arg.replace(" ", ""),
                    index = i + 1
                ));
            }
        }
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_transform_args() {
        let line = String::from("myfn(arg1, arg2, arg3) {");
        assert_eq!(
            "myfn() {\n   local -r arg1=\"$1\"\n   local -r arg2=\"$2\"\n   local -r arg3=\"$3\"\n",
            transform(line)
        );
    }

    #[test]
    fn test_transform_none() {
        let line = String::from("myfn() {");
        assert_eq!(line.clone(), transform(line));
    }
}
