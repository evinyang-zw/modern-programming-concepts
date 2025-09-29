---
#隐藏版权声明 & 面向Markdown编程的设置(可以自动生成一定格式的pdf文件，可以使用高阶数学符号和表达式)
marp: true
math: mathjax
paginate: true
backgroundImage: url('路径')
headingDivider: 1
---
# Markdown语法
>本文作者：Zhiwei Yang  
>时间：20250929
---
## [Markdwon官方教程](https://markdown.com.cn/basic-syntax/)

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

>“我希望他准确无误地知道他是多么特殊的生命，要不，他在成长的过程中将会忽视这一点。
>我希望他保持清醒，并看到各种奇妙的可能。
>我希望他知道，一旦有机会，排除万难给世界一点触动是值得的。
>我还希望他知道为什么他是一个人，而不是一张椅子。”
> —— 赫布·加德纳（HerbGardner）《一千个小丑》
    
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
---
# 在Markdown中插入视频
>在Markdown中插入视频是一个常见的需求，尤其是当你想在博客或文档中展示视频内容时。Markdown本身不直接支持视频标签，但由于它兼容HTML，我们可以利用HTML的`<video>`和`<iframe>`标签来实现视频的插入。

## 使用`<video>`标签插入视频
>要在Markdown中插入视频，可以使用HTML的`<video>`标签。这个标签允许你指定视频文件的源地址，并提供了一些控制视频播放的属性，如controls、autoplay、loop等。以下是一个插入视频的例子：

<video width="320" height="240" controls >
   <source src="./static/video/video.mp4" type="video/mp4">
   用.mbt.md写技术博客
   </source>
</video>

> 在这个例子中，width和height属性用于设置视频的尺寸，controls属性确保视频播放器有控制按钮。`<source>`标签内的src属性指定了视频文件的路径，type属性描述了视频的格式。如果你有多个视频格式，可以添加多个`<source>`标签，浏览器会选择第一个它能识别的格式播放。

## 使用`<iframe>`标签嵌入视频
> 另一种方法是使用`<iframe>`标签嵌入视频。这对于嵌入YouTube、Vimeo或其他视频托管服务的视频特别有用。以下是使用`<iframe>`标签插入视频的例子：

<iframe src="//player.bilibili.com/player.html?isOutside=true&aid=647113140&bvid=BV1de4y147We&cid=875578086&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>

>在这个例子中，src属性包含了视频的URL，其他属性如frameborder和allowfullscreen提供了额外的控制选项。

## 注意事项
- 确保视频文件的格式与浏览器兼容。常见的视频格式有MP4、WebM和OGG
- 如果你使用的是静态网站生成器，如Hugo，你需要将视频文件放在项目的static目录下，并在Markdown文件中使用相对路径引用它。
    >`Hugo`: Hugo是由Go编写的快速现代静态网站生成器，旨在让网站创建变得有趣
- 如果你想在没有服务器的情况下获取视频的在线链接，可以利用视频托管平台
---