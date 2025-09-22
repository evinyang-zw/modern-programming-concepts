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
  run((
    #| let id = fun x -> x in
    #| id id    
  ))
  run((
    #| let apply = fun f -> fun x -> f x in
    #| apply
  ))
  run((
    #| let apply = fun f -> fun x -> f x in
    #| let id = fun x -> x in
    #| (id apply) id apply Int
  ))
  run((
    #| fun f ->
    #|    let x = f Int in
    #|    f Bool
  ))
  run((
    #| let map = fun f -> fun lst -> 
    #|    fold (fun x-> fun l -> cons (f x) l) lst nil
    #| in
    #| let xs = map (fun x -> cons x nil) (cons Int (cons Int nil)) in
    #| map (fun1 -> map (fun x -> Bool) l) xs
  ))
  run(("fun x -> x x"))
}
///|
fn run(src : String) -> Unit {
  try parse_and_check(src).pretty() catch {
    err => println(err)
  }
}

///| 
fn parse_and_check(src : String) -> @hm.Type raise Error {
  let t = @hm.Tokenizer::make(src)
  let expr = t.parse_whole_file!()
  @hm.infer(prelude, expr).generalize(0)
  
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
/// prelude: 通常指的是程序或库的初始化部分，它包含了程序启动时需要加载的函数和变量。
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

