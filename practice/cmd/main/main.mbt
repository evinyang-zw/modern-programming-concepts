///|
fn main {
  //fib
  println("========fib=========")
  println(@lib.fib(10))
  
  //001_hello
  println("========001_hello=========")
  println(@lib.hello())
  
  //002_fib
  println("========002_fib=========")
  println(@lib.fib1(4))
  println(@lib.fib2(46))
  println(@lib.fib3(46))
  println(@lib.fib4(46))
  
  //003_numbers
  println("========003_numbers=========")
  @lib.numbers()

  //004_generic_list
  println("=======004_generic_list==========")
  let ls = @lib.List::from_array([1, 2, 3, 4, 5]) //create a new List
    .map( fn(x){ x * 2 }) // double each element
    .filter(fn(x){ x < 9 }) // pick those smaller than 9
    println(ls)
  // use `reduce` to calculate the sum of each elements
  let sum = ls.reduce(fn(a,b){ a + b }, 0)
  println("sum: \{sum}")
  // collect elements of List `ls` into Array
  let ary = ls.collect()
  let len = ary.length()
  println("length: \{len}")
  // print each element of List `ls`
  for i in ls {
    println("element: \{i}")
  }
  
  // 005_levenshtein_distance
  println("========005_levenshtein_distance=========")
  println(@lib.levenshtein("abcdheloworldabcd", "abcdhellowoorldabcd"))
  
  // 006_queue
  println("=============006_queue===============")
  let q0 = @lib.from_array([])
  if @lib.is_empty(q0) {
    let q0_ = q0.enqueue(1)
    guard q0_.peek() is Some(x)
    println(x) //1
  }
  let q1 = @lib.from_array([10, 20, 30])
  guard q1.peek() is Some(x)
  println(x) //10
  guard q1.dequeue() is Some(q2) && q2.peek() is Some(y)
  println(y) //20
  let q3 = @lib.from_list(@list.empty()).enqueue(1).enqueue(2)
  guard q3.peek() is Some(x)
  println(x) //1
  guard q3.dequeue() is Some(q3_) && q3_.peek() is Some(y)
  println(y) //2
  guard q3.dequeue() is Some(q4) && q4.dequeue() is Some(_q5)
  if @lib.is_empty(_q5){
    println("Success")
  }

  //007_trait
  println("=========007_trait==========")
  let xs = [1, 2, 3, 4, 5]
  println(@lib.average(xs))
  
  let ps : Array[@lib.Point[Int]] = [
    { x: 1, y: 5 },
    { x: 2, y: 4 },
    { x: 3, y: 3 },
    { x: 4, y: 2 },
    { x: 5, y: 1 }
  ]
  println(@lib.average(ps))
  let ps2 : Array[@lib.Point[Double]] = [
    { x: 1.25, y: 5.25 },
    { x: 2.25, y: 4.25 },
    { x: 3.25, y: 3.25 },
    { x: 4.25, y: 2.25 },
    { x: 5.25, y: 1.25 }
  ]
  println(@lib.average(ps2))

  // 008_object
  println("========008_object=======")
  let duck1 = @lib.Duck::{ name: "duck1" }
  let fox1 = @lib.Fox::{ name: "fox1" }
  let duck2 = @lib.Duck::{ name: "duck2"}
  // use [expr as Trait] to explicitly create trait objects
  // 使用 [expr as Trait] 来显式创建特征对象
  let duc1_animal : &@lib.Animal = duck1 as &@lib.Animal
  let fox1_animal : &@lib.Animal = fox1 as &@lib.Animal
  let duck2_animal : &@lib.Animal = duck2 as &@lib.Animal
  @lib.speak_together([duc1_animal, fox1_animal, duck2_animal])
  println("MoonBit can automatically insert [as] using type information")
  //MoonBit 可以使用类型信息自动插入 [as]
  @lib.speak_together([duck1, fox1, duck2])
}
