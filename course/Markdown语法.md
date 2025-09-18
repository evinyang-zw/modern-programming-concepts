---
#隐藏版权声明 & 面向Markdown编程的设置(可以自动生成一定格式的pdf文件，可以使用高阶数学符号和表达式)
marp: true
math: mathjax
paginate: true
backgroundImage: url('路径')
headingDivider: 1
---
# Markdown语法

# 一级标题

## 二级标题

### 三级标题

#### 四级标题

# 一级标题
- 1级小标题
    - 2级小标题：数学表达式：`(1+ 5) * 7 / 2`
    - 2级小标题：英文： `LParen Value(1)`
    - 2级小标题：*文字倾斜*，**文字加粗**
        - 3级小标题
* 1级小标题
    - 2级小标题
    
![文件名称/宽高](相对路径)

[链接名称](链接地址)

课程论坛：[taolun.moonbitlang.cn](https://taolun.moonbitlang.cn)

方括号中直接放url： <https://mooncakes.io/docs/moonbitlang/core/>

```
什么也不写
```

```js
//JavaScript语言
```

```abnf
ABNF-扩展巴斯克范式
ABNF 是一种用于定义互联网规范的语法，它基于 BNF （Backus-Naur Form，巴克斯-瑙尔范式），被称作扩充巴克斯-瑙尔范式
```

```moonbit
//MoonBit语言
enum Value { I32(Int) } // 只考虑32位有符号整数
```

```java
//Java 语言
```

```python
Python语言
```
# 表格1
|类型|值|运算|表达式|
|-----|------|----------|-----------|
|`Int`|`-1` `0` `1` `2`|`+` `-` `*` `/`|`5` `(3 + y * x)`|
|`Double`|`0.12` `3.1415`|`+` `-` `*` `/`|`3.0 * (4.0 * a)`|
|`String`|`"hello"` `"Moonbit"`|`+`|`"Hello, " + "MoonBit"`|
|`Bool`|`true` `false`|`&&` `\|\|` `not()`|`not(b1) \|\| b2`|

# 表格2
$$
\begin{array} {|c|c|c|c|}
 \text{课程} & \text{主题} & \text{课程} & \text{主题} \\
 \hline
 1 & \text{课程介绍与程序设计} & 10 & \text{接口：集合与表} \\
 2 & \text{面向值编程} & 11 & \text{Optional / 结构体 / Unit, Sequencing, 命令}\\
 3 & \text{函数, 列表与递归} & 12 & \text{可变状态, Aliasing与可变数据结构} \\
 4 & \text{列表, 元组, 嵌套模式} & 13 & \text{抽象堆栈结构机器} \\
 5 & \text{数据类型与树} & 14 & \text{可变队列} \\
 6 & \text{树与二分查找} & 15 & \text{迭代与尾递归} \\
 7 & \text{二叉搜索树的插入与删除} & 16 & \text{闭包与对象} \\
 8 & \text{泛型与高阶函数} & 17 & \text{案例：句法分析器与程序解释器} \\
 9 & \text{高阶函数：Transform与Fold} & 18 & \text{案例：自动积分与小游戏} \\
\end{array}
$$