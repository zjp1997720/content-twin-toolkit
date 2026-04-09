---
name: content-goldmine-gemini
description: 把收藏文章、Clippings、外文长文拆成可复用的中文素材碎片，并按既有素材库模板稳定落库。用户一旦提到「挖金矿」「拆素材」「沉淀到素材库」「把这篇文章拆成标题/金句/结构」「批量处理 Clippings」「把英文文章转成中文素材资产」，就优先使用这个 skill，而不是只做普通总结。
---

# 内容挖金矿（Gemini CLI 版）

把收藏下来的文章，尤其是英文文章，拆成长期可复用的中文素材资产，并按素材库既有模板稳定落库。

---

## 触发方式

用户说这些话时触发：

- 把这篇收藏文章拆成素材碎片
- 分析这批 clipping，沉淀到素材库
- 按 content-goldmine 处理这些文章
- 帮我把这几个收藏拆成标题/金句/结构
- 把这篇英文文章拆成中文素材库资产
- 批量处理 `Clippings` 目录下最近收藏的文章
- 用挖金矿处理这篇文章

---

## 核心能力

1. **4D 底层拆解**：哲学层、心理层、传播层、社会层
2. **结构分析**：开头、中间、结尾的叙事方式
3. **心理模式识别**：悖论/转变弧/痛点共鸣等
4. **碎片素材提取**：
   - 标题（pass/fail 筛选）
   - 开头（pass/fail 筛选）
   - 金句（pass/fail 筛选）
   - 结构公式（pass/fail 筛选）
5. **中文输出**：所有最终入库素材必须是中文，适合后续创作直接复用

---

## 输入模式

### 模式 A：单篇文件

```
把这篇 clipping 拆进素材库：00_收件箱/Clippings/Dan Koe/xxx.md
```

### 模式 B：批量目录

```
把 00_收件箱/Clippings/Dan Koe/ 下面最近 20 篇都拆了
```

### 模式 C：指定文件列表

```
只处理这 3 篇：A.md、B.md、C.md
```

---

## 输出目录

严格继承原 command 的路径规则：

- `02_素材库/灵感素材/标题/` - 通过筛选的标题
- `02_素材库/灵感素材/开头/` - 通过筛选的开头
- `02_素材库/灵感素材/金句/` - 通过筛选的金句
- `02_素材库/灵感素材/结构/` - 通过筛选的结构公式
- `02_素材库/高表现内容/长文/` - 完整解构（>800字）
- `02_素材库/高表现内容/短图文/` - 完整解构（≤800字）

---

## 技术架构

### 分析引擎

- **默认模型**：`gemini-3-flash-preview`
- **调用方式**：Gemini CLI one-shot
- **输出格式**：结构化 JSON

### 本地脚本

- **统一入口**：`scripts/run_content_goldmine.sh`
- **bootstrap**：`scripts/bootstrap.sh`
- **核心脚本**：`scripts/process_goldmine.py`
- **职责**：
  1. 读取文章 Markdown
  2. 调用 Gemini CLI 输出结构化 JSON
  3. 只保留 pass 的碎片
  4. 按素材库既有模板稳定落盘
  5. 对英文内容保留原文，并额外补 `## 中文转写`

### 首次使用说明

这个版本已经适配到 Claude Code。

如果你是第一次拿到这个 skill：

1. 不要直接运行 `process_goldmine.py`
2. 统一运行 `scripts/run_content_goldmine.sh`
3. 它会先检查 Python 3 和 Gemini CLI
4. 如果 Gemini CLI 没装，会优先尝试自动安装
5. 如果 Gemini CLI 还没登录，它会明确引导你先运行 `gemini` 完成登录授权

更完整的说明见：

- `references/config/first-time-setup.md`
- `README-学员分发包.md`

### 设计原则

- **Gemini 负责提炼，不负责最终模板落盘**
- **脚本负责路径、命名、frontmatter、标题层级的一致性**
- 这样做的原因很现实：长期批量跑的时候，素材库不能每天换一种格式

---

## 碎片质量标准（洁癖法）

只存「可复用资产」，不存噪音。

### 标题（必须同时满足）

1. 一眼能复述观点或承诺（不是「泛主题」）
2. 具备至少 1 个抓手：反直觉/对比撕裂/时间或数字锚定/身份点名/强问题
3. 不要「软词堆砌」（如：提高/赋能/分享/思考/浅谈/如何…）

### 开头（必须同时满足）

1. 1-3 段短文本（总长度尽量 <= 120 字）
2. 前三句必须完成至少 1 件事：冲突/悬念/数据/场景/反问/反常识
3. 禁止「论文式铺垫」

### 金句（必须同时满足）

1. 单句可独立传播（脱离上下文也成立）
2. 尽量短（中文建议 <= 40 字）
3. 必须有判断/优先级/对比/因果之一

### 结构公式（必须同时满足）

1. 是「可套用的模板」，含占位符或清晰的步骤关系
2. 不得是「只对这一篇成立」的长篇复盘
3. 读完能立刻用在另一个主题上

---

## 执行流程（单篇）

1. 读取文章 Markdown
2. 提取标题、来源、正文
3. 调用 Gemini CLI（模型：`gemini-3-flash-preview`）
4. 要求 Gemini 按 4D 框架输出 JSON
5. 脚本校验 JSON
6. 只保留 pass 的标题 / 开头 / 金句 / 结构公式
7. 按素材库模板写入对应目录
8. 返回写入清单

## 当前落库模板

统一贴近你现有素材库文件：

```md
---
source: ...
url: ...
collected: ...
from_article: ...
---

## 内容

[原文片段]

## 中文转写

[中文可复用版]

## 为什么好

- ...

## 4D标签

- 哲学层：...
- 心理层：...
- 传播层：...
- 社会层：...

## 可变体方向

- ...
```

---

## 中文输出硬规则

即使原文是英文，最终入库素材也必须是中文：

1. **所有最终落库内容用中文**
2. 英文原文只作为参考字段，可选保留，不进入默认素材正文
3. 金句、标题、结构公式都要做 **中文重写版**，不是逐字直译
4. 中文表达优先追求：
   - 可复用
   - 可传播
   - 像中文内容创作素材
   - 不保留明显英文腔

---

## 示例用法

### 第一次先跑帮助（会顺手做 bootstrap）

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" --help
```

### 单篇文章

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --input "00_收件箱/Clippings/Dan Koe/2025-11-20 How to articulate yourself intelligently.md"
```

### 批量目录（最近 10 篇）

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --dir "00_收件箱/Clippings/Dan Koe" \
  --count 10
```

### 指定文件列表

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --url-file "00_收件箱/articles.txt"
```

### 保存完整解构稿

```bash
CONTENT_GOLDMINE_ROOT="<你的 content-goldmine-gemini 目录>"
bash "$CONTENT_GOLDMINE_ROOT/scripts/run_content_goldmine.sh" \
  --input "00_收件箱/Clippings/Dan Koe/example.md" \
  --save-full-analysis
```

---

## 成功标准

1. 能处理单篇 Markdown
2. 能按既定目录正确落盘
3. 最终输出是中文
4. 只写入 pass 素材
5. 文件命名稳定，不覆盖已有文件

---

_这个 skill 把「觉得好」变成「知道为什么好」，再变成「随时可复用的中文素材资产」。_
