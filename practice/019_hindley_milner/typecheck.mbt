///|
pub(all) enum Type {
  T_Lam(Type, Type)
  T_App(Type, Type)
  T_Var(Ref[Tvar])
  T_Con(String)
} derive(Show)

///|
enum Tvar {
  Free(Int, Int)
  Generic(Int)
  Solved(Type)
} derive(Show)

///|
enum Map[K, V] {
  Empty
  Extend(K, V, Map[K, V])
}

///|
let counter : Ref[Int] = { val : 0 }

///|
pub fn[K, V] Map::of_array(xs : Array[(K, V)]) -> Map[K, V] {
  let mut result: Map[_] = Empty
  for i = xs.length() - 1; i >= 0; i = i - 1 {
    let (k, v) = xs[i]
    result = Extend(k, v, result)
  }
  result
}

///|
pub fn fresh_generic() -> Type {
  let tag = counter.val
  counter.val = tag + 1
  T_Var({ val : Generic(tag)})
}