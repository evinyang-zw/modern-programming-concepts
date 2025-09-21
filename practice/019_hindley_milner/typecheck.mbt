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
suberror TypeCheckError {
  OccursError
  TypeMismatchError
  VariableNotFoundError(String)
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
///|
pub fn infer(ctx : Map[String, Type], expr : Expr) -> Type raise TypeCheckError {
  match expr {
    Var(name) => 
      match ctx.find(name) {
        None => raise VariableNotFoundError("variable not found: \{name}")
        Some(ty) => ty.instantiate()
      }
    Con(con) => T_Con(con)
    Lam(param, body) => {
      let tparam = fresh(ctx.length())
      let tret = infer(Extend(param, tparam, ctx), body)
      T_Lam(tparam, tret)
    }
    App(func, arg) => {
      let tfunc = infer(ctx, func)
      let targ = infer(ctx, arg)
      let tret = fresh(10000000)
      unify(tfunc, T_Lam(targ, tret))
      
    }
    
  }
}

///|
fn[K : Eq, V] find(self : Map[K, V], key : K) -> V? {
  match self {
    Empty => None
    Extend(my_key, my_value, rest) => 
      if my_key == key {
        Some(my_value)
      } else {
        rest.find(key)
      }
  }
}

///|
/// instantiate: 通常指创建一个类的实例，即创建一个对象。
/// 强烈的自我调用思想
fn instantiate(self : Type) -> Type {
  let mut subst = Map::Empty
  fn go(ty : Type) {
    match ty.repr() {
      T_Var({ val: Generic(id) }) => 
        match subst.find(id) {
          Some(ty) => ty
          None => {
            let ty = fresh(1000000)
            subst = Extend(id, ty, subst)
            ty
          }
        }
      T_Lam(t1, t2) => T_Lam(go(t1), go(t2))
      T_App(f, a) => T_App(go(f), go(a))
      ty => ty
    }
  }

  go(self)
} 

///|
/// 自我调用思想用到了极致，难理解，注意🤔
fn repr(self : Type) -> Type {
  match self {
    T_Var({ val: Solved(ty) } as tvar) => {
      let ty = ty.repr()
      tvar.val = Solved(ty)
      ty
    }
    ty => ty
  }
}

///|
fn fresh(lvl : Int) -> Type {
  let tag = counter.val
  counter.val = tag + 1
  T_Var({ val: Free(tag, lvl) })
}

///|
fn[K,V] length(self : Map[K, V]) -> Int {
  match self {
    Empty => 0
    Extend(_, _, rest) => rest.length() + 1
  }
}

fn unify(t1 : Type, t2 : Type) -> Unit raise TypeCheckError {
  match (t1.repr(), t2.repr()) {
    (T_Var({ val: Free(tag, lvl) } as tv), ty)
    | (ty, T_Var({ val: Free(tag, lvl) } as tv)) => {
      match ty {
        T_Var({ val: Free(alt_tag, _) }) => if tag == alt_tag { return }
        _ => ()
      }
    }
  }
}