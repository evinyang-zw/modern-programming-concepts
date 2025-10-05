// This example demonstrate how to calculate the nth Fibonacci number in various ways

/// Calculate the nth Fibonacci number using recurion and pattern matching
pub fn fib1(n : Int) -> Int {
  match n {
    0 => 0
    1 => 1
    _ => fib1(n - 1) + fib1(n - 2)
  }
}

///|
/// Calculate the nth Fibonacci number using **loop** and pattern matching.
pub fn fib2(n : Int) -> Int {
  //Moonbit will convert recursion to loop automatically
  fn aux(n, acc1, acc2) {
    match n {
      0 => acc1
      1 => acc2
      _ => aux(n - 1, acc2, acc1 + acc2)
    }
  }
  
  aux(n, 0, 1)
  //n=0,aux(0,0,1) => 0
  //n=1,aux(1,0,1) => 1
  //n=2,aux(2,0,1) => aux(1,1,1) => 1
  //n=3,aux(3,0,1) => aux(2,1,1) => aux(1,1,2) => 2
  //n=4,aux(4,0,1) => aux(3,1,1) => aux(2,1,2) => aux(1,2,3) => 3 
}

///|
/// Calculate the nth Fibonacci number using MoonBit's "loop" construct
pub fn fib3(n : Int) -> Int {
  loop (n, 0, 1) {
    (0, acc2, _) => acc2
    (n, acc2, acc1) => continue (n - 1, acc1, acc1 + acc2)
  }
  //n=0,loop(0,0,1) => 0
  //n=1,loop(1,0,1) => continue (0,1,1) => loop(0,1,1) => 1
  //n=2,loop(2,0,1) => continue (1,1,1) => loop(1,1,1) => continue (0,1,2) => loop(0,1,2) => 1
}

///|
/// Calculate the nth Fibonacci number using MonnBit's for-loop
pub fn fib4(n : Int) -> Int {
  for i = 0, acc2 = 0, acc1 = 1 //initialize loop variables
      i < n //loop condition
      // update loop variables  
      i = i + 1, acc2 = acc1 , acc1 = acc1 + acc2 {
      } else {
        acc2
      }
}