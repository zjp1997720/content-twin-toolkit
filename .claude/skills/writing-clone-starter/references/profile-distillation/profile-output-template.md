# 人物 Profile 蒸馏｜输出模板

## 目的

这份文件负责规定：一个新人物 profile 最终必须输出成哪些 starter-compatible 资产。

它不是 persona 包装模板，而是 starter 可直接消费的作者资产模板。

## 输出目录形态

默认输出到：

`references/built-in-profiles/<author-id>/`

## 必需文件

### 1. `profile-card.md`

写清：

- 一句话定义
- 最适合场景
- 不适合硬拟态场景
- 当前构建依据
- 运行口径

### 2. `worldview.md`

写清：

- 该人物看世界的核心镜片
- 价值排序
- 重视什么 / 不重视什么

### 3. `recurring-moves.md`

写清：

- 稳定出现的开头动作
- 问题重定义方式
- 中段推进方式
- 结尾收束方式

### 4. `taboo-moves.md`

写清：

- 该人物通常不会怎么写
- 哪些常见动作一旦出现，就容易串味或掉成 generic strong article

### 5. `snippet-bank.md`

写清：

- 可复用的表达组合
- 但不是原句复读库
- 要强调“模板感 / 动作感”，不是抄袭感

### 6. `topic-bandwidth.md`

写清：

- 核心带宽
- 邻近带宽
- 弱带宽
- 降级触发器与默认呈现方式

### 7. `hard-signals.md`

只收更难被 baseline 伪造的强信号。

### 8. `contrastive-pairs.md`

写清：

- 普通强稿会怎么写
- 该人物更像会怎么写
- 真差异落在哪一层

### 9. `false-positive-signals.md`

写清：

- 看起来像，其实不像的假信号

### 10. `acceptance-checklist.md`

写清：

- 这个 profile 通过的正文级标准

### 11. `raw-corpus/README.md`

写清：

- 构建集
- held-out 集
- 哪些源是一级主证据

### 12. `source-ledger.md`

这是正式资产的一部分，不是附录。

它负责把正式特征和证据来源、过门理由绑定起来。

## 可选补充文件

- `asset-audit.md`
- `held-out-set.md`

## 模板原则

- 不输出 persona roleplay 说明
- 不输出“直接以本人身份说话”的包装规则
- 输出必须服务 starter 的高拟态生成与验收
- 输出模板必须和后续素材落库模板可映射，不能变成两套彼此脱节的结构

## 最低验收

一个新人物 profile 只有在下面条件同时满足时，才算结构合格：

1. 必需文件齐
2. 正式特征都能在 `source-ledger.md` 找到对应条目
3. 与素材库落库规则能互相映射
4. 能被 starter 的高拟态路径直接消费
