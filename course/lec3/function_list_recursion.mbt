let pi = 3.141592653578

let surface_r_1 : Double = {
  let r = 1.0
  pi * r * r
}

let surface_r_2 : Double = {
  let r = 2.0
  pi * r * r
}

let surface_r_3 : Double = {
  let r = 3.0
  pi * r * r
}

fn 面积(半径 : Double) -> Double {
  pi * 半径 * 半径
}

//The following two lines are eqivalent
//let result : (Double, Double, Double) = (surface_r_1, surface_r_2, surface_r_3)

let result : (Double, Double, Double) = (面积(1.0), 面积(2.0), 面积(3.0))

fn one() -> Int {
  1
}

fn add_char(ch : Char, str : String) -> String{
  ch.to_string() + str
}

let moonbit : String = add_char(Char::from_int(100), "oonbit")

let ch : Char = Char::from_int(-1)

let nan : Int = 1 / 0

fn div(a : Int, b : Int) -> Int?{//Option[Int]
  if b == 0{
    None
  }else{
    Some(a / b)
  }
}

let answer : () -> Int = fn(){
  fn real_answer(i) {
    42
  }
  real_answer("Ultimate answer")
}

let int_list : @immut/list.T[Int] = Cons(1, Cons(2, Cons(3, Nil)))

let char_list : @immut/list.T[Char] = Cons('一', Cons('句', Cons('话', Nil)))

// The following three lines do not compile as they are not vaild lists
// let not_list1 : List[Int] = Cons(1, Cons(true, Cons(3, Nil)))
// let not_list2 : List[Int] = Cons(1,2)
// let not_list3 : List[Int] = Cons(1, Cons(Nil, Nil))

fn head_opt(list : @immut/list.T[Int]) -> Int?{// Option[T] 表示可能缺失Int类型的值
  match list {
    Nil => None
    Cons(head, tail) => Some(head) //'=>' 映射符号
  }
}

let first_elem : Int? = head_opt(Cons(1, Cons(2, Nil))) // Some(1)

fn get_or_else(option_int : Int?, default : Int) -> Int {
  match option_int {
    None => default
    Some(value) => value
  }
}

fn get(option_int : Int?, default : Int) -> Int {
  match option_int {
    Some(value) => value
    None => 0
  }
}

fn fib(n : Int) -> Int {
  if n == 1 || n == 2 {
    1
  } else {
    fib(n - 1) + fib(n - 2)
  }
}

fn even(n : Int) -> Bool {
  n != 1 && (n == 0 || odd(n - 1))
}

fn odd(n : Int) -> Bool {
  n != 0 && (n == 1 || even(n - 1))
}

fn length(list : @immut/list.T[Int]) -> Int {
  match list {
    Nil => 0
    Cons(_, tl) => 1 + length(tl)
  }
}

let n : Int = length(Cons(1, Cons(2, Nil))) // n = 2

fn tail(list : @immut/list.T[Int]) -> @immut/list.T[Int] {
  match list {
    Nil => Nil
    Cons(_, tail) => tail //子列表
  }
}
