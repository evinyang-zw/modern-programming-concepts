// This example is an implemention of Hash Array Mapped Trie (HAMT) in MoonBit
// HAMT is an efficient, memory saving, functional hash map data structure.
//
// 这个例子是在MoonBit中实现哈希数组映射树（HAMT）的一个示例。HAMT是一种高效、节省内存的功能型哈希映射数据结构。 
// Some references:
// - <https://handwiki.org/wiki/Hash%20array%20mapped%20trie>
// - <https://lampwww.epfl.ch/papers/idealhashtrees.pdf>

///|
/// `ctpop(n : Int)`
/// 
/// Count the number of set bits (1s) in a 32-bit integer. 
/// 统计一个32位整数中设置位（1）的数量。
fn ctpop(n : Int) -> Int {
  // extract the lower bit of every 2-bit group
  // 提取每个2位组的低位
  let low_of_2bits = 0x55555555
  // count the number of "1"s in every 2-bit group
  // 统计每个2位组中 1 的数量
  // store the result in the same 2-bit group
  // 将结果存储在相同的2位组中
  let c2 = (n & low_of_2bits) + ((n >> 1) & low_of_2bits)
  // count the number of "1"s in every 4-bit group (i.e. two 2-bit groups),
  // store the result in the same 4-bit group
  // 统计每个4位组1的数量（即2个2位组）
  // 将结果存储在相同的4位组中
  let low_of_4bits = 0x33333333
  let c4 = (c2 & low_of_4bits) + ((c2 >> 2) & low_of_4bits)
  // similarly for every 8-bit group
  // 同样地，对于每个8位组
  let low_of_8bits = 0x0f0f0f0f
  let c8 = (c4 & low_of_8bits) + ((c4 >> 4) & low_of_8bits)
  // 16-bit group.
  // there will be only two groups left, without rist of overlapping,
  // so there's no need to clean the unsued higher bits
  // 16位组。
  // 只剩下两个组，没有重叠的风险，
  // 因此不需要清理未使用的高位
  let c16 = c8 + (c8 >> 8)
  // the final 32-bit group
  // [ctpop(x) <= 32], so only the last 6 bits are meaningful
  // 最终的32位组
  // [ctpop(x) <= 32]，所以只有最后6位有意义
  let low_6bits = 63 // 0x3f
  (c16 + (c16 >> 16)) & low_6bits
}

///|
/// a simple bit set to store a set of integers less than 32
/// 一个简单的位集，用于存储小于32的整数集
struct BitSet {
  rep: Int
}

///|
let empty_bitset : BitSet = { rep : 0 }

///|
/// `has(self: Bitset, idx: Int)`
/// 
/// Check if the given index is present in the bitset.
/// 检查给定的索引是否存在于位集中。
fn BitSet::has(self : BitSet, idx : Int) -> Bool {
  (self.rep & (1 << idx)) != 0
}

///|
/// `index_of(self: Bitset, idx: Int)`
/// 
/// Get the index of the bit in the bitset.
/// 获取位集中位的索引。❓
fn BitSet::index_of(self : BitSet, idx : Int) -> Int {
  let items_below_idx = self.rep & ((1 << idx) - 1)
  ctpop(items_below_idx)
}

///|
/// `add(self: Bitset, idx: Int)`
/// 
/// Add a new index to the bitset.
/// 向位集添加一个新索引。
fn BitSet::add(self : BitSet, idx : Int) -> BitSet {
  { rep: self.rep | (1 << idx) }
}

///|
///  `remove(self: Bitset, idx: Int)`
/// 
///  Remove an index from bitset.
/// 从位集中删除一个索引。
pub fn BitSet::remove(self : BitSet, idx : Int) -> BitSet {
  { rep: self.rep ^ (1 << idx) }
}
 
