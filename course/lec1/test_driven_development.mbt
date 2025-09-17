// Question: You can exchange `num_exchange` empty bottles for a bottle of water from a shop.
// 问题：每`num_exchange`个空瓶子，可以从商店换来一瓶水
//
// You have `num_bottles` bottles of water at the beginning.  
// How many bottles of water can you drink at most?
// 你最初拥有`num_bottles`瓶水，最多能喝几瓶水？


//举一个例子
//如果 num_bottles = 9（起初拥有9瓶水），num_exchange = 3（每3个空瓶换1瓶水），则 num_drunk = 13（最多可喝13瓶水）

//我们推荐测试驱动开发
//We recommend the test driven development

//test
test "Expected behavior of num_water_bottles" {
  //断言
  assert_(num_water_bottles(9, 3) == 13)
  assert_(num_water_bottles(15, 4) == 19)
}

fn assert_(args0 : Bool) -> Unit{
  if args0 != true{
    //中止
    abort("Test failed")
  }
}

//development
fn num_water_bottles(num_bottles : Int , num_exchange : Int) -> Int{
//init：
// num_bottles = 9
// num_exchange = 3
// num_drunk = 0

// 1.(9,0)
// 9>= 3 true
// 9-3+1=7 = num_bottles
// 0+3 = 3 = num_drunk

// 2. (7,3)
// 7>= 3 true
// 7-3+1=5 = num_bottles
// 3+3=6 = num_drunk

// 3.(5,6)
// 5>= 3 true
// 5-3+1=3 = num_bottles
// 6+3=9 = num_drunk

// 4.(3,9)
// 3>= 3 true
// 3-3+1=1 = num_bottles
// 9+3=12 = num_drunk

// 5.(1,12)
// 1>=3 false
// 1+12=13 = num_drunk
// 在 MoonBit 中，函数是一等公民
  fn consume(num_bottles,num_drunk : Int){
    if num_bottles >= num_exchange {
      let num_bottles = num_bottles - num_exchange + 1
      let num_drunk = num_drunk + num_exchange
      consume(num_bottles,num_drunk)
    }else{
      num_bottles + num_drunk
    }
  }
  consume(num_bottles,0)
}