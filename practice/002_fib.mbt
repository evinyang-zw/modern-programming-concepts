// This example demonstrate how to calculate the nth Fibonacci number in various ways

/// Calculate the nth Fibonacci number using recurion and pattern matching
fn fib1(n : Int) -> Int {
  match n {
    0 => 0
    1 => 1
    _ => fib1(n - 1) + fib1(n - 2)
  }
}

///|
/// Calculate the nth Fibonacci number using **loop** and pattern matching.
fn fib2(n : Int) -> Int {
  //Moonbit will convert recursion to loop automatically
  fn aux(n, acc1, acc2) {
    match n {
      0 => acc1
      1 => acc2
      _ => aux(n - 1, acc2, acc1 + acc2)
    }
  }
  
  aux(n, 0, 1)
}