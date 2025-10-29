/// Since MoonBit considers global mutable variables harmful,
/// declaring a mutable variable directly in the global scope is not allowed.
/// 由于 MoonBit 认为全局可变变量是有害的，直接在全局作用域中声明可变变量是不允许的。
/// 
/// In Some cases where global mutable state is necessary,
/// we can use a struct with mutable fields or use the `Ref` instead.
/// 在某些情况下，如果需要全局可变状态，我们可以使用具有可变字段的struct，或者使用`Ref`代替。

/// 1. use a struct with mutable fields
priv struct Context {
  mut uuid : Int
  mut log : String
}

let context : Context = { uuid: 0, log: "" }

///| `log[T: Show](x: T)`
fn[T : Show] log(x : T) -> Unit {
  context.log += x.to_string()
}

fn fresh_uuid() -> Int {
  context.uuid += 1
  context.uuid
}

test {
  log("Get a UUID: ")
  log(fresh_uuid())
  log(", another UUID: ")
  log(fresh_uuid())
  log(", final UUID: ")
  log(fresh_uuid())
  inspect(context.log, content="Get a UUID: 1, another UUID: 2, final UUID: 3")
}

/// 2. use the `Ref`
let data : Ref[String] = @ref.new("Data: ")

fn[T : Show] add_data(x : T) -> Unit {
  data.update( fn(y){ y + x.to_string() })
}

test {
  add_data("Hello, ")
  add_data("ref")
  inspect(data.val, content="Data: Hello, ref")
}


