#[macro_use]
extern crate lazy_static;

mod handler;
mod opts;
mod table;
mod transpile;

pub use handler::handle;
pub use opts::Opts;
