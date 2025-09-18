// let zero : Lexer[Int] = pchar(fn { ch => ch == '0' }).map(fn { _ => 0 })
let zero : Lexer[Int] = pchar(
  fn(ch){ ch == '0' }
).map(fn(_){ 0 })

// let one_to_nine : Lexer[Int] = pchar(
//     fn { ch => ch.to_int() >= 0x31 && ch.to_int() <= 0x39 }
//   ).map(
//     fn { ch => ch.to_int() - 0x30 }
//   )
let one_to_nine : Lexer[Int] = pchar(
  fn(ch){
    ch.to_int() >= 0x31 && ch.to_int() <= 0x39
  }
).map(fn(ch){ ch.to_int() - 0x30 })

// let zero_to_nine : Lexer[Int] = pchar(
//     fn { ch => ch.to_int() >= 0x30 && ch.to_int() <= 0x39 }
//   ).map(
//     fn { ch => ch.to_int() - 0x30 }
//   )
let zero_to_nine : Lexer[Int] = pchar(
  fn(ch){
    ch.to_int() >= 0x30 && ch.to_int() <= 0x39
  }
).map(fn(ch){ ch.to_int() - 0x30 })

// let value : Lexer[Token] = zero.or(
//     one_to_nine.and_(zero_to_nine.many())
//     .map(
//       fn { (i, ls) => 
//         fold_left_list(ls, fn { i, j => i * 10 + j }, i) })
//   ).map(Token::Value)
let value : Lexer[Token] = zero
  .or(
    one_to_nine.and_(zero_to_nine.many())
    .map(
      fn(int_list){
        match int_list {
          (i, ls) => fold_left_list(
            ls,
            fn(i, j){ i * 10 + j },
            i
          )
        }
      }
    )
  ).map(fn(i){ Value(i) })

// let symbol : Lexer[Token] = pchar(
//   fn {
//     '+' | '-' | '*' | '/' | '(' | ')' => true
//     _ => false
//   }
// ).map(
//   fn {
//     '+' => Token::Plus
//     '-' => Minus
//     '*' => Multiply
//     '/' => Divide
//     '(' => LParen
//     ')' => RParen
//     _ => abort("unreachable")
//   }
// )

let symbol : Lexer[Token] = pchar(
  fn(ch){
    match ch {
     '+' | '-' | '*' | '/' | '(' | ')' => true
     _ => false
    }
  }
).map(
  fn(ch){
    match ch {
      '+' => Token::Plus
      '-' => Minus
      '*' => Multiply
      '/' => Divide
      '(' => LParen
      ')' => RParen
      _ => abort("unreachable")
    }
  }
)

// let whitespace : Lexer[Char] = pchar(fn { ch => ch == ' ' })
let whitespace : Lexer[Char] = pchar(fn(ch){ ch == ' ' })
let tokens : Lexer[@immut/list.T[Token]] = value
  .or(symbol)
  .and_(whitespace.many())
  .map(//fn { (symbols, _) => symbols }
    fn(token_charlist){
      match token_charlist {
        (token, _) => token
      }
    })
  .many()

//type Lexer[T] (String) -> (T, String)?
priv struct Lexer[T] ((String) -> (T, String)?)

/// Number = %x30 / (%x31-39) * (%x30-39)
/// LParen = "("
/// RParen = ")"
/// Plus = "+" 
/// Minus = "-"
/// Multiply = "*"
/// Divide = "/"
/// Whitespace = " "
priv enum Token {
  Value(Int)
  LParen
  RParen
  Plus
  Minus
  Multiply
  Divide
} derive(Show)

test "init" {
  println("===Lexing start(词法分析开始)===")
  println(tokens.parse("-10123+-+523 103     ( 5) )  "))
  println(pchar(fn(ch) { ch == 'a' }).parse("asdf"))
  println(pchar(fn(ch) { ch == 'a' }).parse("sdf"))
  println("===Lexing end(词法分析结束)===")
}

fn pchar(predicate : (Char) -> Bool) -> Lexer[Char] {
  fn (input){
    if input.length() > 0 && predicate(input.to_array()[0]){
      Some((input.to_array()[0], input.substring(start = 1,  end = input.length())))
    } else {
      None
    }
  }
}

fn [I, O]map(self : Lexer[I], f : (I) -> O) -> Lexer[O] {
    fn (input){
      match self.parse(input) {
        None => None
        Some((value, rest)) => Some((f(value), rest))
      }
    }
}

fn [T]parse(self : Lexer[T], str : String) -> (T, String)? {
  self(str)
}

fn [T]or(self : Lexer[T], parser2 : Lexer[T]) -> Lexer[T] {
  fn (input){
    match self.parse(input) {
      None => parser2.parse(input)
      Some(_) as result => result
    }
  }
}

