// This example demonstrates trait objects in MoonBit
// Trait object turn static polymorphism of traits into dynamic polymorphism,
// and allows different data types implementing the same trait to be stored in the same data structure
//这个例子展示了MoonBit中的特征对象。
//特征对象将特征的静态多态性转换为动态多态性，并允许实现相同特征的不同数据类型存储在同一个数据结构中。

///|
pub trait Animal {
  speak(Self) -> Unit
}

///|
pub(all) struct Duck {
  name : String
}

///|
pub impl Animal for Duck with speak(self : Duck) -> Unit {
  let name = self.name
  println("\{name}: Quak!")
}

///|
pub(all) struct Fox {
  name : String
}

///|
pub impl Animal for Fox with speak(self : Fox) -> Unit {
  let name = self.name
  println("\{name}: What does the fox say?")
}

// trait [Animal], when used as type directly,
// represent trait objects of [Animal]
// trait [Animal], 当直接用作类型时，表示 [Animal] 的特征对象
///|
pub fn speak_together(xs : Array[&Animal]) -> Unit {
  for i = 0; i < xs.length(); i = i + 1 {
    xs[i].speak()
  }
}