///|
/// A sparse array with at most 32 elements, where elements are not required to have contiguous index.
/// Empty elements don't waste any space, without losing constant-time access
/// 一个最多包含32个元素的稀疏数组，其中元素不需要具有连续的索引。空的元素不会浪费任何空间，而不会失去常数时间访问
struct Sparse_Array[X] {
  // record which elements are present
  // 记录哪些元素存在：在稀疏数组结构中，此短语用于描述如何追踪哪些索引位置有实际数据元素，以优化存储和访问效率。
  // sparse: 指的是数组中元素分布不连续，即元素之间没有连续的索引，这样的数组结构可以节省存储空间，同时保持常数时间访问效率。
  elem_info : BitSet
  data : Array[X]
}

///|
/// `make_sparse_array[X](idx: Int, value: X)`
/// 
/// Create a new sparse array with a single element.
/// 创建一个包含单个元素的稀疏数组。
fn[X] make_sparse_array(idx : Int, value : X) -> Sparse_Array[X] {
  { elem_info: empty_bitset.add(idx), data: [value] }
}

///|
/// `has(self:Sparse_Array[X], idx: Int)`
/// 
/// Check if an elemnt exists at the given index in the sparse array.
/// 检查稀疏数组中给定索引处是否存在元素。
pub fn[X] Sparse_Array::has(self : Sparse_Array[X], idx : Int) -> Bool {
  self.elem_info.has(idx)
}

///|
/// `op_get(self: Sparse_Array[X], idx: Int)`
/// 
/// Get an element at the given index in the sparse array.
/// 在稀疏数组中获取给定索引的元素。
pub fn[X] Sparse_Array::op_get(self : Sparse_Array[X], idx : Int) -> X? {
  if self.elem_info.has(idx) {
    Some(self.data[self.elem_info.index_of(idx)])
  } else {
    None
  }
}

///|
/// `add[X](self: Sparse_Array[X], idx: Int, value: X)`
/// 
/// Add a new element into the sparse array.
/// 向稀疏数组添加新元素。
pub fn[X] Sparse_Array::add(
  self : Sparse_Array[X],
  idx : Int,
  value : X,
) -> Sparse_Array[X] {
  let new_len = self.data.length() + 1
  let pos_of_new_item = self.elem_info.index_of(idx)
  let new_data = Array::make(new_len, value)
  let mut i = 0
  while i < pos_of_new_item {
    new_data[i] = self.data[i]
    i = i + 1
  }
  new_data[i] = value
  i = i + 1 //❓
  while i < new_len {
    new_data[i] = self.data[i - 1]
    i = i + 1
  }
  { elem_info: self.elem_info.add(idx), data: new_data }
}

///|
/// `replace[X](self: Sparse_Array[X], idx: Int, value: X)`
/// 
/// Replace an existing element in the sparse array.
/// 在稀疏数组中替换一个现有元素。
pub fn[X] replace(self : Sparse_Array[X], idx : Int, value : X) -> Sparse_Array[X] {
  let len = self.data.length()
  let pos_of_new_item = self.elem_info.index_of(idx)
  let new_data = Array::make(len, value)
  for i = 0; i < len; i = i + 1 {
    new_data[i] = if i == pos_of_new_item { value } else { self.data[i] }
  }
  { elem_info: self.elem_info, data: new_data }
}

///|
/// Hash-Array-Mapped-Trie (HAMT) is a persistent hash-table data structure.
/// HAMT是一种持久化哈希表数据结构
/// It is a trie over the hash of keys (i.e. strings of binary digits)
/// 它是一个基于键的哈希的字典树（即二进制数字的字符串）
/// 
/// Every level in a HAMT can have up to 32 branches (5 digits)
/// so HAMT has a tree height of at most 7,
/// and is more efficient compared to most other tree data structures.
/// HAMT的每一层最多可以有32个分支（5位），因此HAMT的树高最多为7，与大多数其他树形数据结构相比效率更高。❓
/// 
/// HAMT uses the bitmap-based sparse array above to avoid space waste
/// HAMT使用上述基于位图的稀疏数组来避免空间浪费
pub enum HAMT[K, V] {
  Empty
  Leaf(K, V) //optimize for the case of no collision 针对无冲突的情况进行优化
  Collision(Bucket[K, V]) // use a list of buckets to resolve collision 使用一个桶列表来处理冲突
  Branch(Sparse_Array[HAMT[K, V]])
}