fn [T1, T2]and_(self : Lexer[T1], parser2 : Lexer[T2]) -> Lexer[(T1, T2)] {
  fn (input){
    match self.parse(input) {
      None => None
      Some((value1, rest1)) => 
        match parser2.parse(rest1) {
          None => None
          Some((value2, rest2)) => Some(((value1, value2), rest2))
        }
    }
  }
}

fn [Value]many(self : Lexer[Value]) -> Lexer[@immut/list.T[Value]] {
  fn (input){
    let mut rest = input //rest = "input"
    let mut cumul = @immut/list.Nil //cumul = ""
    while true {
      match self.parse(rest) {
        None => break
        Some((value, new_rest)) => { //("i", "nput") //("n", "put")
          rest = new_rest // rest = "nput" // rest = "put"
          cumul = Cons(value, cumul) // cumul = "i" + "" = "i" // cumul = "n" + "i" = "ni" + ""
          //cumul = "tupni" + ""
        }
      }
    }
    Some((reverse_list(cumul), rest)) //"input"
  }
}

fn [X]reverse_list(list : @immut/list.T[X]) -> @immut/list.T[X] {
  fn go(acc, xs : @immut/list.T[X]) {
    match xs { //"tupni"
      Nil => acc
      // ("t", "upni")
      // (("t"""), "upni")
      Cons(x, rest) => go((Cons(x, acc) : @immut/list.T[X]), rest)
      //("u", "pni")
    }
  }
  
  go(Nil, list) //(Nil, "tupni")
}

fn [A, B]fold_left_list(list : @immut/list.T[A], f : (B, A) -> B, b : B) -> B {
  match list {
    Nil => b
    Cons(hd, tl) => fold_left_list(tl, f, f(b, hd))
  }
}

// let lparen : Parser[Token] = ptoken(
//   fn {
//     LParen => true
//     _ => false
//   }
// )
let lparen : Parser[Token] = ptoken(
  fn(token){
    match token {
      LParen => true
      _ => false
    }
  }
)

let rparen : Parser[Token] = ptoken(
  fn(token) {
    match token {
      RParen => true
      _ => false
    }
  }
)

let plus : Parser[Token] = ptoken(
  fn(token) {
    match token {
      Plus => true
      _ => false
    }
  }
)

let minus : Parser[Token] = ptoken(
  fn(token) {
    match token {
      Minus => true
      _ => false
    }
  }
)

let multiply : Parser[Token] = ptoken(
  fn(token) {
    match token {
      Multiply => true
      _ => false
    }
  }
)

let divide : Parser[Token] = ptoken(
  fn(token) {
    match token {
      Divide => true
      _ => false
    }
  }
)


// priv type Parser[T] (@immut/list.T[Token]) -> (T, @immut/list.T[Token])?
priv struct Parser[T]((@immut/list.T[Token]) -> (T, @immut/list.T[Token])?)

priv enum Expression{
  Number(Int) //数字
  Plus(Expression, Expression) // "+"
  Minus(Expression, Expression) // "-"
  Multiply(Expression, Expression) // "*"
  Divide(Expression, Expression) // "/"
} derive(Show)

priv trait Expr{
  number(Int) -> Self
  op_add(Self, Self) -> Self
  op_sub(Self, Self) -> Self
  op_mul(Self, Self) -> Self
  op_div(Self, Self) -> Self
}

// Semanticd: expression 语义：表达式
impl Expr for Expression with number(i : Int) -> Expression {
  Number(i)
}
impl Expr for Expression with op_add(s1 : Expression, s2 : Expression) -> Expression {
  Plus(s1, s2)
}

impl Expr for Expression with op_sub(s1 : Expression, s2 : Expression) -> Expression {
  Minus(s1, s2)
}

impl Expr for Expression with op_mul(s1 : Expression, s2 : Expression) -> Expression {
  Multiply(s1, s2)
}

impl Expr for Expression with op_div(s1 : Expression, s2 : Expression) -> Expression {
  Divide(s1, s2)
}

// Semanticd: compute expression 语义：计算表达式
priv struct BoxedInt(Int) derive(Show)

impl Expr for BoxedInt with number(i : Int) -> BoxedInt {
  BoxedInt(i)
}

impl Expr for BoxedInt with op_add(a : BoxedInt, b : BoxedInt) -> BoxedInt {
  BoxedInt(a.inner() + b.inner())
}

impl Expr for BoxedInt with op_sub(a : BoxedInt, b : BoxedInt) -> BoxedInt {
  BoxedInt(a.inner() - b.inner())
}

impl Expr for BoxedInt with op_mul(a : BoxedInt, b : BoxedInt) -> BoxedInt {
  BoxedInt(a.inner() * b.inner())
}

