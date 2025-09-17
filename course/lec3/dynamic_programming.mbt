// Top-down 自顶向下
// Fibonacci using map 利用
fn fib1(num : Int) -> Int64 {
  fn aux(num : Int, map : AVLMap[Int, Int64]) -> (Int64, AVLMap[Int, Int64]){
    match get(map, num) {
      None => {
        let (result_1, map_1) = aux(num - 1, map)
        let (result_2, map_2) = aux(num - 2, map_1)
        (result_1 + result_2, put(map_2, num, result_1 + result_2))
      }
      Some(result) => (result, map)
    }
  }

  let map = put(put(make(num), 1, 1L), 2, 1L)
  aux(num, map).0
}

//Use mutable variable to avoid passing map around
//利用可变变量避免传递map
fn fib_mut(num : Int) -> Int64 {
  let mut map = put(put(make(num), 1, 1L), 2, 1L)
  fn aux(num : Int) -> Int64 {
    match get(map, num) {
      None => {
        let result_1 = aux(num - 1)
        let result_2 = aux(num - 2)
        map = put(map, num, result_1 + result_2)
        result_1 + result_2
      }
      Some(result) => result 
    }
  }
  aux(num)
}

// Bottom-up 自底向上
fn fib2(num : Int) -> Int64 {
  fn aux(n : Int, map : AVLMap[Int, Int64]) -> Int64 {
    let result = get_or_else(get(map, n - 1), 1L) + 
      get_or_else(get(map, n - 2), 1L)
    if n == num {
      result
    } else {
      aux (n + 1, put(map, n, result))
    }
  }

  let map = put(put(make(num), 0 , 0L), 1, 1L)
  aux(1, map)
}

test {
  println(fib1(60)) //现在就想知道60的斐波那契值是多少
  // println(fib_mut(60))
  // println(fib2(60))
}

// --------------AVLMap----------------

// https://zhuanlan.zhihu.com/p/430867594

// Empty represents an empty node in the AVL tree
// Node represents a node in the AVL tree with left child, key, value, right child, and height

enum AVLMap[Key, Value] {
  Empty
  Node(AVLMap[Key, Value], Key, Value, AVLMap[Key, Value], Int)
}

fn put(
  map : AVLMap[Int, Int64],
  num : Int,
  result : Int64
) -> AVLMap[Int, Int64] {
  map.add(num, result)
}

///`add[Key:Compare, Value](self: AVLMap[Key, Value], key: Key, value: Value)`
/// 
/// Add an entry to a tree-like structure
fn add[Key : Compare, Value](
  self : AVLMap[Key,Value],
  key : Key,
  value : Value
) -> AVLMap[Key, Value] {
  match self {
    Empty => Node(Empty, key, value, Empty, 1)
    Node(l, k, v, r, _) as t => {
      let c = key.compare(k)
      if c == 0{
        t
      } else if c < 0 {
        bal(l.add(key, value), k, v, r) //平衡函数
      } else {
        bal(l, k, v, r.add(key, value))
      }
    } 
  }
}

///`bal[Key, Value](l: AVLMap[Key, Value], key: Key, value: Value, r: AVLMap[Key,Value])`
/// 
/// Perform balancing operation on a avl tree node.
/// 
/// This function performs a balancing operation on a avl tree node based on the heights
/// of its left and right subtrees. It ensures that the heights of the subtress are balanced
/// and returns a new avl tree ndoe with appropriate restructuring if necessary.
/// ***未完全理解，还需再回看***
fn bal[Key, Value](
  l : AVLMap[Key, Value],
  key : Key,
  value : Value,
  r : AVLMap[Key, Value]
) -> AVLMap[Key, Value] {
  let hl = l.height()
  let hr = r.height()
  
  // Left subtree is taller by more than 2 level
  if hl > hr + 2 {
    match l {
      Empty => Empty //impossible
      Node(ll, lk, lv, lr, _) => 
        if ll.height() >= lr.height() {
          create(ll, lk, lv, create(lr, key, value, r))
        } else {
          match lr {
            Empty => Empty //impossible
            Node(lrl, lrk, lrv, lrr, _) => 
              create(
                create(ll, lk, lv, lrl),
                lrk,
                lrv,
                create(lrr, key, value, r)
              )
          }
        }
    }
  } else if hr > hl + 2 {
    //Right subtree is taller by more than 2 level
    match r {
      Empty => Empty //impossible
      Node(rl, rk, rv, rr, _) => 
        if rr.height() >= rl.height() {
          create(
            create(l, key, value, rl),
            rk,
            rv,
            rr
          )
        } else {
          match rl {
            Empty => Empty // impossible
            Node(rll, rlk, rlv, rlr, _) => 
              create(
                create(l, key, value, rll),
                rlk,
                rlv,
                create(rlr, rk, rv, rr)
              )            
          }
        }
    }
  } else {
    Node(l, key, value, r, if hl >= hr {hl + 1} else {hr + 1})
  }
}

///`height[Key, Value](self: AVLMap[Key, Value])`
/// 
/// Calculate the height of a tree-like structure.
fn height[Key, Value](self : AVLMap[Key, Value]) -> Int {
  match self {
    Empty => 0
    Node(_, _, _, _, h) => h
  }
}
/// `create[Key, Value](l :  AVLMap[Key, Value], key : Key, value : Value, r : AVLMap[Key, Value])`
/// 
/// Create a new node with the given left and right subtrees, along with a key of type `Key`
/// and a value of type `Value`
fn create[Key, Value] (
  l : AVLMap[Key, Value],
  key : Key,
  value : Value,
  r : AVLMap[Key, Value]
) -> AVLMap[Key, Value] {
  let hl = l.height()
  let hr = r.height()
  Node(l, key, value, r, if hl >= hr {hl + 1} else {hr + 1})
}

fn make(num : Int) -> AVLMap[Int,Int64] {
  AVLMap::Empty // 空平衡二叉树
}

fn get(map : AVLMap[Int, Int64], num : Int) -> Int64? {
  match map {
    Empty => None
    Node(l, k, v, r, _) => {
      let c = num.compare(k)
      let tree = if c < 0 { l } else { r }
      if c == 0 {
        Some(v)
      } else {
        get(tree, num)
      }
    }
  }
}

fn get_or_else(option_int : Int64?, default : Int64) -> Int64 {
  match option_int {
    None => default
    Some(value) => value
  }
}