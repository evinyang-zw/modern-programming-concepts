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
/// prelude: 通常指的是程序或库的初始化部分，它包含了程序启动时需要加载的函数和变量。
/// infer: 通常指编译器或解释器从代码中推断类型或属性。
fn parse_and_check(src : String) -> @hm.Type raise Error {
  let t = @hm.Tokenizer::make(src)
  let expr = t.parse_whole_file!()
  @hm.infer(prelude, expr)
  
}
fn forall(f : (@hm.Type) -> @hm.Type) -> @hm.Type {
  f(@hm.fresh_generic())
}

fn forall2(f : (@hm.Type, @hm.Type) -> @hm.Type) -> @hm.Type {
  f(@hm.fresh_generic(), @hm.fresh_generic())
}

fn list(a : @hm.Type) -> @hm.Type {
  @hm.T_App(@hm.T_Con("List"), a)
}

///|
let prelude : @hm.Map[String, @hm.Type] = @hm.Map::of_array([
  ("nil", forall(fn(a) { list(a) })),
  ("cons", forall(fn(a){ lam([a, list(a)], list(a))})),
  ("fold", 
    forall2(
      fn(a, b){ 
        lam(
          [lam([a, b], b), list(a), b], 
          b
        ) 
      }
    )
  )
])

///|
fn lam(args : Array[@hm.Type], ret : @hm.Type) -> @hm.Type {
  let mut result = ret
  for i = args.length() - 1; i >= 0; i = i - 1 {
    result = T_Lam(args[i], result)
  }
  result
}