impl Expr for BoxedInt with op_div(a : BoxedInt, b : BoxedInt) -> BoxedInt {
  BoxedInt(a.inner() / b.inner())
}

// Semantic: print expression 语义：输出表达式
priv struct BoxedString{
  str : String
  level : Int
}derive(Show)

impl Expr for BoxedString with number(i : Int) -> BoxedString {
  { str: i.to_string(), level : 0 }
}

impl Expr for BoxedString with op_add(a : BoxedString, b : BoxedString) -> BoxedString {
  let str_a = a.str
  let str_b = if b.level == 1 {
    "(" + b.str + ")"
  } else {
    b.str
  }
  { str: "\{str_a} + \{str_b}", level: 1}
}

impl Expr for BoxedString with op_sub(a : BoxedString, b : BoxedString) -> BoxedString {
  let str_a = a.str
  let str_b = if b.level == 1 {
    "(" + b.str + ")"
  } else {
    b.str
  }
  { str: "\{str_a} - \{str_b}", level: 1}
}

impl Expr for BoxedString with op_mul(a : BoxedString, b : BoxedString) -> BoxedString {
  let str_a = if a.level == 1 {
    "(" + a.str + ")"
  } else {
    a.str
  }
  let str_b = if b.level == 1 {
    "(" + b.str + ")"
  } else {
    b.str
  }
  { str: "\{str_a} * \{str_b}", level: 2}
}

impl Expr for BoxedString with op_div(a : BoxedString, b : BoxedString) -> BoxedString {
  let str_a = if a.level == 1 {
    "(" + a.str + ")"
  } else {
    a.str
  }
  let str_b = if b.level == 1 {
    "(" + b.str + ")"
  } else {
    b.str
  }
  { str: "\{str_a} / \{str_b}", level: 2}
}

test "init" {
  println("===Parsing(语法分析开始)===")
  println(parse_string("1 + 1 * (307 + 7) + 5 - 3 - 2"))
  println("===无标签的递归解析器===")
  println("===表达式类型===")
  println(
    (
      parse_string_tagless_final("1 + 1 * (307 + 7) + 5 - 3 - 2") : 
      (Expression, String, @immut/list.T[Token])?)
  )
  println("===计算表达式类型===")
  println(
    (
      parse_string_tagless_final("1 + 1 * (307 + 7) + 5 - 3 - 2") :
      (BoxedInt, String, @immut/list.T[Token])?
    )
  )
  println("===输出表达式类型===")
  println(
    (
      parse_string_tagless_final("1 + 1 * (307 + 7) + 5 - 3 - 2") :
      (BoxedString, String, @immut/list.T[Token])?
    )
  )
  println("===Parsing(语法分析结束)===")
}

fn parse_string(str : String) -> (Expression, String, @immut/list.T[Token])? {
  match tokens.parse(str) {
    None => None
    Some((token_list, rest_string)) => 
      match parser().parse_(token_list) {
        None => None
        Some((expr, rest_token_list)) => Some((expr, rest_string, rest_token_list))
      }
  }
}

fn parser() -> Parser[Expression] {
  let expression_ref : Ref[Parser[Expression]] = {
    val : Parser(fn(_) { None })
  }
  let number : Parser[Expression] = ptoken(
    fn(token) {
      match token {
        Value(_) => true
        _ => false
      }
    }
  ).map_(
    fn(token) {
      match token {
        Value(i) => Number(i)
        _ => abort("unreachable")
      }
    }
  )
  /// automic = Value /(或) LParen expression RParen
  let automic = lparen
    .and__(ref_(expression_ref))
    .and__(rparen)
    .map_(//fn { ((_, expr), _) => expr }
      fn(tokenexpr_token){
        match tokenexpr_token {
          ((_, expr), _) => expr
        }
      }
    ) 
    .or_(number)
  /// combine = automic * ( (Multiply / Divide) * atomic)  
  let combine = automic
    .and__((multiply.or_(divide)).and__(automic).many_())
    .map_(
      fn(expr_tokenexprlist) {
        match expr_tokenexprlist {
          (expr, tokenexprlist) => fold_left_list(
            tokenexprlist,
            fn(expr1,tokenexpr){
              match tokenexpr {
                  (Multiply, expr2) => Expression::Multiply(expr1, expr2)
                  (_, expr2) => Expression::Divide(expr1, expr2)
              }
            },
            expr
          )
        }
      }
    )
  /// expression = combine *( (Plus / Minus) expression)  
  expression_ref.val = combine
  .and__(plus.or_(minus).and__(combine).many_())
  .map_(
    fn(expr_tokenexprlist) {
      match expr_tokenexprlist {
        (expr, tokenexprlist) => fold_left_list(
          tokenexprlist,
          fn(expr1,tokenexpr){
            match tokenexpr {
                (Plus, expr2) => Expression::Plus(expr1, expr2)
                (_, expr2) => Expression::Minus(expr1, expr2)
            }
          },
          expr
        )
      }
    }
  )
  ref_(expression_ref)
}