///|
enum Bucket[K, V] {
  Just_One(K, V) //must be non-empty 必须非空
  More(K, V, Bucket[K, V])
} 

///|
/// The number of bits consumed at every [Branch] node
/// 每个[分支]节点的比特消耗数量
let segment_length : Int = 5

///|
/// `make[K, V]()`
/// 
/// Make an empty HAMT.
pub fn[K, V] make() -> HAMT[K, V] {
  Empty
}

///|
/// `add[K: Eq + Hash, V](self: HAMT[K, V], key: K, value: V)`
/// 
/// Add a key-value pair to the Hash Array Mapped Trie (HAMT).
/// 向哈希数组映射树（HAMT）添加一个键值对。
pub fn[K : Eq + Hash, V] HAMT::add(
  self : HAMT[K, V],
  key : K,
  value : V,
) -> HAMT[K, V] {
  self.add_with_hash(key, 0, key.hash(), value)
}

///|
/// `add_with_hash[K:Eq, V](self: HAMT[K, V], key: K, depth: Int, hash: Int, value: V)`
/// 
/// Add a key-value pair to the Hash Array Mapped Trie (HAMT).
/// # Arguments
/// * `self` - The HAMT to add the key-value pair to.
/// * `key` - The key to add.
/// * `depth` - The current depth within the trie.
/// * `hash` - The precomputed hash value of the key.
/// * `value` - The value to associate with the key.
fn[K : Eq, V] HAMT::add_with_hash(
  self : HAMT[K, V],
  key : K,
  depth : Int,
  hash : Int,
  value : V,
) -> HAMT[K, V] {
  // make sure leaf nodes always appear at the bottom of the tree
  // 确保叶子节点始终出现在树的底部
  fn make_leaf(depth : Int, key : K, hash : Int, value : V) {
    if depth >= 32 { //❓
      HAMT::Leaf(key, value)
    } else {
      let idx = hash & ((1 << segment_length) - 1)
      let child = make_leaf(
        depth + segment_length,
        key,
        hash >> segment_length,
        value,
      )
      HAMT::Branch(make_sparse_array(idx, child))
    }
  }

  match self {
    Empty => make_leaf(depth, key, hash, value)
    Leaf(key1, value1) =>
      if key == key1 {
        Leaf(key, value)
      } else {
        Collision(More(key, value, Just_One(key1, value1)))
      }
    Collision(bucket) => Collision(bucket.add(key, value))
    Branch(children) => {
      let idx = hash & ((1 << segment_length) - 1)
      match children[idx] {
        Some(child) => {
          let child = child.add_with_hash(
            key,
            depth + segment_length,
            hash >> segment_length,
            value,
          )
          Branch(children.replace(idx, child))
        }
        None => {
          let child = make_leaf(
            depth + segment_length,
            key,
            hash >> segment_length,
            value,
          )
          Branch(children.add(idx, child))
        }
      }
    }
  }
}

///|
/// `add[K: Eq, V](self: Bucket[K, V], key: K, value: V)`
/// 
/// Add a key-value pair to a Bucket.
fn[K : Eq, V] Bucket::add(
  self : Bucket[K, V],
  key : K,
  value : V,
) -> Bucket[K, V] {
  match self {
    Just_One(key1, _) =>
      if key == key1 {
        Just_One(key, value)
      } else {
        More(key, value, self)
      }
    More(key1, value1, rest) =>
      if key == key1 {
        More(key, value, rest)
      } else {
        More(key1, value1, rest.add(key, value))
      }
  }
}

