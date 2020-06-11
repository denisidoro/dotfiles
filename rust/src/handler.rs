use crate::opts::Command::{Table, Transpile};
use crate::opts::Opts;
use crate::table;
use crate::transpile;
use anyhow::Error;

pub fn handle(opts: Opts) -> Result<(), Error> {
    match opts.cmd {
        Transpile { filename } => transpile::main(&filename),
        Table { string1, string2 } => table::main(&string1, &string2),
    }
}
