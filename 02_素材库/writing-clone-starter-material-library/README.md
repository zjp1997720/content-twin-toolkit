# writing-clone-starter material library

这是 `writing-clone-starter` 的统一素材库根目录。

目标很简单：

- skill 本体继续放在 `.claude/skills/writing-clone-starter/`
- skill 之外的一切外部素材、证据、clippings、验证材料，都统一归到这里

## Start Here

如果你第一次接触这个仓库，按下面顺序理解最快：

1. **先看 `canonical/`**：这是 starter 运行时最常引用的标准素材层
2. **再看 `evidence/`**：这是 canonical 背后的上游证据、调研稿、原始 clippings
3. **需要验证时看 `validation/`**：这里放 held-out、negative、probe-evidence
4. **最后看 `provenance/`**：这里只是历史映射账本，用来解释旧路径是怎么迁进来的，不是运行时依赖

## 结构

- `authors/<author-id>/canonical/`：运行时最常引用的标准素材
- `authors/<author-id>/evidence/`：上游证据、调研稿、原始 clippings
- `authors/<author-id>/validation/`：held-out、negative、probe-evidence
- `authors/<author-id>/provenance/`：旧路径到新路径的迁移账本

## 关于 provenance

`provenance/source-index.md` 里仍然会出现旧的分散路径，这是刻意保留的迁移追溯信息。

它说明的是：

- 某份材料原来从哪里来
- 现在被归到了统一素材库的哪个位置

它**不说明** starter 运行时还依赖那些旧路径。

## 约束

`writing-clone-starter` 以后只应引用：

1. skill 自己内部的 references
2. `02_素材库/writing-clone-starter-material-library/`

不再直接跨到：

- `00_收件箱/`
- `01_项目/`
- 其他分散的全局素材路径
