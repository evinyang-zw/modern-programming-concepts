// This example demonstrates some string-related operations in MoonBit

pub(all) enum T3 {
  A
  B
}

///|
/// convert T3 to string
pub impl Show for T3 with output(self : T3, logger : &Logger) -> Unit {
  match self {
    A => logger.write_string("A")
    B => logger.write_string("B")
  }
}