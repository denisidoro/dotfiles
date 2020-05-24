use clap::Clap;

#[derive(Clap)]
pub struct Opts {
    #[clap(subcommand)]
    pub cmd: Command,
}

#[derive(Clap)]
pub enum Command {
    Transpile { filename: String },
}

impl Opts {
    pub fn from_env() -> Self {
        Self::parse()
    }
}
