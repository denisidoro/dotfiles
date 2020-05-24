extern crate dotrs;

fn main() -> Result<(), anyhow::Error> {
    dotrs::handle(dotrs::Opts::from_env())
}
