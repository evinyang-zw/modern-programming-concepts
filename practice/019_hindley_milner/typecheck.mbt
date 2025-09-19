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