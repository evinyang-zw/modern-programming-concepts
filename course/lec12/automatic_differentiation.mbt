/// Symbolic differentiation 符号微分
priv enum Symbol {
  Constant(Double)
  Var(Int)
  Add(Symbol, Symbol)
  Mul(Symbol, Symbol)
} derive(Show)

impl Add for Symbol with add(s1 : Symbol, s2 : Symbol) -> Symbol {
  Add(s1, s2)
}

impl Mul for Symbol with mul(s1 : Symbol, s2 : Symbol) -> Symbol {
  Mul(s1, s2)
}

fn constant(d : Double) -> Symbol {
  Constant(d)
}

fn vari(i : Int) -> Symbol {
  Var(i)
}

fn add(s1 : Symbol, s2 : Symbol) -> Symbol {
  // Add(s1, s2) // Without simplification 无化简实现
  // With simplification 以下为化简实现
  match (s1, s2) {
    (Constant(0.0), a) => a
    (Constant(a), Constant(b)) => Constant(a + b)
    (a, Constant(_) as constant_) => add(a, constant_)
    _ => Add(s1, s2)
  }
}

fn mul(s1 : Symbol, s2 : Symbol) -> Symbol {
  // Mul(s1, s2) // Without simplification 无化简实现
  // With simplification 以下为化简实现
  match (s1, s2) {
    (Constant(0.0), _) => Constant(0.0)
    (Constant(1.0), a) => a
    (Constant(a), Constant(b)) => Constant(a * b)
    (a, Constant(_) as constant_) => mul(a, constant_)
    _ => Mul(s1, s2)
  }
}

fn example() -> Symbol {
  //constant(5.0) * vari(0) * vari(0) + vari(1)
  //constant(5.0) * vari(0)
  add(mul(mul(constant(5.0), vari(0)), vari(0)), vari(1))
}

fn compute(self : Symbol, input : Array[Double]) -> Double {
  match self {
    Constant(d) => d
    Var(i) => input[i] //get value following index 根据下标取值
    Add(s1, s2) => s1.compute(input) + s2.compute(input)
    Mul(s1, s2) => s1.compute(input) * s2.compute(input)
  }
}

// val is the index of the variable to be differentiated
// val 代表当前微分变量的下标
fn differentiate(self : Symbol, val : Int) -> Symbol {
  match self {
    Constant(_) => Constant(0.0)
    // determine if index is the variable to be differentiated
    // 根据下标判断是否为微分对象
    Var(i) => if i == val { Constant(1.0) } else { Constant(0.0) }
    Add(s1, s2) => s1.differentiate(val) + s2.differentiate(val)
    // Add(s1, s2) => add(s1.differentiate(val), s2.differentiate(val))
    // 上面这种写法不知道为什么无法运行，但是实现Add接口后没有注释的写法就可以，回顾时注意下这个问题
    Mul(s1, s2) => s1 * s2.differentiate(val) + s1.differentiate(val) * s2
    // Mul(s1, s2) => add(mul(s1, s2.differentiate(val)), mul(s1.differentiate(val), s2))
  }
}

test {
  println("=====================")
  let input = [10.0, 100.0]
  println("Symbolic differentiation 符号微分")
  let symbol : Symbol = example()
  println(symbol)
  println(symbol.compute(input))
  println("Expression of df/dx 关于x的偏微分表达式树")
  println(symbol.differentiate(0))
  println(symbol.differentiate(0).compute(input))
  println(symbol.differentiate(1).compute(input))
  println("=====================")
}

// Abstraction of computation 对运算的抽象
trait Number {
  constant(Double) -> Self
  op_add(Self, Self) -> Self
  op_mul(Self, Self) -> Self
  value(Self) -> Double
}
priv struct Forward {
  value : Double
  derivative : Double
} derive(Show)

//Implement abstraction for Double 对浮点数实现抽象
impl Number for Double with constant(d : Double) -> Double {
  d
}

impl Number for Double with value(d : Double) -> Double {
  d
}

impl Number for Double with op_add(d1 : Double, d2 : Double ) -> Double {
  d1 + d2
}

