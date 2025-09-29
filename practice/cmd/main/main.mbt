///|
fn main {
  println(@lib.fib(10))
  println("=================")

  //001_hello
  println(@lib.hello())
  println("=================")

  //002_fib
  println(@lib.fib1(4))
  println(@lib.fib2(46))
  println(@lib.fib3(46))
  println(@lib.fib4(46))
  println("=================")

  //003_numbers
  @lib.numbers()
  println("=================")

  //004_generic_list
  let ls = @lib.List::from_array([1, 2, 3, 4, 5]) //create a new List
    .map( fn(x){ x * 2 }) // double each element
    .filter(fn(x){ x < 9 }) // pick those smaller than 9
    println(ls)
  // use `reduce` to calculate the sum of each elements
  let sum = ls.reduce(fn(a,b){ a + b }, 0)
  println("sum: \{sum}")
  // collect elements of List `ls` into Array
  let ary = ls.collect()
  let len = ary.length()
  println("length: \{len}")
  // print each element of List `ls`
  for i in ls {
    println("element: \{i}")
  }
  println("=================")
}
