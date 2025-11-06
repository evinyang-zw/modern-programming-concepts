# Zhiwei Yang Git教程
- >作者：evinyang
- >时间：20250930
- >[适合初学者的简单Git教程-nulab](https://nulab.com/zh-cn/learn/software-development/git-tutorial/)
---
## [常用的Git命令](./Git常用命令大全.md)

## 使用过的Git环境

### 1. VSCode

### 2. Idea For Project Develpment

### 3. GitBash

---
## 个人使用后的总结
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

# GitHub
- [GitHub入门文档](https://docs.github.com/zh/get-started)
---
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
---
## 简单介绍GitHub中的fork用法
>`Fork`是GitHub 提供的一种功能，用于从他人的代码仓库中创建一个属于自己的副本。通过 `Fork`，用户可以在自己的账户下拥有一份独立的项目拷贝，而无需直接修改原始仓库。这种方式非常**适合协作开发**、**代码优化**或**个人学习**
---
### Fork 的主要用途
- 1.独立开发环境：Fork 后的仓库完全独立于原始仓库，用户可以自由修改代码，而不会影响原始项目

- 2.贡献代码：当用户对 Fork 的项目进行修改后，可以通过 Pull Request 提交更改请求，供原始仓库的维护者审核并决定是否合并。

- 3.同步更新：如果原始仓库有更新，用户可以通过`Pull Request`或 `Merge` 将这些更改同步到自己的 Fork 仓库中，保持代码一致性

- 4.个性化定制：用户可以基于 Fork 的项目进行个性化修改，创建属于自己的版本

### 使用 Fork 的场景
- 修复 Bug：发现开源项目中的问题后，可以 Fork 项目，修复问题并提交 Pull Request

- 功能扩展：为开源项目添加新功能，同时保留对原始项目的贡献

- 学习和实验：Fork 项目后，可以自由尝试修改代码，学习项目结构和实现细节

`tips`：写commit信息时，可以用场景描述

### Fork 的操作步骤
- 1.点击 Fork 按钮：在目标仓库页面右上角点击 Fork，即可将项目复制到自己的 GitHub 账户下

- 2.克隆到本地：使用 git clone 命令将 Fork 的仓库下载到本地

- 3.修改代码：在本地进行代码修改和提交

- 4.提交 Pull Request：完成修改后，通过 GitHub 提交 Pull Request，建议原始仓库合并更改
---
## 注意事项
- Fork 的仓库不会自动同步原始仓库的更新，需**手动拉取更新**

- 如果只是想收藏项目，可以使用 `Star`，而非 Fork

- Fork 的项目默认公开，需注意隐私和版权问题

>通过 Fork，开发者可以高效参与开源项目，同时保留对代码的完全控制权
---


