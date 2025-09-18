priv struct Program{
  functions : @immut/list.T[Function] //函数
  start : String? 
}

priv struct Function{
  name : String
  params : @immut/list.T[String] //参数
  result : Int
  locals : @immut/list.T[String] //本地变量/函数内部变量
  instructions : @immut/list.T[Instruction]
}

priv enum Instruction{
  Const(Value)
  Add
  Sub
  Modulo
  Equal
  Call(String)
  Local_Get(String)
  Local_Set(String)
  If(Int, @immut/list.T[Instruction], @immut/list.T[Instruction])
}

priv enum Value{
  I32(Int)
}

fn Program::to_wasm(self : Program, buffer : @buffer.Buffer) -> Unit{
  let { functions, start } = self
  buffer.write_string((
    #|(module (func $print_int (import "spectest" "print_int") (param i32))
    #|
  ))
  functions.each(fn(func){ func.to_wasm(buffer) })
  match start {
    Some(start) => buffer.write_string("(start $\{start}))")
    None => buffer.write_string(")")
  }
}
fn Function::to_wasm(self : Function, buffer : @buffer.Buffer) -> Unit{
  let { name, params, result, locals, instructions} = self
  buffer.write_string("(func $\{name} (export \"\{name}\") ")
  params.each(fn(param){ buffer.write_string("(param $\{param} i32) ") })
  buffer.write_string("(result ")
  for i = 0; i < result; i = i + 1 {
    buffer.write_string("i32 ")
  }
  buffer.write_string(") ")
  locals.each(fn(local_){ buffer.write_string("(local $\{local_} i32) ") })
  instructions.each(fn(instruction){ instruction.to_wasm(buffer) })
  buffer.write_string(")\n")
}

fn Instruction::to_wasm(self : Instruction, buffer : @buffer.Buffer) -> Unit {
  match self {
    Const(I32(i)) => buffer.write_string("i32.const \{i} ")
    Add => buffer.write_string("i32.add ")   
    Sub => buffer.write_string("i32.sub ")
    Modulo => buffer.write_string("i32.rem_s ")
    Equal => buffer.write_string("i32.eq ")
    Call(val) => buffer.write_string("call $\{val} ")
    Local_Get(val) => buffer.write_string("local.get $\{val} ")
    Local_Set(val) => buffer.write_string("local.set $\{val} ")
    If(n, then, else_) => {
      buffer.write_string("if (result ")
      for i = 0; i < n; i = i + 1 {
        buffer.write_string("i32 ")
      }
      buffer.write_string(") ")
      then.each(fn(instruction){ instruction.to_wasm(buffer) })
      buffer.write_string("else ")
      else_.each(fn(instruction){ instruction.to_wasm(buffer) })
      buffer.write_string("end ")
    } 
  }
}
test "add" {
  let program = Program::{
    start: None,
    functions: @immut/list.T::of(
      [
        Function::{
          name: "add",
          params: @immut/list.of(["a", "b"]),
          result: 1,
          locals: @immut/list.of([]),
          instructions: @immut/list.of([Local_Get("a"), Local_Get("b"), Add])
        }
      ]
    )
  }
  let buffer = @buffer.new(size_hint=200)
  program.to_wasm(buffer)
  assert_eq(
    buffer.to_string(),
    (
      #|(module (func $print_int (import "spectest" "print_int") (param i32))
      #|(func $add (export "add") (param $a i32) (param $b i32) (result i32 ) local.get $a local.get $b i32.add )
      #|)
    ))
}

