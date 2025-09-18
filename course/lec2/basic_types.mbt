let x : Int = 10

let a : Double = 3.14

let s : String = "Hello"

// the following code compiles
let 通过编译 : Int = x + (a + 0.2).to_int()

// code on line 10 does not compile, uncomment (remove the `//`) to see error
//let 不通过编译 : String = s + (a + 0.2).to_int()

// The following codes are tested with assertions.
// If the assertion is failed, the program will fail.

test{
  // logical and
  assert_false_断言为假(true && false)
  // logical or
  assert_true_断言为真(false || true)
  // logical not
  assert_false_断言为假(not(true))

  // division between integers
  assert_equals_断言相等(-1, -4 / 3)
  // integer overflow
  assert_equals_断言相等(-2147483648, 2147483647 + 1)
  // will not overflow if they were 64 bits integer
  assert_equals_断言相等(2147483648L, 2147483647L + 1L)
  // will overflow if convert back to 32 bits integer
  assert_equals_断言相等(-2147483648, 2147483648L.to_int())
  
  // addition of floating point numbers is not accurate
  assert_equals_不断言相等(0.3, 0.1 + 0.2)
  assert_equals_不断言相等(0.1, 0.1 + 0.2 - 0.2)

  // convert char to/from charcode
  assert_equals_断言相等(65, 'A'.to_int())
  assert_equals_断言相等('A', Char::from_int(65))

  // accessing tuple
  assert_equals_断言相等(2023, (2023, 10 , 24).0)
  assert_equals_断言相等(3, ("Bob", 3).1)
}

fn assert_false_断言为假(b : Bool) -> Unit{
  if b {
    abort("")
  }
}
fn assert_true_断言为真(b : Bool) -> Unit{
  if not(b){
    abort("")
  }
}
fn [T : Eq]assert_equals_断言相等(expected : T, actual : T) -> Unit{
  if not(expected == actual){
    abort("")
  }
}
fn [T : Eq]assert_equals_不断言相等(expected : T, actual : T) -> Unit{
  if expected == actual{
    abort("")
  }
}