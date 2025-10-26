// This example is a MoonBit implementation of skew binary list,
// an efficient functional list-like data structure with `O(1)` push/pop and `O(log(N))` random access
// 这个例子是一个MoonBit实现的斜二叉列表，
// 一种高效的函数式类似列表的数据结构，具有`O(1)`的推/弹出和`O(log(N))`的随机访问
// 
// See Chris Okasaki's book "Purely functional data structure" for more details.
// 请参考 Chris Okasaki 的书《纯函数数据结构》以获取更多详细信息

///|
/// The type of a skew binary list
/// 
/// `BList[X]` is basically a linked list of `(Int, Tree[X])`, with the constraints that:
/// - the trees are in increasing order of size
/// - there can be two trees with the smallest size,
/// for all other sizes, there can be only one tree in a skew binary list
/// `BList[X]`基本上是一个由`(Int, Tree[X])`组成的链表，其约束条件为：
/// - 树按大小递增排序
/// - 可以有两个最小树
/// 对于其他大小的树，斜二叉列表中只能有一个树
pub enum BList[X] {
  Empty
  Tree(Int, Tree[X], BList[X])
} derive(Show)

///|
/// The type of a non-empty *complete* binary tree.
/// 
/// 一个非空*完全*二叉树的类型。
enum Tree[X] {
  Leaf(X)
  Branch(X, Tree[X], Tree[X])
} derive(Show)

///|
pub fn[X] BList::from_array(xs : Array[X]) -> BList[X] {
  loop (xs.length(), BList::Empty) {
    (0, acc) => acc
    (i, acc) => continue (i - 1, acc.push(xs[i - 1]))
  }
}

///|
/// push a new element to the head of a skew binary list
/// 
/// 将一个新元素推入斜二叉列表的头部
/// 
/// This operation is `O(1)`
pub fn[X] push(self : BList[X], elem : X) -> BList[X] {
  match self {//❓❓❓
    Tree(1, left, Tree(1, right, rest)) =>
      // Since 1 is the smallest size in [self],
      // we know that there can be at most one tree of size 3 in [rest]
      // So in the resulting tree, there can be at most two trees of size 3.
      // Since 3 is the smallest tree size in the new tree, the invariant is maintained.
      // 由于1是[self]中最小的尺寸，
      // 我们知道[rest]中最多只能有一个大小为3的树。
      // 因此，在结果树中，最多只能有两个大小为3的树。
      // 由于3是新树中最小的树尺寸，因此不变性得到了保持。
      Tree(3, Branch(elem, left, right), rest)
    _ =>
      // There is at most one tree of size 1 in [self]
      // 在[self]中最多只有一个大小为1的树
      Tree(1, Leaf(elem), self)
  }
}

///|
/// pops an element from a skew binary list, returns that element and the remaining list
/// 
/// 从斜二叉列表中弹出一个元素，返回该元素和剩余的列表
/// 
/// This operation is `O(1)`
pub fn[X] pop(self : BList[X]) -> (X, BList[X])? {
  match self {
    Empty => None
    Tree(_, Leaf(x), rest) => Some((x, rest))
    Tree(tree_size, Branch(x, left, right), rest) => {
      let subtree_size = (tree_size - 1) / 2
      // [tree_size] is the smallest size in the original tree,
      // So [rest] contain no tree of size [subtree_size],
      // and [subtree_size] is the smallest tree size in the result.
      // Hence the invariant is maintained here.
      // [tree_size]是原始树中最小的尺寸，
      // 所以[rest]不包含尺寸为[subtree_size]的树，
      // 并且[subtree_size]是结果中最小的树尺寸。
      // 因此在这里保持不变式。
      Some((x, Tree(subtree_size, left, Tree(subtree_size, right, rest))))
    }
    
  }
}

///|
/// compute the length of a skew binary list in `O(log(N))` time
pub fn[X] bl_length(self : BList[X]) -> Int {
  loop (self, 0) {
    (Empty, len) => len
    (Tree(tree_size, _, rest), len) => continue (rest, tree_size + len)
  }
}

///|
/// get the nth element in a skew binary list.
/// 
/// 获取斜二叉列表中的第n个元素。
/// 
/// This operation is `O(log(N))`
pub fn[X] op_get(self : BList[X], idx : Int) -> X? {
  match self {
    Empty => None
    Tree(tree_size, tree, rest) =>
      // Since the tree are all complete and of increasing size,
      // every tree we skip, [idx] must be exponentially larger.
      // So we will skip only [O(log(N))] trees. 
      // 由于所有树都是完整的并且尺寸递增，
      // 我们跳过的每一棵树，[idx] 必须呈指数级增大。
      // 所以我们只会跳过 [O(log(N))] 棵树
      if idx < tree_size {
        // ... and [tree.nth] is also [O(log(N))].
        // So [BList::op_get]'s complexity is [O(log(N))].
        // ...和[tree.nth]也是[O(log(N))].
        //所以[BList::op_get]的复杂度是[O(log(N))]
        Some(tree.nth(tree_size, idx))
      } else {
        rest[idx - tree_size]
      }
  }
}

///|
/// get the in-order nth element in a binary tree.
/// 
/// 获取二叉树中中序的第n个元素。
/// 
/// `tree_size` is the size of the tree,
/// which must be `2^tree_height - 1` since the tree is complete
/// 
/// `tree_size` 是树的大小，由于树是完整的，所以它必须是 `2^tree_height - 1`
/// 
/// This operation is `O(log(N))` thanks to completeness of the tree
fn[X] nth(self : Tree[X], tree_size : Int, idx : Int) -> X {
  match self {
    Leaf(x) => x // [idx] must be 0
    Branch(first, left, right) => 
      if idx == 0 {
        first
      } else {
        let subtree_size = (tree_size - 1) / 2
        if idx - 1 < subtree_size {
          left.nth(subtree_size, idx - 1)
        } else {
          right.nth(subtree_size, idx - 1 - subtree_size)
        }
      }
  }
}