test "eval" {
  let functions : @immut/list.T[Function] = @immut/list.T::of(
    [
      Function::{
        name: "gcd",
        params: @immut/list.T::of(["a", "b"]),
        result: 1,
        locals: @immut/list.T::of([]),
        instructions: @immut/list.T::of(
          [
            Local_Get("a"),
            Const(I32(0)),
            Equal,
            If(
              1,
              @immut/list.T::of([Local_Get("b")]),
              @immut/list.T::of(
                [
                  Local_Get("b"),
                  Local_Get("a"),
                  Modulo,
                  Local_Get("a"),
                  Call("gcd")
                ]
              )
            )
          ]
        )
      },
      Function::{
        name: "fib_aux",
        params: @immut/list.T::of(["a", "b", "n"]),
        result: 1,
        locals: @immut/list.T::of([]),
        instructions: @immut/list.T::of(
          [
            Local_Get("n"),
            Const(I32(0)),
            Equal,
            If(
              1,
              @immut/list.T::of([Local_Get("b")]),
              @immut/list.T::of(
                [
                  Local_Get("b"),
                  Local_Get("a"),
                  Local_Get("b"),
                  Add,
                  Local_Get("n"),
                  Const(I32(1)),
                  Sub,
                  Call("fib_aux")
                ]
              )
            )
          ]
        )
      },
      Function::{
        name: "fib",
        params: @immut/list.T::of(["n"]),
        result: 1,
        locals: @immut/list.T::of([]),
        instructions: @immut/list.T::of(
          [Const(I32(0)), Const(I32(1)), Local_Get("n"), Call("fib_aux")]
        ),
      },
      Function::{
        name: "test_fib",
        params: @immut/list.T::of([]),
        result: 0,
        locals: @immut/list.T::of([]),
        instructions: @immut/list.T::of(
          [Const(I32(5)), Call("fib"), Call("print_int")]
        )
      },
      Function::{
        name: "test_gcd",
        params: @immut/list.T::of([]),
        result: 0,
        locals: @immut/list.T::of([]),
        instructions: @immut/list.T::of(
          [Const(I32(10)), Const(I32(100)), Call("gcd"), Call("print_int")]
        )
      }
    ]
  )
  let test_gcd = Program::{ start: Some("test_gcd"), functions }
  assert_eq(execute(test_gcd), Some("10"))
  let test_fib = Program::{ start: Some("test_fib"), functions }
  assert_not_eq(execute(test_fib), Some("8"))
}
priv struct State{
  program : Program
  stack : @immut/list.T[StackValue]
  locals : @immut/hashmap.T[String, Value]
  instructions : @immut/list.T[AdministrativeInstruction]
}

priv enum StackValue {
  Val(Value)
  Func(@immut/hashmap.T[String, Value])
}

priv enum AdministrativeInstruction {
  Plain(Instruction)
  EndOfFrame(Int)
}

fn execute(program : Program) -> String? {
  match program.start {
    None => None
    Some(start) => 
      match program.functions.filter(fn(f){ f.name == start }).head() {
        None => None
        Some(function) => {
          let stdout = @buffer.new(size_hint=10)
          loop Option::Some(//为什么这里要循环取State？？？
            State::{
              program,
              stack: Nil,
              locals: function.locals.fold(//这里注意，不容易理解
                init=@immut/hashmap.new(), 
                (fn(map, name){ map.add(name, I32(0)) })
              ),
              instructions: function.instructions.map(
                fn(i){ Plain(i) }
              )
            }
          ){
            None => Some(stdout.to_string())
            Some(state) => continue evaluate(state, stdout)
          }
        }
      }
  }
}

