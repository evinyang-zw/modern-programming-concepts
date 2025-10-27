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

  // 009_derive
  println("=======009_derive=========")
  let t1 = @lib.T::default() //Default //
  let t2 = @lib.T::{ x: 1, y: 1 }
  println(t1) //Show // {x: 0, y: 0}
  println(t2) //Show // {x: 1, y: 1}
  println(t1 == t2) //Eq // false
  println(t1 < t2) // Compare // true

  //010_operator_overload
  println("===010_operator_overload===")
  let a = @lib.T2::{ x: 0 }
  let b = @lib.T2::{ x: 2 }
  println(a + b)
  
  // 011_tuple_accessors
  println("===011_tuple_accessors===")
  // This example demonstrates tuple accessor in MoonBit.
  // The components of tuple can be extracted directly via [.index](zero based)
  // 这个例子展示了MoonBit中的元组访问器。
  // 元组的组件可以通过[.index]直接提取（基于零索引）

  // access via index
  let x = (1, 2)
  println(x.0) //1
  println(x.1) //2
  // print(x.2) //error, 2-tuple has no field `2`
  let y = ("apple", "tomato", "banana")
  println(y.2) // "banana"
  // access via pattern matching👏
  let (a, b) = (100, 200)
  println("a: \{a}, b: \{b}") // a: 100, b: 200

  // 012_avl_tree
  println("=====012_avl_tree====")
  let mut v : @lib.AVLT[Int] = Empty //Create an empty AVL tree with Int type
  let iter = 100
  // Add values from 0 to iter-1 to the AVL tree
  let mut i = 0
  while i < iter {
    v = v.add(i)
    i = i + 1
  }
  let height = v.height()
  println("height of the tree:\{height}") // height of the tree:8
  println(v)
  // Check values from 0 to iter-1 in the AVL tree
  let mut j = 0
  while j < iter {
    if not(v.mem(j)) {
      println("impossible")
    }
    j = j + 1 
  }
  //Remove values from 0 to iter-1 from the AVL tree
  let mut k = 0
  while k < iter {
    v = v.remove(k)
    k = k + 1
  }
  // Tree is empty, removal successful
  match v {
    Empty => println("success")
    Node(_) => println("impossible")
  }

  // 013_string
  println("====013_string.mbt====")
  let a = @lib.T3::A
  let b = @lib.T3::B
  // Format strings contain "replacement fields" surround by \{}
  // Custom data types with the [to_string] method can be spliced directly
  println("Hello a: \{a} & b: \{b} -- wow~") // Hello a: A & b: B -- wow~
  let c = "string" + " to" + " append" 
  println(c) // string to append
  // multi-line string literal(文字)
  let m = 
    #| A
    #| multi-line
    #| string
    $| \{b} & \{a}
  println(m)
  //  A
  //  multi-line
  //  string
  //  B & A  

  // 014_unicode
  println("====014_unicode====")
  let 😂= @lib.T4(3)
  😂.🥰()// T4(3)

  // 015_hamt
  println("=====015_hamt=====")
  let n = 3
  let mut hamt = @lib.make()
  for i = 0; i < n; i = i + 1 {
    hamt = hamt.add(i, i)
  }
  let collision_count = hamt.count_collision()
  println("number of collision: \{collision_count}")
  // uncomment this to see the tree (large trees may not display properly)
  // 取消注释以查看树形结构（大树可能无法正确显示）
  //hamt.print_hamt(0)
  let mut is_ok = true
  for i = 0; i < n; i = i + 1 {
    match hamt.find(i) {
      Some (v) => 
        if v != i {
          is_ok = false
          println("\{i}: wrong value")
        }
      None => {
        is_ok = false
        println("\{i}: not found")
      }
    }
    if is_ok {
      println("OK!")
    }
  }
  
  // 016_skew_binary_list
  println("====016_skew_binary_list====")
  let xs = @lib.BList::from_array([1, 2, 3, 4, 5])
  println(xs)
  loop (xs.pop()) {
    None => ()
    Some((x, xs)) => {
      println(x)
      continue xs.pop()
    }
  }
  // note that [xs] is untouched since [BList] is functional
  // 请注意，[xs] 没有被改变，因为 [BList] 是函数式的💡⚠️
  let xs = xs.push(6).push(7)
  println(xs)
  for i = 0; i < xs.bl_length(); i = i + 1 {
    println(xs[i])
  }
  
  //017_vector
  println("=====017_vector=====")
  let v1 : @lib.Vector[Int] = @lib.Vector::new(5)
  println(v1)
  v1.push_back(42)
  println(v1)
  let v2 : @lib.Vector[@lib.T5] = @lib.Vector::new(5)
  println(v2)
  v2.push_back({ x: 42 })
  println(v2)
}
