// This example calculates the Levenshtein distance between two string using dynamic programming.
// 这个例子使用动态规划计算两个字符串之间的Levenshtein距离。

// It demonstrates MoonBit's imperative features.
// 它展示了MoonBit的命令式特性。

// MoonBit supports the implementation of efficient imperative algorithms and data structures.
// MoonBit 支持高效命令式算法和数据结构的实现。

/// `levenshtein(a : String, b : String)`
/// 
/// Calculate the Levenshtein distance between two strings using dynamic programming.
/// 使用动态规划计算两个字符串之间的Levenshtein距离。
/// 
/// This function calculates the Levenshtein distance between two input strings `a` and `b`,
/// 这个函数计算两个输入字符串 `a` 和 `b` 之间的 Levenshtein 距离，
/// which is defined as the minimum number of single-character edits (insertions, deletions,
/// or substiutions) required to transform string `a` into string `b`.
/// 它被定义为将字符串 `a` 转换为字符串 `b` 所需的最少单字符编辑次数（插入、删除或替换）。
pub fn levenshtein(a : String, b : String) -> Int {
  let m = a.length()
  let n = b.length()
  let s = [[], []]
  // create Array of length n + 1 with elements initialized to 0
  // 创建一个长度为n+1的数组，并将所有元素初始化为0
  s[0] = Array::make(n + 1, 0) // s[0][0] = 0, ..., s[0][n] = 0
  s[1] = Array::make(n + 1, 0) // s[1][0] = 0, ..., s[1][n] = 0
  // s[i][j] 表示字符串 a 的前 i 个字符与 b 的前 j 个字符之间的编辑距离
  let mut j = 1
  while j <= n {
    s[0][j] = j //初始化首行：全部删除代价
    j = j + 1
  }

  let mut i = 1
  while i <= m {
    s[i.land(1)][0] = i //初始化首列：全部插入代价
    let mut j = 1
    while j <= n {
      s[i.land(1)][j] = 
        if a[i - 1] == b[j - 1] {
          s[(i - 1).land(1)][j - 1] //字符相等：无代价
        } else {
          1 + min(                  //字符不等：选最优操作
            min(s[(i - 1).land(1)][j - 1], //replace
                s[(i - 1).land(1)][j]      //delete
            ),
            s[i.land(1)][j - 1]            //insert
          )
        }
      j = j + 1
    }
    i = i + 1
  }
  s[m.land(1)][n]
}
///|
fn min(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}