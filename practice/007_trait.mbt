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
pub(all) struct Point[N] {
  x : N
  y : N
} derive(Show)

// In MoonBit, only the owner of a type can define methods for it.
// However, sometimes we need to extend the functionality of some foreign types.
// For example, [Int] and [Double] has no method [from_int],
// so to make them satisfies [Number], we have to extend their functionality.
// 在 MoonBit 中，只有类型的所有者才能为其定义方法。
// 但是，有时我们需要扩展某些外部的类型功能。
// 例如，[Int] 和 [Double] 没有方法 [from_int]，
// 因此，为了使它们满足 [Number]，我们必须扩展它们的功能。
//
// To handle this kind of scenario, MoonBit provides a mechanism called extension methods.
// Extension methods allow you to implement new traits for foreign types, if you are the owner of the trait
// Extension methods can only be used to implement the specified trait, and cannot be called via dot-syntax directly
// 为了处理这类场景，MoonBit 提供了一种称为扩展方法的机制。
// 扩展方法允许你在你是特征的所有者时，为外来类型实现新的特征。
// 扩展方法只能用于实现指定的特征，不能通过.语法直接调用
///|
pub impl Number for Int with from_int(x : Int) -> Int {
  x
}

///|
pub impl Number for Double with from_int(x : Int) -> Double {
  x.to_double()
}

// implement [Number] for [Point]
///|
pub impl[N : Number] Number for Point[N] with from_int(i : Int) -> Point[N] {
  let n = N::from_int(i)
  { x: n, y: n }
}

///|
pub impl[N : Number] Add for Point[N] with add(
  self : Point[N],
  other : Point[N],
) -> Point[N] {
  { x: self.x + other.x, y: self.y + other.y }
}

///|
pub impl[N : Number] Sub for Point[N] with sub(
  self : Point[N], 
  other : Point[N]
) -> Point[N] {
  { x: self.x - other.x, y: self.y - other.y }
}

///|
pub impl[N : Number] Mul for Point[N] with mul(
  self : Point[N],
  other : Point[N]
) -> Point[N] {
  { x: self.x * other.x, y: self.y * other.y }
}

///|
pub impl[N : Number] Div for Point[N] with div(
  self : Point[N],
  other : Point[N]
) -> Point[N] {
  { x: self.x / other.x, y: self.y / other.y }
}

///|
pub impl[N : Number] Neg for Point[N] with neg(self : Point[N]) -> Point[N] {
  { x: -self.x, y: -self.y }
}