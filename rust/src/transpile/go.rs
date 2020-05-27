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
    static ref ERROR_REGEX: Regex =
        Regex::new(r"^(\s*)([^\s]*?)\s*:?=(.*)\?").expect("Invalid regex");
    static ref MAP_REGEX: Regex =
        Regex::new(r"^(\s*)([^\s]+)\s*:?=\s*([^\.]+)\.map\([^\(]+\(([^\)]+)\)\s+([^\s]+)")
            .expect("Invalid regex");
}

impl transpiler::Transpiler for Transpiler {
    fn transpile(&self, lines: fs::Lines) -> Result<String, Error> {
        let lines = transpile_map(transpile_error_propagation(lines));
        let result: String = lines.join("\n");
        Ok(result)
    }
}

fn transpile_error_propagation(lines: fs::Lines) -> Vec<String> {
    let mut new_lines = Vec::new();

    for line in lines {
        if let Ok(l) = line {
            new_lines.push(transform_line_error_propagation(l));
        }
    }

    return new_lines;
}

fn transform_line_error_propagation(line: String) -> String {
    let mut result = line;
    if result.contains('?') && result.contains('=') {
        if let Some(captures) = ERROR_REGEX.captures(&result) {
            result = format!("{padding}{var}, err :={assignment}\n{padding}if err != nil {{\n{padding}   return nil, err\n{padding}}}", 
                                padding = capture_str(&captures, 1),
                                var = capture_str(&captures, 2),
                                assignment = capture_str(&captures, 3));
        }
    }
    result
}

fn transpile_map(lines: Vec<String>) -> Vec<String> {
    let mut new_lines: Vec<String> = Vec::new();
    let mut inside_map = false;
    let mut padding = String::from("");
    let mut original_array_name;
    let mut elem_name;
    let mut elem_type;
    let mut array_name;
    let mut replace_str = String::from("");

    for l in lines {
        if !inside_map && l.contains(".map(f") {
            if let Some(captures) = MAP_REGEX.captures(&l) {
                padding = capture_str(&captures, 1);
                array_name = capture_str(&captures, 2);
                original_array_name = capture_str(&captures, 3);
                elem_name = capture_str(&captures, 4);
                elem_type = capture_str(&captures, 5);
                replace_str = format!("{}[i] =", array_name);

                inside_map = true;
                new_lines.push(format!(
                    "{}{} := make([]{}, len({}))",
                    padding, array_name, elem_type, original_array_name
                ));
                new_lines.push(format!(
                    "{}for i, {} := range {} {{",
                    padding, elem_name, original_array_name
                ));
            }
        } else if inside_map && l.contains("})") {
            inside_map = false;
            new_lines.push(format!("{}}}", padding));
        } else if inside_map {
            new_lines.push(l.replace("return", &replace_str));
        } else {
            new_lines.push(l);
        }
    }

    return new_lines;
}

fn capture_str(captures: &regex::Captures<'_>, index: usize) -> String {
    captures
        .get(index)
        .map_or(String::from(""), |s| String::from(s.as_str()))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_transform_error_propagation() {
        let line = String::from("foo := bar()?");
        assert_eq!(
            "foo, err := bar()\nif err != nil {\n   return nil, err\n}",
            transform_line_error_propagation(line)
        );
    }

    #[test]
    fn test_transform_none() {
        let line = String::from("foo := bar()");
        assert_eq!(line.clone(), transform_line_error_propagation(line.clone()));
    }

    #[test]
    fn test_transpile_map() {
        let input = r#"   pies := apples.map(func(a) Pie {
        appleSlice := slice(a)
        return bake(appleSlice)
	})"#;

        let split = input.split("\n");
        let lines: Vec<&str> = split.collect();
        let lines: Vec<String> = lines.iter().map(|x| String::from(*x)).collect();
        let new_lines = transpile_map(lines);
        let result: String = new_lines.join("\n");

        assert_eq!(
            r#"   pies := make([]Pie, len(apples))
   for i, a := range apples {
        appleSlice := slice(a)
        pies[i] = bake(appleSlice)
   }"#,
            result
        );
    }
}
