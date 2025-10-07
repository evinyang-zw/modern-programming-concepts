// This example implements a simple functional queue data structure in MoonBit

///|
pub struct Queue[T] {
  front : @list.List[T]
  back : @list.List[T]
}

///| Create a queue from a list.
pub fn[T] from_list(front : @list.List[T]) -> Queue[T] {
  { front, back : @list.empty() }
}

///| Check if given queue is empty.
pub fn[T] is_empty(q : Queue[T]) -> Bool {
  match q {
    { front: Empty, back: Empty } => true
    _ => false
  }
}

///| 
/// Normalize a queue by reversing its back portion and updating the front and back pointers accordingly.
/// 通过反转队列的后部并相应地更新前后指针来规范化队列。
pub fn[T] Queue::norm(q : Queue[T]) -> Queue[T] {
  match q {
    { front: Empty, back: b } => { front: b.rev(), back: @list.empty() }
    q => q
  }
}

///| 
/// Enqueue an element into a queue using pattern matching
///
/// In the example above, `enqueue` is called to enqueue the element `42` into the queue `q`,
/// resulting in a new queue `newQ` with the element enqueued at the back.
pub fn[T] Queue::enqueue(q : Queue[T], x : T) -> Queue[T] {
  match q {
    { front: f, back: b} => { front: f, back: b.add(x) }.norm()
  }
}

///|
/// Peek at the front element.
pub fn[T] Queue::peek(q : Queue[T]) -> T? {
  match q {
    { front: Empty, back: _ } => None
    { front: More(x, ..), back: _ } => Some(x)
  }
}

///| 
/// Dequeues an element from the front of the given queue and returns the resulting queue.
pub fn[T] Queue::dequeue(q: Queue[T]) -> Queue[T]? {
  match q {
    { front: Empty, back: _ } => None
    { front: More(_, tail=f), back: b } => Some({ front: f, back: b }.norm())
  }
}

///|
/// Convert an array to a linked list using recursion.
pub fn[T] from_array(arr : Array[T]) -> Queue[T] {
  (loop(arr.length(), @list.empty()){
    (0, acc) => acc
    (i, acc) => continue (i - 1, acc.add(arr[i - 1]))
  }) |> from_list
}