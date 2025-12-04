# Ref
- 读者：杨智炜
- 时间：2025年12月4日
---
- `Ref[T]`是一个包含类型T的值val的可变引用

- 可以使用`{ val : x }`构造它，并可以使用ref.val访问它

```mbt
let a : Ref[Int] = { val: 100 }
test {
  a.val = 200
  assert_eq(a.val, 200)
  a.val += 1
  assert_eq(a.val, 201)
}
```