impl Number for Double with op_mul(d1 : Double, d2 : Double ) -> Double {
  d1 * d2
}

impl Number for Forward with constant(d : Double) -> Forward {
  { value : d, derivative : 0.0 }
}

impl Number for Forward with value(f : Forward) -> Double {
  f.value
}

impl Number for Forward with op_add(f1 : Forward, f2 : Forward) -> Forward {
  {
    value : f1.value + f2.value,
    derivative : f1.derivative + f2.derivative //f1' + f2',,,
  }
}

impl Number for Forward with op_mul(f1 : Forward, f2 : Forward) -> Forward {
  {
    value : f1.value * f2.value,
    derivative : f1.value * f2.derivative +  f1.derivative * f2.value //f1 * f2' + f1' * f2 ,,,
  }
}

impl Add for Forward with add(f1 : Forward, f2 : Forward) -> Forward{
  {
    value : f1.value + f2.value,
    derivative : f1.derivative + f2.derivative // f1' + f2'
  }
}

impl Mul for Forward with mul(f1 : Forward, f2 : Forward) -> Forward{
  {
    value : f1.value * f2.value,
    derivative : f1.value * f2.derivative + f1.derivative * f2.value //f1 * f2' + f1' * f2 ,,,
  }
}

fn [N : Number]relu(x : N) -> N {
  max(x, N::constant(0.0))
}

fn [N : Number]max(x : N, y : N) -> N {
  if  x.value() > y.value() {
    x
  } else {
    y
  }
}

// diff: weather differentiate this variable
// diff: 是否对当前变量求偏微分
fn var_(d : Double, diff : Bool) -> Forward {
  {value : d, derivative : if diff { 1.0 } else { 0.0 } }
}

test {
  println("Compute using abstraction 利用抽象进行计算值")
  println(relu(10.0)) // 10
  println(relu(-10.0)) // 0
  println("Forward differentiation with abstraction 利用抽象进行前向微分")
  println(relu(var_(10.0, true))) // {value: 10, derivative: 1}
  println(relu(var_(-10.0, true))) // {value: 0, derivative: 0}
  // f(x, y) = x * y, 求df/dy(10, 100)
  (var_(10.0, false) * var_(100.0, true)) |> println // {value: 1000, derivative: 10}
}

// Backward differentiation 后向微分
// Warning : this implementation is not fully correct as it can cause exponential complexity
// 警告: 这个实现并不完全正确，可能会导致指数级复杂度的计算
priv struct Backward {
  value : Double
  backward : (Double) -> Unit
  // update the partial derivative of the current path 
  // 更新当前路径获得的偏微分
}

impl Mul for Backward with mul(b1 : Backward, b2 : Backward) -> Backward{
  {
    value: b1.value * b2.value,
    backward: fn (diff){
      b1.backward(diff * b2.value)
      b2.backward(diff * b1.value)
    }
  }
}
fn Backward::var__(value : Double, diff : Ref[Double]) -> Backward {
  // accumulate partial derivative 累加偏微分
  { value, backward : fn { d => diff.val = diff.val + d } }
}

fn Backward::backward(b : Backward, d : Double) -> Unit {
  (b.backward)(d)
}

test {
  println("Backward differentiation 后向微分")
  let diff_x = Ref::{ val: 0.0 }
  let diff_y = Ref::{ val: 0.0 }
  let x = Backward::var__(10.0, diff_x)
  let y = Backward::var__(100.0, diff_y)
  println(diff_x)
  println(diff_y)
  (x * y).backward(1.0) // df / df = 1
  println("==========")
}

fn Forward::example_newton(x : Forward) -> Forward {
  x * x * x + Number::constant(-10.0) * x * x + x + Number::constant(1.0)
}

test {
  println("Newton's method 牛顿迭代法案例")
  fn abs(d : Double) -> Double {
    if d >= 0.0 {
      d
    } else {
      -d
    }
  }
  
  loop var_(1.0, true) {// initial value 初始值
    x => {
      let { value, derivative} = Forward::example_newton(x)
      if abs(value / derivative) < 1.0e-9 {
        break println(x.value)
      }
      continue var_(x.value - value / derivative, true)
    }
  } 
}
