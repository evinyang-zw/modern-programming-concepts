// This example demonstrates MoonBit's ability to automatically derive implements for some traits
// 这个例子展示了MoonBit自动为某些特征派生实现的能力
pub(all) struct T {
  x: Int
  y: Int
} derive(Eq, Compare, Show, Default)