fn ptoken(predicate : (Token) -> Bool) -> Parser[Token] {
  fn(tokenlist) {
    match tokenlist {
      Nil => None
      Cons(token, rest) => 
        if predicate(token) {
          Some((token, rest))
        } else {
          None
        }
    }
  }
}

fn [I, O]map_(self : Parser[I], f : (I) -> O) -> Parser[O] {
  fn(input){
    match self.parse_(input) {
      None => None
      Some((value, rest)) => Some((f(value), rest))
    }
  }
}

fn [T]parse_(
  self : Parser[T], 
  tokens : @immut/list.T[Token]
) -> (T, @immut/list.T[Token])? {
  self(tokens)
}

fn [T1, T2]and__(self : Parser[T1], parser2 : Parser[T2]) -> Parser[(T1, T2)] {
  fn(input){
    match self.parse_(input) {
      None => None
      Some((value1, rest1)) => 
        match parser2.parse_(rest1) {
          None => None
          Some((value2, rest2)) => Some(((value1, value2), rest2))
        }
    }
  }
}

fn [T]ref_(ref1 : Ref[Parser[T]]) -> Parser[T] {
  Parser(fn(input){ ref1.val.parse_(input) })
}

fn [T]or_(self : Parser[T], parser2 : Parser[T]) -> Parser[T] {
  Parser(
    fn(input){
      match self.parse_(input) {
        None => parser2.parse_(input)
        Some(_) as result => result
      }
    }
  )
}

fn [Value]many_(self : Parser[Value]) -> Parser[@immut/list.T[Value]] {
  Parser(
    fn (input){
      let mut i = input
      let mut cumul = @immut/list.T::Nil
      while true {
        match self.parse_(i) {
          None => break
          Some((value, rest)) => {
            i = rest
            cumul = Cons(value, cumul)
          }
        }
      }
      Some((reverse_list(cumul), i))
    }
  )
}

fn [E : Expr]parse_string_tagless_final(str : String) -> (E, String, @immut/list.T[Token])? {
  match tokens.parse(str) {
    None => None
    Some((token_list, rest_string)) => 
      match recursive_parser_with_tagless_final().parse_(token_list) {
        None => None
        Some((expr, rest_token_list)) => Some((expr, rest_string, rest_token_list))
      }
  }
}

fn [E : Expr]recursive_parser_with_tagless_final() -> Parser[E] {
  let number : Parser[E] = ptoken(
    fn(token) {
      match token {
        Value(_) => true
        _ => false
      }
    }
  ).map_( 
    fn(token) {
      match token{
        Value(i) => E::number(i)
        _ => abort("unreachable")
      }
    }
  )

  fn automic(tokens : @immut/list.T[Token]) -> (E, @immut/list.T[Token])? {
    lparen
    .and__(Parser(expression))
    .and__(rparen)
    .map_(//fn { ((_, expr), _) => expr }
      fn(tokenexpr_token){
        match tokenexpr_token {
          ((_, expr), _) => expr
        }
      }
    )
    .or_(number)
    .parse_(tokens)
  }

  fn expression(tokens : @immut/list.T[Token]) -> (E, @immut/list.T[Token])? {
    (Parser(combine) : Parser[E])
    .and__(plus.or_(minus).and__(Parser(combine)).many_())
    .map_(//(E, @immut/list.T[(Token, E)])
      fn(expr_tokenexprlist) {
        match expr_tokenexprlist {
          (expr, tokenexprlist) =>
            fold_left_list(
              tokenexprlist,
              fn(expr1, tokenexpr) {
                match tokenexpr {
                  (Plus, expr2) => E::op_add(expr1, expr2)
                  (_, expr2) => E::op_sub(expr1,expr2)                  
                }
              },
              expr
            )
        }
      }
    )
    .parse_(tokens)
  } 
  
  fn combine(tokens : @immut/list.T[Token]) -> (E, @immut/list.T[Token])? {
    (Parser(automic) : Parser[E])
    .and__(multiply.or_(divide).and__(Parser(automic)).many_())
    .map_(
      fn(expr_tokenexprlist) {
        match expr_tokenexprlist {
          (expr, tokenexprlist) =>
            fold_left_list(
              tokenexprlist,
              fn(expr1, tokenexpr) {
                match tokenexpr {
                (Multiply, expr2) => E::op_mul(expr1,expr2)
                (_, expr2) => E::op_div(expr1,expr2)                  
                }
              },
              expr
            )
        }
      }
    )
    .parse_(tokens)
  }

  Parser(expression)
}
