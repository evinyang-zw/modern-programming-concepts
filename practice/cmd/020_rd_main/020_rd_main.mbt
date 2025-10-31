///|
fn main {
  println("===")
  test1(@rd.chr('A') * @rd.star(@rd.chr('a') + @rd.chr('A')), [
    "AaAAa", "A", "a", "Aab",
  ])
}

///|
fn test1(r : @rd.Regex, tests : Array[String]) -> Unit {
  let c = r.compile()
  // uncomment this line to see the compiled state machine
  // c.dump()
  for i = 0; i < tests.length(); i = i + 1 {
    println((r.matches(tests[i]), c.matches(tests[i])))
  }
}