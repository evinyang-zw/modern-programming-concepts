# Zhiwei Yang Git教程
## 常用的Git命令
```
待补充
```
---
## 使用版本控制工具

### VSCode

### Idea For Project Develpment

### GitBash

---
## 个人总结
- 本地git项目三个主要区域
    - 本地代码库（由git管理）
    - 暂存区（Stage Changes）
    - 提交区（Commited）

- 远程存储库（GitHub、Gitee、码云、、、）

- 创建存储库
    - 使用git初始化命令创建存储库，特点（不建议使用）：
        - 可以将 Git 引入到现有的、未版本控制的项目中，以便跟踪更改
        - .....
    - 直接克隆远程仓库，特点与注意：
        - 省时省力，不容易出错
        - 远程规划好分支，一般基于 orgin main 分支创建新分支来开发
        - 本地克隆后，会自动建立分支来跟踪远程

- git pull拉取代码
    - pull = fetch + merge
    - pull = Download

- git fetch 获取远程的修改但又不将它们合并到当前的本地分支中

- git push推送代码!
    - push = Upload!

- git checkout切换分支

- git stash 暂存分支(深入理解)

- 推送代码三步走
    - 先pull/fetch，有冲突解决冲突，此时本地和远端已为最新版本
    - 检查changes内容，注意新增文件，如不必要上传，请修改`.gitignore`文件
    - Stage all changes, 写commit信息，Commit & Push

---
## 分支的工作流程(补课)

## 代码审查（补课）
- 开发人员

- 审查者
---
## fork是什么？

---
# 几个不错的Git教程
- [适合初学者的简单 Git 教程-nulab](https://nulab.com/zh-cn/learn/software-development/git-tutorial/)

---
# GitHub
- [GitHub入门文档](https://docs.github.com/zh/get-started)

## Issues问题
- 遇到bug时，开启一个问题的模板
```
Describe the bug
简单描述遇到的问题

Reproduction
复现：可以粘贴出现bug的代码

Logs
日志：报错的信息

System Info
系统信息：运行项目所需环境信息

Who can help?
求助
```

