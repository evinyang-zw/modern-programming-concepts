test "init_t" {
  let empty : Stack[Int] = Stack::empty()
  println("empty is Empty: \{empty}") // empty is Empty: Empty
  let one = empty.push(1)
  let two = empty.push(1)
  let (top, rest) = two.pop()
  match top {
    Some(value) => println("top should be Some(1): \{ value }") 
    // top should be Some(1): 1
    None => abort("error")
  }
  println("rest should equal to one : \{rest} == \{one}") 
  // rest should equal to one : Empty == NonEmpty(1, Empty)
  let empty_queue : Queue[Int] = Queue::empty()
  let one_queue : Queue[Int] = empty_queue.push_stk(1)
  println("one_queue should contain 1 in front: \{ one_queue }") 
  // one_queue should contain 1 in front: {front: NonEmpty(1, Empty), back: Empty}
  let two_queue = one_queue.push_stk(2)
  println("two_queue should contain 1 in front and 2 in back: \{ two_queue }")
  // two_queue should contain 1 in front and 2 in back: {front: NonEmpty(1, Empty), back: NonEmpty(2, Empty)}
  let (first, rest) = two_queue.pop_stk()
  match first {
    Some(value) => println("frist should be Some(1): \{ value }")
    // frist should be Some(1): 1
    None => abort("error")
  }
  println("rest should contain 2 in front: \{ rest }")
  // rest should contain 2 in front: {front: NonEmpty(2, Empty), back: Empty}
}
enum IntStack {
  Empty
  NonEmpty(Int, IntStack)
} derive(Show, Eq)

fn IntStack::empty() -> IntStack {
  Empty
}

fn push_int(self : IntStack, value : Int) -> IntStack {
  NonEmpty(value, self)
}

fn pop_int(self : IntStack) -> (Int?, IntStack) {
  match self {
    Empty => (None, Empty)
    NonEmpty(top, rest) => (Some(top), rest) 
  }
}

enum StringStack {
  Empty
  NonEmpty(String, StringStack)
} derive(Show, Eq)

fn StringStack::empty() -> StringStack {
  Empty
}

fn push_str(self : StringStack, value : String) -> StringStack {
  NonEmpty(value, self)
}

fn pop_str(self : StringStack) -> (String?, StringStack) {
  match self {
    Empty => (None, Empty)
    NonEmpty(top, rest) => (Some(top), rest)
  }
}

enum Stack[T] {
  Empty
  NonEmpty(T, Stack[T])
} derive(Show, Eq)

fn Stack::empty[T]() -> Stack[T] {
  Empty
}

fn push[T](self : Stack[T], value : T) -> Stack[T] {
  NonEmpty(value, self)
}

fn pop[T](self : Stack[T]) -> (T?, Stack[T]) {
  match self {
    Empty => (None, Empty)
    NonEmpty(top, rest) => (Some(top), rest) 
  }
}

struct Queue[T] {
  front : Stack[T]
  back : Stack[T]
} derive(Show, Eq)

fn Queue::empty[T]() -> Queue[T] {
  { front : Empty, back : Empty }
}

fn push_stk[T](self : Queue[T], value : T) -> Queue[T] {
  normalize({ ..self, back : self.back.push(value) })
}

fn pop_stk[T](self : Queue[T]) -> (T?, Queue[T]) {
  match self.front {
    Empty => (None, self)
    NonEmpty(top, rest) => (Some(top), normalize({ ..self, front : rest })) 
  }
}

fn normalize[T](self : Queue[T]) -> Queue[T] {
  //if front is empty, revert back into front
  // 如果front为空，反转back到front
  match self.front {
    Empty => { front : self.back.reverse(), back : Empty }
    _ => self
  }
}

fn reverse[T](self : Stack[T]) -> Stack[T] {
  // aux : reverse stack
  // 辅助函数 ： 反转堆栈
  fn go(acc, xs : Stack[T]) {
    match xs {
      Empty => acc
      NonEmpty(top, rest) => go((NonEmpty(top, acc) : Stack[T]), rest)
    }
  }
  go(Empty, self)
}

fn fold_right[A, B](list : List[A], f : (A, B) -> B, b : B) -> B {
  match list {
    Nil => b
    Cons(hd, tl) => f(hd, fold_right(tl, f, b))
  }
}

// 非常精妙的一段代码👍
fn map[A, B](list : List[A], f : (A) -> B) -> List[B] {
  match list {
    Nil => Nil
    Cons(hd, tl) => Cons(f(hd), map(tl, f))
  }
}

fn map_with_fold_right[A, B](list : List[A], f : (A) -> B) -> List[B] {
  fold_right(
    list, 
    fn(value, cumulator) { Cons(f(value), cumulator)},
    Nil
  )
}

fn fold_left[A, B](list : List[A], f : (B, A) -> B, b : B) -> B {
  match list {
    Nil => b
    Cons(hd, tl) => fold_left(tl, f, f(b, hd))
  }
}

/// convert list to string 将列表转化为字符串
fn to_string[T : Show](self : List[T]) -> String {
  fn go(ls : List[T]) {
    match ls {
      Nil => ""
      Cons(x, Nil) => "\{x}"
      Cons(x, xs) => "\{x}, " + go(xs)
    }
  }

  "[" + go(self) + "]"
}


enum List[T] {
  Nil
  Cons(T, List[T])
} derive (Show)

test "init_d" {
  println(
    fold_left(
      Cons("1", Cons("2", Cons("3", Nil))),
      fn(b : String, a) { "(\{b} + \{a})" },
      "0",
    ),
  )
  // (((0 + 1) + 2) + 3)
  println(map(Cons(0, Cons(1, Cons(2, Cons(3, Nil)))), fn(i) { i * 10 }))
  // Cons(0, Cons(10, Cons(20, Cons(30, Nil))))
}

