///|
fn main {
  // println("==========")
  // test1(@rd.chr('A') * @rd.star(@rd.chr('a') + @rd.chr('A')), [
  //   "AaAAa", "A", "a", "Aab",
  // ])
  // println("==========")
  // test1(@rd.parse("A(a|A)*"), ["AaAAa", "A", "a", "Aab"])
  println("==========")
  test1(@rd.parse("let|in|fun"), ["let", "in", "fun", "ley", "fit"])
  // (true, true)
  // (true, true)
  // (true, true)
  // (false, false)
  // (false, false)
  // println("==========")
  // test1(@rd.parse("A(aa|b)*"), ["Aaabaa", "Aba"])
  // println("==========")
  // test1(@rd.parse(".*abcab.*"), [
  //   "xxxabcabxxx", "xxababcabxx", "xxababca", "abcab", "xxabab",
  // ])
}

///|
fn test1(r : @rd.Regex, tests : Array[String]) -> Unit {
  let c = r.compile()
  // uncomment this line to see the compiled state machine
  c.dump()
  for i = 0; i < tests.length(); i = i + 1 {
    println((r.matches(tests[i]), c.matches(tests[i])))
  }
}