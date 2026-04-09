# AGENT INSTALL PROMPT

把下面这段 prompt 直接复制给你的 Claude Code 或兼容 Agent。

```text
请帮我把这个仓库安装到我当前工作区：
https://github.com/zjp1997720/writing-clone-starter

安装目标：

- 把 `.claude/skills/writing-clone-starter/` 安装到我当前工作区
- 把 `02_素材库/writing-clone-starter-material-library/` 安装到我当前工作区
- 保持这两块的相对路径原样，不要自作主张改目录名

执行要求：

1. 先把仓库 clone 到临时目录，不要直接污染我当前工作区
2. 检查我当前工作区里是否已有：
   - `.claude/skills/`
   - `02_素材库/`
   如果没有，请创建
3. 只复制下面两块内容：
   - `.claude/skills/writing-clone-starter/`
   - `02_素材库/writing-clone-starter-material-library/`
4. 如果发现同名目录已经存在：
   - 先告诉我冲突点
   - 默认不要覆盖未知文件
   - 优先保留我现有工作区中不属于这个仓库的内容
5. 安装完成后，请做最小验证：
   - `.claude/skills/writing-clone-starter/SKILL.md` 是否存在
   - `.claude/skills/writing-clone-starter/README.md` 是否存在
   - `02_素材库/writing-clone-starter-material-library/README.md` 是否存在
6. 验证完成后，请告诉我：
   - 实际安装到了哪些路径
   - 是否发现冲突
   - 如果我现在要开始用，应该先发哪一句话

如果你需要我确认覆盖策略，再问我，不要擅自覆盖已有目录。
```

## 这个文件是干什么的

很多用户不会手动安装，而是会把仓库链接直接丢给 Agent。

这个文件就是为那个场景准备的。

如果你的 Agent 能读仓库文件，你也可以直接让它读取本文件，然后按里面的要求执行。
