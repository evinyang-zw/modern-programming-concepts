///|
/// Tokenizer: 在计算机科学中，分词器是一种用于将文本分解成单词、短语或符号的工具，常用于自然语言处理。
/// cursor: 在计算机编程中，cursor通常指屏幕上的光标，用于指示文本输入的位置。
/// cur_token: 在编程中，'cur_token'通常指的是当前正在被解析或处理的标记，如字符或符号。
struct Tokenizer {
  mut token_start : Int
  mut cursor : Int
  src : String
  mut cur_token : Token
}

///|
/// IDENT: 在编程语言中,'IDENT'通常指的是标识符，即用于命名变量、函数等的名称
/// EOF: 文件结束标记
priv enum Token {
  LET
  EQUAL
  IN
  FUN
  ARROW
  IDENT(String)
  CON(String)
  LPAREN
  RPAREN
  EOF
} derive(Show, Eq)

///|
enum Expr {
  Var(String)
  Con(String)
  Lam(String, Expr)
  App(Expr, Expr)
  Let(String, Expr, Expr)
} derive(Show)

///|
/// BadTokenError: 无效符号错误
/// InvalidCharacterError: 无效字符错误
/// UnexpectedEofError: 意外EOF错误
suberror TokenError {
  BadTokenError(String)
  InvalidCharacterError(String)
  UnexpectedEofError
  UnexpectedTokenError(String)
} derive(Show)

///|
pub fn Tokenizer::make(src : String) -> Tokenizer {
  {token_start: 0 , cursor: 0, src, cur_token: EOF}
}

///|
pub fn parse_whole_file(self : Tokenizer) -> Expr raise TokenError {
  let expr = self.parse_expr()
  self.expect_token(EOF)
  expr
}

///|
fn parse_expr(self : Tokenizer) -> Expr raise TokenError {
  match self.peek(){
    EOF => raise UnexpectedEofError
    LET => {
      let _ = self.next()
      let id =  self.expect_ident()
      self.expect_token(EQUAL)
      let rhs = self.parse_expr()
      self.expect_token(IN)
      let body = self.parse_expr()
      Let(id, rhs, body)
    }
    FUN => {
      let _ = self.next()
      let param = self.expect_ident()
      self.expect_token(ARROW)
      let body = self.parse_expr()
      Lam(param, body)
    }
    _ => {
      let mut head = self.parse_simple_expr()
      while true {
        match self.peek() {
          LPAREN | IDENT(_) | CON(_) => {
            let arg = self.parse_simple_expr()
            head = App(head, arg)
          }
          _ => break
        }
      }
      head
    }     
  }
}

///|
/// peek: 'peek'通常指在不消耗输入的情况下查看下一个输入项。
fn peek(self : Tokenizer) -> Token raise TokenError {
  if self.cursor == 0 {
    self.cur_token = self.do_next()
  }
  self.cur_token
}

///|
/// 写的太棒了😀
fn do_next(self : Tokenizer) -> Token raise TokenError {
  self.token_start = self.cursor
  let c = match self.next_char(){
    None =>  return EOF
    Some(c) => c
  }
  match c {
    ' ' | '\n' | '\t' => return self.do_next()
    '(' => return LPAREN
    ')' => return RPAREN
    '=' => return EQUAL
    '-' => 
      match self.next_char() {
        Some('>') => return ARROW
        _ => raise BadTokenError("bad token \"" + self.lexeme() + "\"")
      }
    _ => ()
  }
  if ('a' <= c && c <= 'z') || c == '_' {
    match self.nex_ident() {
      "let" => LET
      "in" => IN
      "fun" => FUN
      id => IDENT(id)
    }
  } else if 'A' <= c && c <= 'Z' {
    CON(self.nex_ident())
  } else {
    raise InvalidCharacterError("invalid character" + c.to_string())
  }
}

///|
fn next_char(self : Tokenizer) -> Char? {
  let c = self.peek_char()
  match c {
    Some(_) => self.cursor = self.cursor + 1
    None => ()
  }
  c
}

///|
fn peek_char(self : Tokenizer) -> Char? {
  if self.cursor >= self.src.length() {
    return None
  }
  Some(self.src.get_char(self.cursor).unwrap())
}

///|
/// lexeme: The word 'cat' consists of three lexemes: 'c', 'a', and 't'.
fn lexeme(self: Tokenizer) -> String {
  self.src.substring(start=self.token_start, end=self.cursor)
}

///|
fn nex_ident(self : Tokenizer) -> String {
  match self.peek_char() {
    None => self.lexeme()
    Some(c) => 
      if ('a' <= c && c <= 'z') ||
        ('A' <= c && c <= 'Z') ||
        ('0' <= c && c <= '9') ||
        c == '_' {
          self.cursor = self.cursor + 1
          self.nex_ident()
      } else {
        self.lexeme()
      }
  }
}

///|
fn next(self : Tokenizer) -> Token raise TokenError {
  let tok = self.peek()
  self.cur_token = self.do_next()
  tok
}

///| ‘ \" ’ 转义的是 ‘ " ’, ‘\{tok}’ 转义 tok插值
fn expect_ident(self : Tokenizer) -> String raise TokenError {
  match self.next() {
    IDENT(id) => id
    token => {
      let tok = token.to_string() 
      raise UnexpectedTokenError(
        "unexpexted token \"\{tok}\", expecting identifier"
      )
    }
  }
}

///|
fn expect_token(self : Tokenizer, tok : Token) -> Unit raise TokenError {
  let next_tok = self.next()
  if next_tok == tok {
    
  } else {
    raise UnexpectedTokenError(
      "unexpected token \"\{next_tok}\", expecting \"\{tok}\""
    )
  }
}

///|
fn parse_simple_expr(self : Tokenizer) -> Expr raise TokenError {
  match self.next() {
    IDENT(id) => Var(id)
    CON(con) => Con(con)
    LPAREN => {
      let expr = self.parse_expr()
      self.expect_token(RPAREN)
      expr
    }
    token => {
      let tok = token.to_string()
      raise UnexpectedTokenError(
        "unexpected token \"\{tok}\", expecting simple expression"
      )
    }
  }
}