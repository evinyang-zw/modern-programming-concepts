// This example demonstrates number literals in MoonBit
// 这个例子展示了MoonBit中的数字字面量
// literals: 字面量

pub fn numbers() -> Unit {
  println(1234) //1234

  // Underscores can be placed anywhere within a number.
  // 下划线可以放在数字的任何位置
  println(1_000_000) // 1000000

  // Hexadecimal numbers start with '0x' or '0X'
  println(0xA234) // 41524
  println(0XA234) // 41524
  
  // Binary Numbers start with '0b' or '0B'
  // Note that the digit after '0b' or '0B' must be 0 or 1
  // 请注意，'0b'或'0B'后面的数字必须是0或1。
  // digit: 数字
  println(0b110010) //50
  println(0B110010) //50

  // Octal Numbers start with '0o' or '0O'
  println(0o1234) // 668
  println(0O1234) // 668
}