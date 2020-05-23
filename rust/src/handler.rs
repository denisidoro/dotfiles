use anyhow::Error;
use crate::opts::Opts;
use crate::opts::Command::Transpile;
use crate::transpile;

pub fn handle(opts: Opts) -> Result<(), Error> {
    match opts.cmd {
            Transpile { filename } => transpile::main(&filename),
    }
}