fn evaluate(state : State, stdout : @buffer.Buffer) -> State? {
  match state.instructions {
    Nil => None
    Cons(Plain(instr), tl) =>
      match instr {
        Const(value) => Some(
          State::{
            ..state,
            instructions: tl,
            stack: Cons(Val(value), state.stack) // Cons(StackValue, list[StackValue]::Nil)
          })
        Add => match state.stack {
          Cons(Val(I32(b)), Cons(Val(I32(a)), rest)) => 
            Some(State::{
              ..state,
              instructions: tl,
              stack: Cons(Val(I32(a + b)), rest)
            })
          _ => None
        }
        Sub => match state.stack {
          Cons(Val(I32(b)), Cons(Val(I32(a)), rest)) => 
            Some(State::{
              ..state,
              instructions: tl,
              stack: Cons(Val(I32(a - b)), rest)
            })
          _ => None
        }
        Modulo => match state.stack {
          Cons(Val(I32(b)), Cons(Val(I32(a)), rest)) => 
            Some(State::{
              ..state,
              instructions: tl,
              stack: Cons(Val(I32(a % b)), rest)
            })
          _ => None
        }
        Equal => match state.stack {
          Cons(Val(I32(b)), Cons(Val(I32(a)), rest)) => 
            Some(State::{
              ..state,
              instructions: tl,
              stack: Cons(Val(I32(if a==b { 1 } else { 0 } )), rest)
            })
          _ => None
        }
        Local_Get(var_) => 
          match state.locals.get(var_) {
            None => None
            Some(value) => 
              Some(
                State::{
                  ..state,
                  instructions: tl,
                  stack: Cons(Val(value), state.stack)
                }
              )
          }
        Local_Set(var_) =>
          match state.stack {
            Cons(Val(value), rest) =>
              Some(
                State::{
                  ..state,
                  locals: state.locals.add(var_, value),
                  instructions: tl,
                  stack: rest
                }
              )
            _ => None
          }
        Call(var_) => 
          if var_ == "print_int" {
            match state.stack {
              Cons(Val(I32(i)), rest) => {
                stdout.write_string(i.to_string())
                Some(
                  State::{
                    ..state,
                    stack: rest,
                    instructions: tl
                  }
                )
              }
              _ => None
            }
          } else {
            let function : Function? = state.program.functions
              .filter(fn(f){ f.name == var_ })
              .head()
            match function {
              None => None
              Some(function) => {
                let params = state.stack.take(function.params.length())
                let zipped = function.params.zip(params.rev())
                match zipped {
                  None => None
                  Some(zipped) => 
                    Some(
                      State::{
                        ..state,
                        stack: Cons(
                          Func(state.locals),
                          state.stack.drop(function.params.length())
                        ),
                        locals: function.locals.fold(
                          init=zipped.fold(
                            init=@immut/hashmap.new(),
                            // fn {
                            //   map, (name, Val(value)) => map.add(name, value)
                            //   _, _ => abort("Expected a value")
                            // }
                            fn(map, t){
                              match t {
                                (name, Val(value)) => map.add(name, value)
                                _ => abort("Expected a value")
                              }
                            }
                          ),
                          fn (map,name){
                            map.add(name, I32(0))
                          }
                        ),
                        instructions: function.instructions
                          .map(
                            fn(i){ Plain(i) }
                          )
                          .concat(
                            @immut/list.T::of([EndOfFrame(function.result)])
                          )
                          .concat(tl)
                      }
                    )
                }
              }
            }
          }
        If(_, then, else_) => match state.stack {
          Cons(Val(I32(i)), rest) =>
            Some(
              State::{
                ..state,
                stack: rest,
                instructions: (if i != 0 { then } else { else_ })
                  .map(fn(i){ Plain(i) })
                  .concat(tl)
              }
            )
          _ => None
        }
      }
    Cons(EndOfFrame(arity), tl) => {
      let params = state.stack.take(arity)
      let stack = state.stack.drop_while(
        fn (stackvalue){
          match stackvalue {
            Func(_) => false
            _ => true
          }
        }
      )
      match stack {
        Cons(Func(locals), rest) => 
          Some(
            State::{
              ..state,
              stack: params.concat(rest),
              locals,
              instructions: tl
            }
          )
        _ => None
      }
    }
  }
}

test "compile" {
  let input = "1 + 2 - 3"
  let expression = parse_string(input)
  let program = expression.map(
    fn (self){
      match self {
        (expression, _, _) => compile(expression)
      }
    }
  )
  assert_not_eq(
    program.bind(execute),
    parse_string_tagless_final(input)
    .map(
      fn(self){
        match self {
          (BoxedInt(i), _, _) => i.to_string()
        }
      }
    )
  )
}

fn compile(expression : Expression) -> Program {
  Program::{
    start: Some("main"),
    functions: @immut/list.T::of(
      [
        Function::{
          name: "main",
          params: @immut/list.T::of([]),
          result: 0,
          locals: @immut/list.T::of([]),
          instructions: compile_expression(expression)
            .concat(@immut/list.T::of([Call("print_int")]))
        }
      ]
    )
  }
}

fn compile_expression(expression : Expression) -> @immut/list.T[Instruction] {
  match expression {
    Minus(exp1, exp2) =>
      compile_expression(exp1)
      .concat(compile_expression(exp2))
      .concat(@immut/list.T::of([Sub]))
    Plus(exp1, exp2) => 
      compile_expression(exp1)
      .concat(compile_expression(exp2))
      .concat(@immut/list.T::of([Add]))
    Number(i) => @immut/list.T::of([Const(I32(i))])
    _ => @immut/list.T::of([])
  }
}