///|
/// `count_collision[K, V](self: HAMT[K, V])`
/// 
/// Count the number of collision nodes in the Hash Array Mapped Trie (HAMT).
/// 计算哈希数组映射树（HAMT）中碰撞节点的数量。
pub fn[K, V] HAMT::count_collision(self : HAMT[K, V]) -> Int {
  match self {
    Empty | Leaf(_) => 0
    Collision(bucket) => bucket.size()
    Branch(children) => {
      let mut total_count = 0
      for i = 0; i < children.data.length(); i = i + 1 {
        total_count = total_count + children.data[i].count_collision()
      }
      total_count
    }
  }
}

///|
/// `size[K, V](self: Bucket[K, V])`
/// 
/// Calculate the size (number of elements) of a Bucket.
fn[K, V] Bucket::size(self : Bucket[K, V]) -> Int {
  match self {
    Just_One(_) => 1
    More(_, _, rest) => rest.size() + 1 
  }
}

///|
/// `find_with_hash[K: Eq, V](self: HAMT[K, V], key: K, hash: Int)`
/// 
/// Find a value associated with the given key in the Hash Array Mapped Trie (HAMT).
pub fn[K : Eq + Hash, V] HAMT::find(self : HAMT[K, V], key: K) -> V? {
  loop(self, key.hash()){
    (Empty, _) => None
    (Leaf(key1, value), _) => if key == key1 { Some(value) } else { None }
    (Collision(bucket), _) => bucket.find(key)
    (Branch(children), hash) => {
      // get the first segment (lower 5 bits) of the hash value
      let idx = hash & ((1 << segment_length) - 1)
      match children[idx] {
        Some(child) => 
          // when searching recursively, drop the segment just used
          // 在递归搜索时，丢弃刚刚使用的段
          continue (child, (hash >> segment_length))
        None => None
      }
    }
  }
}

///|
/// `find[K: Eq, V](self: Bucket[K, V], key: K)`
/// 
/// Find a value associated with the given key in a Bucket.
/// 在桶中查找与给定键关联的值。
fn[K : Eq, V] Bucket::find(self : Bucket[K, V], key : K) -> V? {
  match self {
    Just_One(key1, value) => if key == key1 { Some(value) } else { None }
    More(key1, value, rest) =>  
      if key == key1 {
        Some(value)
      } else {
        rest.find(key)
      }
  }
}

///|
/// `println[K: Show, V: Show](self: HAMT[K, V], indent: Int)`
/// 
/// Print the contents of the Hash Array Mapped Trie (HAMT) with indentation.
pub fn[K : Show, V : Show] HAMT::print_hamt(
  self : HAMT[K, V],
  indent : Int
) -> Unit {
  match self {
    Empty => println("Empty")
    Leaf(k, v) => println("\{k} => \{v}")
    Collision(bucket) => bucket.print_bucket()
    Branch(children) => 
      if children.data.length() == 0 {
        println("Empty")
      } else {
        println("Branch")
        for i = 0; i < 32; i = i + 1 {
          match children[i] {
            Some(child) => {
              for n = 0; n < indent; n = n + 1 {
                println(' ')
              }
              println("#\{i}")
              for n = 0; n < indent; n = n + 1 {
                println(' ')
              }
              println("- ")
              child.print_hamt(indent)
            }
            None => ()
          }
        }
      }
  }
}

///|
/// `println[K: Show, V: Show](self: Bucket[K, V])`
/// 
/// Print the contents of Bucket.
/// 打印Bucket的内容。
fn[K : Show, V : Show] print_bucket(self : Bucket[K, V]) -> Unit {
  match self {
    Just_One(k, v) => println("\{k} => \{v}")
    More(k, v, rest) => {
      println("\{k} => \{v};")
      rest.print_bucket()
    }
  }
}