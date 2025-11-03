///|
priv struct ParseState {
  src : String
  mut offset : Int
}

///|
pub fn parse(src : String) -> Regex {
  let state = { src, offset: 0 }
  let r = parse_alt(state)
  if state.offset < state.src.length() {
    abort(
      "unexpected character " +
      state.src.get_char(state.offset).unwrap().to_string() +
      " at index " +
      state.offset.to_string(),
    )
  }
  r
}

///| parse_alt 通常用于编程中解析不同的表达式或替代方案。
fn parse_alt(state : ParseState) -> Regex {
  let mut r = parse_postfix(state)
  while state.offset < state.src.length() {
    match state.src.get_char(state.offset).unwrap() {
      '|' => {
        state.offset = state.offset + 1
        r = r + parse_postfix(state)
      }
      _ => break
    }
  }
  r
}

///| 在编程语言和算法中，parse_postfix 通常指用于解析后缀表达式的函数或过程。
fn parse_postfix(state : ParseState) -> Regex {
  let mut r = parse_atomic(state)
  while state.offset < state.src.length() {
    match state.src.get_char(state.offset).unwrap() {
      '*' => {
        r = star(r)
        state.offset = state.offset + 1
      }
      '+' => {
        r = plus(r)
        state.offset = state.offset + 1
      }
      ')' | '|' => break
      _ => r = r * parse_postfix(state)
    }
  }
  r
}

///| 在编程语言中，parse_atomic 通常指解析最小的独立表达式单元，如变量或常量。
fn parse_atomic(state : ParseState) -> Regex {
  if state.offset >= state.src.length() {
    return empty()
  }
  match state.src.get_char(state.offset).unwrap() {
    '(' => {
      let paren_pos = state.offset
      state.offset = state.offset + 1
      let r = parse_alt(state)
      if state.offset >= state.src.length() {
        abort("unmatched parenthesis at offset at index \{paren_pos}")
      }
      match state.src.get_char(state.offset).unwrap() {
        ')' => state.offset = state.offset + 1
        _ => abort("unmatched parenthesis at offset at index \{paren_pos}")
      }
      r
    }
    '*' => abort("unexpected \"*\" at index " + state.offset.to_string())
    '+' => abort("unexpected \"+\" at index " + state.offset.to_string())
    '\\' => {
      state.offset = state.offset + 1
      if state.offset >= state.src.length() {
        abort("bad escape sqquence at index " + state.offset.to_string())
      }
      let c = state.src.get_char(state.offset).unwrap()
      chr(c)
    }
    '.' => {
      state.offset = state.offset + 1
      any()
    }
    c => {
      state.offset = state.offset + 1
      chr(c)
    }
  }
}

