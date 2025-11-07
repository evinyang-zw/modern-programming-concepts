# MoonBit构建系统
- [官方文档](https://docs.moonbitlang.cn/toolchain/moon/index.html) 
---
- >读者：evinyang
- >时间：2025年10月16日11点12分
---
# moon的命令行

## `moon register`
- 在 mooncakes.io 注册一个账户
## `moon login`
- 登录到您的账户 = username
## `moon new`
- 项目/模块(个人理解)
    - 一个项目文件夹下可以有多个模块，建议使用`moon new`命令使用构建向导，创建自定义项目
    - 项目路径和模块名称无必然联系，可以指定模块名称
    - 如果一个项目文件夹下只有一个模块，此时模块名称可以理解为项目名称
- 创建一个新的 MoonBit 模块
    - 用法：moon new [选项] <路径>
    - 参数：`<PATH>` — 新项目的路径
    - 选项：
        - `--user<用户>` — 包的开发者名称。默认为已登录用户的用户名
        - `--name <名称>`— 包的名称。默认为路径的最后一部分
- 示例：
```sh
moon new ./practice
```
- 模块目录结构图

![模块目录结构](./pics/module_directory_structure.webp)

- 模块目录结构
```
my_project
├── Agents.md
├── cmd
│   └── main
│       ├── main.mbt
│       └── moon.pkg.json
├── LICENSE
├── moon.mod.json
├── moon.pkg.json
├── my_project_test.mbt
├── my_project.mbt
├── README.mbt.md
└── README.md -> README.mbt.md
```
## `moon build`

## `moon update`