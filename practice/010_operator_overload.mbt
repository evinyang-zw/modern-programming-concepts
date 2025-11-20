// This example demonstrate operator overloading in MoonBit.
// Currently, the following operators can be overloaded in MoonBit:
// 这个例子展示了在MoonBit中如何重载运算符。
// 目前，MoonBit支持以下运算符的重载：

///|
/// | operator name        | target name |
/// | -------------------- | ----------- |
/// | `+`                  | `Add`(trait)|
/// | `-`                  | `Sub`(trait)|
/// | `*`                  | `Mul`(trait)|
/// | `/`                  | `Div`(trait)|
/// | `%`                  | `Mod`(trait)|
/// | `-`(unary)           | `Neg`(trait)|
/// | `_[_]`(get item)     | `op_get`(method) |
/// | `_[_] = _`(set item) | `op_set`(method) |
/// 
/// For more, see : https://docs.moonbitlang.com/en/latest/language/methods.html#operator-overloading
pub(all) struct T2 {
  x : Int
} derive(Show)

///|
/// `add(self : T2, other T2)`
/// Perform addition operation between two objects of type T.
pub impl Add for T2 with add(self : T2, other : T2) -> T2 {
  { x: self.x + other.x }
}
