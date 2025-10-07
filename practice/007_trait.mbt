// This example demonstrates the trait system of MoonBit.
// MoonBit's trait system is structural:
// types with all required methods automatically implement a trait.
// 这个例子展示了 MoonBit 的特征系统。
// MoonBit 的特征系统是结构化的：
// 拥有所有必要方法的类型会自动实现一个特征。

///|
/// [Number] trait captures the common operations of number-like types
/// [Number]特征捕捉数字类型常见的操作
pub trait Number : Add + Sub + Mul + Div + Neg {
  from_int(Int) -> Self
}

///|
/// [average] is a generic function
/// that calculates the average of an array of any number-like type
pub fn[N : Number] average(xs : Array[N]) -> N {
  for i = 0, sum = N::from_int(0); i < xs.length(); i = i + 1, sum = sum + xs[i] {

  } else {
    sum / N::from_int(xs.length())
  }
}

///|
pub struct Point[N] {
  x : N
  y : N
} derive(Show)

pub impl Number for Int with from_int(x : Int) -> Int {
  x
}
