// 为代码编写文档注释

///| 
/// 文档注释是在顶层结构（如 fn、let、enum、struct、type）的每一行前面加上 `///` 的注释
/// 文档注释内包含 markdown 文本
/// 
pub fn fib(n : Int) -> Int64 {
  for i = 0, a = 0L, b = 1L; i < n; i = i + 1, a = b, b = a + b {

  } else {
    b
  }
}

///|
/// 文档注释中的 markdown 代码块会被视作文档测试。
/// moon check 和 moon test 会自动检查并运行这些测试，这能保证文档注释中的代码示例永远不会过时。
/// MoonBit 会自动给在文档注释的内容周围裹上一层 test 块，所以编写文档测试时无需手动包裹 test { .. } 块。
/// 
/// Increment an integer by one,
///
/// # Example:
/// ```mbt
/// inspect(incr(41), content="42")
/// ```
pub fn incr(x : Int) -> Int {
  x + 1
}

///|
/// 如果想要阻止一段代码被当作文档测试，只需要在它的 markdown 代码块上标记一个 mbt 以外的语言名字。
/// 
/// # Example:
/// `c_incr(x)` 等价于下面的 C 代码：
/// ```c
/// x++
/// ```
pub fn c_incr(x : Ref[Int]) -> Int {
  let old = x.val
  x.val += 1
  old
}
