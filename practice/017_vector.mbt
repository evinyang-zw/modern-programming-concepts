// This example implements an imperative vector data structure in MoonBit,
// which support `O(1)` random access and amortized `O(1)` `push/pop` operations
// 这个例子在MoonBit中实现了一个命令式向量数据结构，支持O(1)随机访问和摊销O(1)的push/pop操作
// Tips💡: 在编程和数据结构中，'vector'通常指一种动态数组，支持随机访问和高效的插入删除操作。

///|
struct Vector[X] {
  mut data : Array[X]
  mut len : Int
}

pub(all) struct T5 {
  x : Int
} derive(Show, Default)

///|
pub impl[T : Show] Show for Vector[T] with output(
  self : Vector[T], 
  logger : &Logger
) -> Unit {
  let mut str = "["
  for i = 0; i <= self.length(); i = i + 1 {
    str = str + 
      (match self[i] {
        Some(x) => x.to_string()
        None => "]"
      })
  }
  logger.write_string(str)
}

///|
/// `length[X](self : Vector[X])`
/// 
/// Get length of a vector
fn[X] Vector::length(self : Vector[X]) -> Int {
  self.len
}

///|
/// `op_get[X](self : Vector[X], i : Int)`
/// 
/// Get the ith element of vector
fn[X] Vector::op_get(self : Vector[X], i : Int) -> X? {
  if i < self.len {
    Some(self.data[i])
  } else {
    None
  }
}

///|
/// `Vector::new[X : Default](len : Int)`
/// 
/// Create a vector with length `len`, filling with default value of type `X`
/// 创建一个长度为 `len` 的向量，用类型 `X` 的默认值填充
pub fn[X : Default] Vector::new(len : Int) -> Vector[X] {
  Vector::new_with_default(len, X::default())
}

///|
/// `Vector::new_with_default[X](len: Int, default: X)`
/// 
/// Create a vector with length `len`, filling with value `default`
fn[X] Vector::new_with_default(len : Int, default : X) -> Vector[X] {
  { data: Array::make(len, default), len }
}

///|
/// `push_back[X : Default](self : Vector[X], elem : X)`
/// 
/// push back `elem` to a vector, default value of type `X` will be used to fill the additional space
/// 将 `elem` 推入向量，将使用类型 `X` 的默认值填充额外的空间
pub fn[X : Default] push_back(self : Vector[X], elem : X) -> Unit {
  self.push_back_with_default(elem, X::default())
}

///|
/// `push_back_with_default[X](self: Vector[X], elem: X, default: X)`
/// 
/// Push back `elem` to a vector, `default` will be used to fill the additional space
/// 将 `elem` 推入向量，`default` 将用于填充额外的空间
fn[X] push_back_with_default(self : Vector[X], elem : X, default : X) -> Unit {
  if self.len < self.capacity() {
    self.data[self.len] = elem
    self.len = self.len + 1
  } else {
    let old_cap = self.capacity()
    let new_cap = if old_cap == 0 { 10 } else { old_cap * 2}
    let new_data = Array::make(new_cap, default)
    for i = 0; i < self.len; i = i + 1 {
      new_data[i] = self.data[i]
    }
    new_data[self.len] = elem
    self.data = new_data
    self.len = self.len + 1
  }
}

///|
/// `capacity[X](self: Vector[X])`
/// 
/// Get capacity of a vector
fn[X] capacity(self : Vector[X]) -> Int {
  self.data.length()
}

 

