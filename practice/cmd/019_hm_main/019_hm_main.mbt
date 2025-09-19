// syntax:
// - lambda: [fun param -> body] (only single parameter)
// - application: [func arg1 ...]
// - variable: start with lowercase letter
// - constructor: start with uppercase letter, [Bool] is a term of [Bool] itself,
//   and [List] is a term of type [List] itself
// - let expr: [let name = expr in expr]
//
// The type checker supports higher kinded polymorphism via constructor classes.
// 类型检查器通过构造函数类支持高阶多态
// You can play with more complex examples by adding more primitives to [prelude] below.
// 您可以通过向下面的[prelude]中添加更多原始类型来尝试更复杂的示例
///|
fn main {
  run()
}
///|
fn run(src : String) -> Unit {
  try parse_and_check(src)
}

///| 
/// Tokenizer:在计算机科学中，分词器通常用于自然语言处理，将文本分割成更小的单元，如单词或词素，以便于进一步的分析或处理。
/// 
fn parse_and_check(src : String) -> @hm.Type raise Error {
  let t = @hm.Tokenizer::make(src)
  let expr = t.parse_whole_file!()
  
}