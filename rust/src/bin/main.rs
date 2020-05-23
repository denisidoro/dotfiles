extern crate dot;

fn main() -> Result<(), anyhow::Error> {
    dot::handle(dot::Opts::from_env())
}