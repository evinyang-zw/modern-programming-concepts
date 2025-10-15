// This example is an functional implementation of AVL tree,
// an efficient, balanced binary search tree.
// 这是一个AVL树的函数实现，AVL树是一种高效、平衡的二叉搜索树。

///|
/// The type of an AVL tree storing elements of type `U`
/// 
/// `Empty` represents an empty node in the AVL tree
/// `Node` represents a node in the AVL tree with left child, value, right child, and height
/// 
///  存储(元素)类型为 `U` 的 AVL 树的类型
/// 
/// `Empty` 表示 AVL 树中的空节点
/// `Node` 表示 AVL 树中的节点，具有左子节点、值、右子节点和高度
pub(all) enum AVLT[U] {
  Empty
  Node(left~ : AVLT[U], elem~ : U, right~ : AVLT[U], height~ : Int )
}

///|
/// `[U] height(self : AVLT[U])`
/// 
/// Calculate the height of a tree-like structure.
pub fn[U] height(self : AVLT[U]) -> Int {
  match self {
    Empty => 0
    Node(height~, ..) => height
  }
}

///|
/// `[U] create(left : AVLT[U], elem : U, right : AVLT[U])`
/// 
/// create a new node with the given left an right subtrees, along with a value of type `U`.
/// 使用给定的左子树和右子树，以及（元素）类型为 `U` 的值创建一个新节点。
pub fn[U] create(left : AVLT[U], elem : U, right : AVLT[U]) -> AVLT[U] {
  let hl = left.height()
  let hr = right.height()
  Node(left~, right~, elem~, height=if hl >= hr { hl + 1 } else { hr + 1 })
}

///|
/// `[U] bal(l : AVLT[U], v : U, r : AVLT[U])`
/// 
/// perform balancing operation on a avl tree node.
/// 
/// This function performs a balancing operation on a avl node based on the heights
/// of its left and right subtrees. It ensures that the heights of the subtrees are balanced 
/// and returns a new avl tree node with appropriate restructuring if necessary.
/// 👍这个函数根据其左右子树的高度执行平衡操作。它确保子树的高度平衡，并在必要时返回一个经过适当重构的新AVL树节点。
pub fn[U] bal(l : AVLT[U], v : U, r : AVLT[U]) -> AVLT[U] {
  let hl = l.height()
  let hr = r.height()

  // Left subtree is taller by more than 2 level
  if hl > hr + 2 {
    match l {
      Empty => Empty // impossible
      Node(left=ll, elem=lv, right=lr, ..) =>
        if ll.height() >= lr.height() {
          create(ll, lv, create(lr, v, r))
        } else {
          match lr {
            Empty => Empty // impossible
            Node(left=lrl, elem=lrv, right=lrr, ..) => 
              create(create(ll, lv, lrl), lrv, create(lrr, v, r))
          }
        }
    }
  } else if hr > hl + 2 {
    // Right subtree is taller by more than 2 level
    match r {
      Empty => Empty // impossible
      Node(left=rl, elem=rv, right=rr, ..) =>
        if rr.height() >= rl.height() {
          create(create(l, v, rl), rv, rr)
        } else {
          match rl {
            Empty => Empty //impossible
            Node(left=rll, elem=rlv, right=rlr, ..) => 
              create(create(l, v, rll), rlv, create(rlr, rv, rr))
          }
        }
    }
  } else {
    Node(left=l, elem=v, right=r, height=if hl >= hr { hl + 1 } else { hr + 1})
  }
}

///|
/// `[U:Compare] add(self : AVLT[U], x : U)`
/// 
/// Add a value to a tree-like structure.
pub fn[U : Compare] add(self : AVLT[U], x : U) -> AVLT[U] {
  match self {
    Empty => Node(left=Empty, elem=x, right=Empty, height=1)
    Node(left=l, elem=v, right=r, ..) as t => {
      let c = x.compare(v)
      if c == 0 {
        t
      } else if c < 0 {
        bal(l.add(x), v, r)
      } else {
        bal(l, v, r.add(x))
      }
    }
  }
}

///|
/// `[U] min_elt(self : AVLT[U], default : U)`
/// 
/// Find the minimum element in a tree-like data structure.
pub fn[U] min_elt(self : AVLT[U], default : U) -> U {
  match self {
    Empty => default
    Node(left=Empty, elem=v, ..) => v
    Node(left=l, elem=v, ..) => l.min_elt(v)
  }
}

///|
/// `[U] remove_min_elt(l : AVLT[U], v : U,  r : AVLT[U])`
/// 
/// Remove the minimum element from a avl tree and rebalance the tree.
pub fn[U] remove_min_elt(l : AVLT[U], v : U,  r : AVLT[U]) -> AVLT[U] {
  match l {
    Empty => r
    Node(left=ll, elem=lv, right=lr, ..) => 
      bal(remove_min_elt(ll, lv, lr), v, r)
  }
}

///|
/// `[U] internal_merge(self : AVLT[U], other : AVLT[U])`
/// 
/// Merge two AVL trees of the same user-defined type `U` into a new AVL tree.
/// 👏将两个相同用户定义类型 `U` 的 AVL 树合并成一个新的 AVL 树。
pub fn[U] internal_merge(self : AVLT[U], other : AVLT[U]) -> AVLT[U] {
  match (self, other) {
    (Empty, t) => t
    (t, Empty) => t
    (_, Node(left=rl, elem=rv, right=rr, ..)) => 
      bal(self, other.min_elt(rv), remove_min_elt(rl, rv, rr))
  }
}

///|
/// `[U:Compare] remove(self : AVLT[U], x : U)`
/// 
/// Removes a value from the AVL tree while maintaining balance
/// 👏在保持平衡的同时从AVL树中移除一个值
pub fn [U : Compare] remove(self : AVLT[U], x : U) -> AVLT[U] {
  match self {
    Empty => Empty
    Node(left=l, elem=v, right=r, ..) => {
      let c = x.compare(v)
      if c == 0 {
        l.internal_merge(r)
      } else if c < 0 {
        bal(l.remove(x), v, r)
      } else {
        bal(l, v, r.remove(x))
      }
    } 
  }
}

///|
/// `[U:Show] to_string(self : AVLT[U]) -> String`
/// 
/// convert the AVL tree to string
pub impl[U : Show] Show for AVLT[U] with output(self : AVLT[U], logger : &Logger) -> Unit {
  match self {
    Empty => logger.write_string("()")
    Node(left=Empty, elem=v, right=Empty, ..) => logger.write_object(v)
    Node(left=l, elem=v, right=r, ..) => logger.write_string("(\{l}, \{v}, \{r})")
  }
}

///|
/// `[U : Compare] mem(self : AVLT[U], x : U)`
/// 
/// Check if a given element exists in an AVL tree.
/// 👍检查给定元素是否存在于AVL树中。
pub fn[U : Compare] mem(self : AVLT[U], x : U) -> Bool {
  match self {
    Empty => false
    Node(left=l, elem=v, right=r, ..) => {
      let c = x.compare(v)
      let tree = if c < 0 { l } else { r }
      c == 0 || tree.mem(x)
    } 
  }
}








