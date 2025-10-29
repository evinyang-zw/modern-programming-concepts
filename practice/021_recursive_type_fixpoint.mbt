///| Rectype mu w/ a `Fold` constructor
/// Intuitively, Mu[T] is the solution of Mu[T] ~= Mu[T] -> T
/// 
/// Rectype 是一种编程语言中的数据类型，用于表示具有可变结构的类型，常见于函数式编程语言中。
/// 
/// 使用`Fold`构造器创建Rectype mu
/// 直观上，Mu[T]是Mu[T] ~= Mu[T] -> T的解
priv enum Mu[T] {
  Fold((Mu[T]) -> T)
}

///| As one would use in APL.
/// 
/// 就像在APL中那样使用。
pub fn iota(n : Int) -> Array[Int] {
  match n {
    0 => []
    n => iota(n - 1) + [n]
  }
}

///| Unfold that expand the rectype w/ pattern matching
/// 
/// 使用模式匹配展开rectype类型
fn[T] unfold(folded : Mu[T]) -> (Mu[T]) -> T {
  match folded {
    Fold(f) => f
  }
}

///| M Combinator : λx.xx
fn[T] m(x : Mu[T]) -> T {
  unfold(x)(x)
}

///| An isorecursive approach of the Y Combinator: M W
/// MoonBit is a strict language thus the Z combinator is used instead of Y
/// 
/// Y组合子的可分离递归方法：M W。
/// MoonBit是一种严格的语言，因此使用Z组合子代替Y
pub fn[T] fix(f : ((T) -> T) -> (T) -> T) -> (T) -> T {
  // W Combinator: λxλyλz.xyyz
  let  wt : Mu[(T) -> T] = Fold(fn(x){ f(fn(t : T){ unfold(x)(x)(t) }) })
  m(wt)
}

///| A modified factorial definition to *generate* a recursive factorial function
/// 
/// 一个修改后的阶乘定义来*生成*递归阶乘函数
pub fn gen_factorial(f : (Int) -> Int) -> (Int) -> Int {
  fn(n : Int){ if n == 0 { 1 } else { n * f(n - 1) }}
}

///| We can also implement the fixpoint using recursion. -- There's no point.
/// 
/// 我们也可以使用递归来实现不动点。-- 没有意义。
pub fn[T] fix_rec(f : ((T) -> T) -> (T) -> T) -> (T) -> T {
  fn(x) { f(fix_rec(f))(x) }
}

pub fn gen_fibonacci(f : (Int) -> Int) -> (Int) -> Int {
  fn(n : Int) {
    match n {
      0 => 0
      1 => 1
      n => f(n - 1) + f(n - 2)
    }
  }
}