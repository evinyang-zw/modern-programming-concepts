# evinyang-zw/practice 训练场
态度：个人兴趣，坚持每天编码

目标：暴露问题，解决问题

---

# 019_hindley_milner
- 类型检查器原理支撑？

- 解决调试代码的问题，在course中该问题也存在
    - [什么是Node.js？](#nodejs)
    - [npm是什么？](#什么是-npm)
    - MoonBit Debugger？
    - 测试？基准测试？测试驱动开发流程？
    - 解决course中各lec遗留问题

- 遇到问题怎么办？
    >MoonBit官方文档 + MoonBit论坛 + 搜索引擎 + 博客 + 每周动态 + 黑板报

---

# 测试驱动开发流程
《代码简洁之道·程序员的职业素养》-> 测试驱动开发流程

。。。

---

# 形成闭环：回顾现代思想课程

# lec1：基础设计流程
**设计**是将非正式的规范转化为可运行代码的过程

推荐用测试驱动开发流程：
1. 理解问题
    >涉及哪些概念，概念间存在怎样的联系？
2. 定义接口
    >程序如何与环境互动？
3. 写测试案例
    >对于典型的输入，程序应如何表现？对于非正常输入呢？
4. 实现规定的行为
    >经常需要将问题拆解为更简单的子问题并对各子问题重复以上流程
## 一个设计例题
> 超市正在促销，你可以用 `num_exchange` 个空水瓶从超市兑换一瓶水。最开始，你一共购入了 `num_bottles` 瓶水。
> 如果喝掉了水瓶中的水，那么水瓶就会变成空的。
> 给你两个整数 `num_bottles` 和 `num_exchange` ，返回你**最多**可以喝到多少瓶水。
> ——[力扣1518](https://leetcode.cn/problems/water-bottles/)

。。。。

---

# lec13 案例：基于梯度下降的神经网络
- 解决遗留问题(利用debugger尝试解决一下)

---

# MoonBit Debugger？(模块已建立，正在dev)
- http Server -> 浏览器F12 -> 调试断点(Get)

- Vscode -> 设置断点 -> 直接调试

---

# Node.js
What is Node.js? 

**Node.js is a JavaScript runtime environment** built on Chrome's V8 JavaScript engine. 

It allows developers to execute JavaScript code outside of a web browser, making it possible to use JavaScript for server-side scripting.

This enables the creation of dynamic web page content before the page is sent to the user's web browser.

Key Features of Node.js

1. **Event-Driven and Non-Blocking I/O Model**: Node.js uses an event-driven, non-blocking I/O model, which makes it lightweight and efficient.This model is particularly suitable for applications that require real-time interaction or handle a large number of concurrent connections.
2. **Single-Threaded**: Node.js operates on a single-threaded event loop, which can handle multiple connections simultaneously. This design avoids the overhead of creating multiple threads and makes it easier to manage resources.
3. **High Performance**: The V8 engine, developed by Google, compiles JavaScript directly to native machine code, resulting in high performance and fast execution.

Applications of Node.js 

1. **Web Development**: Node.js is commonly used for building web applications. Frameworks like Express.js simplify the process of creating web servers and handling HTTP requests
2. **Real-Time Applications**: Node.js is ideal for real-time applications such as chat applications, online gaming, and collaborative tools. Libraries like Socket.io enable real-time, bidirectional communication between web clients and servers
3. **API Services**: Node.js can be used to create RESTful APIs, which can serve as the backend for web and mobile applications
4. **Web Scraping**: Tools like Cheerio and Request allow developers to scrape web pages and extract data
5. **Static Site Generation**: Frameworks like Hexo enable the creation of static websites and blogs
- `Hexo`: static websites and blogs
    - [Used1](../blog/20250604.mbt.md)

**Example: Creating a Simple Web Server**

- Here is an example of how to create a simple web server using Node.js:

    ```js
    // Load the http module to create an HTTP server
    const http = require('http');
    // Configure the HTTP server to respond with "Hello World" to all requests
    const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World\n');
    });
    // Listen on port 3000 and IP address 127.0.0.1
    server.listen(3000, '127.0.0.1', () => {
    console.log('Server running at http://127.0.0.1:3000/');
    });
    ```

- To run this code, save it in a file named server.js and execute it using the following command:

    ```js
    node server.js
    ```

- This will start a web server that listens on port 3000 and responds with "Hello World" to all incoming requests.

**Conclusion**:

Node.js has revolutionized the way JavaScript is used, extending its capabilities beyond the browser and enabling full-stack development with a single language. Its event-driven, non-blocking architecture makes it suitable for building scalable and high-performance applications

---

# 什么是 npm？
`npm`（Node Package Manager）是 JavaScript 运行时环境 Node.js 的默认包管理器。

允许开发者轻松地下载、安装、共享和管理项目的依赖库和工具。

## 主要功能

### 包管理
npm 可以帮助你安装并管理项目所需的各种第三方库（包）。

例如，可以通过简单的命令来安装、更新或删除依赖。
```shell
# 安装 express 包
$ npm install express
```
### 版本管理
npm 支持版本控制，允许你锁定某个特定版本的依赖，或根据需求选择最新的版本。
```sh
# 安装特定版本的包
$ npm install express@4.17.1
```
### 包发布
npm 允许开发者将自己的库发布到 npm 仓库中，其他开发者可以通过 npm 下载并使用这些库
```sh
# 发布包到 npm 仓库
$ npm publish
```
### 命令行工具
npm 提供了强大的命令行工具，可以用于安装包、运行脚本、初始化项目等多种操作
```sh
# 初始化一个新的 Node.js 项目
$ npm init
```
### package.json 文件
每个 JavaScript 项目都可以被当作 npm 软件包，并且通过 package.json 来描述项目和软件包信息
```json
{
 "name": "my-project",
 "version": "1.0.0",
 "description": "A sample project",
 "main": "index.js",
 "scripts": {
   "test": "echo \"Error: no test specified\" && exit 1"
 },
 "author": "Your Name",
 "license": "ISC"
}
```
### 使用 npm 的好处
1.**简化依赖管理**：通过 npm，可以轻松管理项目的依赖库，避免手动下载和配置

2.**版本控制**：npm 支持语义版本控制，确保项目依赖的库版本一致

3.**社区支持**：npm 拥有庞大的社区，提供了丰富的开源库和工具

总之，npm 是一个强大的工具，极大地简化了 JavaScript 和 Node.js 项目的开发和管理过程