// see [https://www.khoury.northeastern.edu/home/turon/re-deriv.pdf] for more details

///| the type of regular expressions
/// 
/// 正则表达式的类型
pub(all) enum Regex {
  Empty // 空的正则表达式类型, 通常用于表示没有匹配的情况
  Impossible // 无法实现或完成
  Sym(Symbol) // 特定类型
  Concat(Regex, Regex) // 将两个正则表达式连接起来，形成一个新的正则表达式
  Alternative(Regex, Regex) // 二选一
  Star(Regex)
  // technically [Plus(r)] is just [Concat(r, Star(r))], but that would duplicate [r]
  // 从技术上讲，[Plus(r)] 实际上就是 [Concat(r, Star(r))]，但这会重复 [r]
  Plus(Regex)
}

///|
pub(all) enum Symbol {
  Any
  Chr(Char)
} derive(Eq)

///| a compiled representation of regular expression.
/// 
/// 正则表达式的编译表示
/// 
/// Allows efficient matching.
/// 
/// 允许高效匹配 
pub struct CompiledRegex(State)


///| A state machine, the compilation target regular expressions.
/// Represented as a graph
/// 
/// 一个状态机，编译的目标为正则表达式。表示为一个图。
pub struct State {
  accepting : Bool
  mut transitions : List[(Symbol, State)]
}

enum List[X] {
  Nil
  Cons(X, List[X])
} derive(Eq)

///|
// impl Eq for State with equal(s1 : State, s2 : State) -> Bool {
//   physical_equal(s1, s2)
// }

///|
pub impl Mul for Regex with mul(self : Regex, r : Regex) -> Regex {
  match (self, r) {
    (Empty, r) | (r, Empty) => r
    (Impossible, _) | (_, Impossible) => Impossible
    (Concat(r1, r2), r) => Concat(r1, Concat(r2, r))
    (r1, r2) => Concat(r1, r2)
  }
}

///|
pub impl Add for Regex with add(self : Regex, r : Regex) -> Regex {
  match (self, r) {
    (Impossible, r) | (r, Impossible) => r
    (Alternative(r1, r2), r) => Alternative(r1, Alternative(r2, r))
    (r1, r2) =>
      // This is slow, but necessary for termination 这很慢，但对于终止是必要的
      if r1 == r2 {
        r1
      } else {
        Alternative(r1, r2)
      }
  }
}

///|
pub impl Eq for Regex with equal(self : Regex, r : Regex) -> Bool {
  match (self, r) {
    (Empty, Empty) => true
    (Impossible, Impossible) => true
    (Sym(s1), Sym(s2)) => s1 == s2
    (Concat(r11, r12), Concat(r21, r22)) => r11 == r12 && r21 == r22
    (Star(r1), Star(r2)) => r1 == r2
    _ => false
  }
}

///|
pub fn chr(c : Char) -> Regex {
  Sym(Chr(c))
}

///|
pub fn star(r : Regex) -> Regex {
  Star(r)
}

///| compile a regular expression to a state machine 
/// 
/// 编译正则表达式到状态机
pub fn Regex::compile(self : Regex) -> CompiledRegex {
  let mut current_states : List[(Regex, State)] = Nil
  fn go(r : Regex) {
    match List::assoc(current_states, r) {
      Some(state) => state
      None => {
        let state = { accepting: r.nullable(), transitions: Nil }
        current_states = Cons((r, state), current_states)
        // for every possible head character, create a transition 对于每个可能的头部字符，创建一个转换
        r
        .head_symbols()
        .iter(fn(s) {
          state.transitions = Cons((s, go(r.derivative(s))), state.transitions)
        })
        state
      }
    }
  }

  CompiledRegex(go(self))
}

