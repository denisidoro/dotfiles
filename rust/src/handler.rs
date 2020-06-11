use crate::opts::Command::{Transpile, Table};
use crate::opts::Opts;
use crate::transpile;
use crate::table;
use anyhow::Error;

pub fn handle(opts: Opts) -> Result<(), Error> {
    match opts.cmd {
        Transpile { filename } => transpile::main(&filename),
        Table {string1, string2} => table::main(&string1, &string2),
    }
}
