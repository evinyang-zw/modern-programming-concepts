# MoonBit构建系统
## 使用 `moon new` 命令构建项目
### 项目/模块
    - 一个项目文件夹下可以有多个模块，建议使用`moon new`命令使用构建向导，创建自定义项目
    - 项目路径和模块名称无必然联系，可以指定模块名称
    - 如果一个项目文件夹下只有一个模块，此时模块名称可以理解为项目名称
### 模块目录结构
```
moonBit-project
├── LICENSE
├── README.md
├── moon.mod.json
└── src
    ├── lib
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    └── main
        ├── main.mbt
        └── moon.pkg.json
```