///| `r.derivative(c)` returns a regular expression `r'`,
/// such that `r` matches `c ++ s` if and only if `r` matches `s`
/// 
/// `r.derivative(c)` 返回一个正则表达式 `r'`，
/// 使得 `r` 匹配 `c ++ s` 当且仅当 `r'` 匹配 `s`
fn Regex::derivative(self : Regex, c : Symbol) -> Regex{
  match self {
    Empty => impossible()
    Impossible => impossible()
    Sym(c2) => 
      match (c, c2) {
        (Chr(c1), Chr(c2)) => if c1 == c2 { empty() } else { impossible() }
        (Any, Chr(_)) => impossible()
        (_, Any) => empty()
      }
    Concat(r1, r2) => {
      let dr1 = r1.derivative(c)
      if r1.nullable() {
        dr1 * r2 + r2.derivative(c)
      } else {
        dr1 * r2
      }
    }
    Alternative(r1, r2) => r1.derivative(c) + r2.derivative(c)
    Star(r) => r.derivative(c) * star(r)
    Plus(r) => r.derivative(c) * star(r)
  }
}

// smart constructors.
// Make the shape of regex more normalized, for easier equality test
// 智能构造器。
// 使正则表达式的形状更加规范化，以便更容易地进行等值测试
///|
fn impossible() -> Regex {
  Impossible  
}

///| 
fn empty() -> Regex{
  Empty
}

///|
fn[X] List::iter(self : List[X], f : (X) -> Unit) -> Unit {
  match self {
    Nil => ()
    Cons(hd, tl) => {
      f(hd)
      tl.iter(f)
    } 
  }
}

///| calculate the list of characters that may appear in the front of a regular expression
/// 
/// 计算正则表达式前面可能出现的字符列表
fn Regex::head_symbols(self : Regex) -> List[Symbol] {
  fn go(acc: List[Symbol], r : Regex) {
    match r {
      Empty | Impossible => acc
      Sym(s) => if acc.contains(s) { acc } else { Cons(s, acc) }
      Concat(r1, r2) => {
        let acc = go(acc, r1)
        if r1.nullable() {
          go(acc, r2)
        } else {
          acc
        }
      }
      Alternative(r1, r2) => go(go(acc, r1), r2)
      Star(r) | Plus(r) => go(acc, r)
    }
  }

  go(Nil, self)
}

///|
fn[X : Eq] List::contains(self : List[X], elem : X) -> Bool {
  match self {
    Nil => false
    Cons(hd, tl) => hd == elem || tl.contains(elem) //👏
  }
}

// some list operations
///|
fn[K : Eq, V] List::assoc(lst : List[(K, V)], key : K) -> V? {
  match lst {
    Nil => None
    Cons((key1, value), rest) =>
      if key1 == key {
        Some(value)
      } else {
        List::assoc(rest, key)
      }
  }
}

///| check if a regular expression accepts the empty string
/// 
/// 检查正则表达式是否接受空字符串
fn Regex::nullable(self : Regex) -> Bool {
  match self {
    Empty => true
    Impossible => false
    Sym(_) => false
    Concat(r1, r2) => r1.nullable() && r2.nullable()
    Alternative(r1, r2) => r1.nullable() || r2.nullable()
    Star(_) => true
    Plus(r) => r.nullable()
  }
}

///| Decides if a string matches a regular expression.
/// 
/// This is a simple but slow implementation based on derivative, similar to an interpreter
/// 
/// 判断一个字符串是否匹配正则表达式。
/// 
/// 这是一种基于导数的简单但缓慢的实现，类似于解释器
pub fn Regex::matches(self : Regex, s : String) -> Bool {
  let mut r = self
  let mut i = 0
  while i < s.length() {
    match r {
      Impossible => return false
      _ => ()
    }
    r = match r.derivative(Chr(s.get_char(i).unwrap())) {
      Impossible => r.derivative(Any)
      rd => rd
    }
    i = i + 1
  }
  return r.nullable()
}

///|
pub fn CompiledRegex::matches(self : CompiledRegex, s : String) -> Bool {
  self.inner().accepts(s, 0)
}

///| checks whether `self` accepts the sub string of `s` starting from `offset`
/// 
/// 检查`self`是否接受从`offset`开始的`s`的子字符串
fn State::accepts(self : State, s : String, offset : Int) -> Bool {
  if offset >= s.length() {
    return self.accepting
  }
  match List::assoc(self.transitions, Chr(s.get_char(offset).unwrap())) {
    Some(next_state) => next_state.accepts(s, offset + 1)
    None =>
      match List::assoc(self.transitions, Any) {
        Some(next_state) => next_state.accepts(s, offset + 1)
        None => false
      }
  }
}
