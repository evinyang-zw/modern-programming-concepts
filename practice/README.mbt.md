# evinyang-zw/practice 训练场
    - 态度：个人兴趣，坚持每天写作
    - 目标：暴露问题，解决问题
# 019_hindley_milner
- 类型检查器原理支撑？
- 解决调试代码的问题，在course中该问题也存在
    - [什么是Node.js？](##Node.js-1)
    - MoonBit Debugger？
    - 测试？基准测试？
- 
---
# 测试

# 形成闭环：回顾现代思想课程
## lec1：基础设计流程
**设计**是将非正式的规范转化为可运行代码的过程

# MoonBit Debugger？
- http Server -> 浏览器F12 -> 调试断点
- Vscode -> 设置断点 -> 直接调试

# Node.js
- What is Node.js? 
    - **Node.js is a JavaScript runtime environment** built on Chrome's V8 JavaScript engine. 
    - It allows developers to execute JavaScript code outside of a web browser, making it possible to use JavaScript for server-side scripting.
    - This enables the creation of dynamic web page content before the page is sent to the user's web browser.
- Key Features of Node.js
    1. **Event-Driven and Non-Blocking I/O Model**: Node.js uses an event-driven, non-blocking I/O model, which makes it lightweight and efficient.This model is particularly suitable for applications that require real-time interaction or handle a large number of concurrent connections.
    2. **Single-Threaded**: Node.js operates on a single-threaded event loop, which can handle multiple connections simultaneously. This design avoids the overhead of creating multiple threads and makes it easier to manage resources.
    3. **High Performance**: The V8 engine, developed by Google, compiles JavaScript directly to native machine code, resulting in high performance and fast execution.
- Applications of Node.js 
    1. **Web Development**: Node.js is commonly used for building web applications. Frameworks like Express.js simplify the process of creating web servers and handling HTTP requests
    2. **Real-Time Applications**: Node.js is ideal for real-time applications such as chat applications, online gaming, and collaborative tools. Libraries like Socket.io enable real-time, bidirectional communication between web clients and servers
    3. **API Services**: Node.js can be used to create RESTful APIs, which can serve as the backend for web and mobile applications
    4. **Web Scraping**: Tools like Cheerio and Request allow developers to scrape web pages and extract data
    5. **Static Site Generation**: Frameworks like Hexo enable the creation of static websites and blogs
        - `Hexo`: static websites and blogs
            - [Used1](../blog/20250604.mbt.md)
- **Example: Creating a Simple Web Server**
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
    - This will start a web server that listens on port 3000 and responds with "Hello World" to all incoming requests
- **Conclusion**:
Node.js has revolutionized the way JavaScript is used, extending its capabilities beyond the browser and enabling full-stack development with a single language. Its event-driven, non-blocking architecture makes it suitable for building scalable and high-performance applications