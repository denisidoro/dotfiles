use anyhow::Context;
use anyhow::Error;

pub fn main(string1: &str, string2: &str) -> Result<(), Error> {
    let mut lines1 = string1.split('\n');
    let mut lines2 = string2.split('\n');

    loop {
        let mut all_finished = false;
        let f = lines1.next();
        let s = lines2.next();

        if f.is_none() && s.is_none() {
            all_finished = true;
        }

        println!(
            "{:0fsize$} {:0ssize$}",
            f.unwrap_or(""),
            s.unwrap_or(""),
            fsize = 20,
            ssize = 20
        );

        if all_finished {
            break;
        }
    }

    Ok(())
}
