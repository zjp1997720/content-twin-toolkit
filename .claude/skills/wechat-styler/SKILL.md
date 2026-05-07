---
name: wechat-styler
description: 将 Markdown 文章转换为微信公众号可用的内联样式 HTML，默认使用 kami 纸感主题，支持 kami、magazine-ink、magazine-indigo、magazine-forest、magazine-kraft、magazine-dune、elegant、modern、minimal 多主题切换和字体、字号、强调色、背景色、输出路径等参数配置。用于公众号排版、文章 HTML 生成、替代不稳定外部排版服务，尤其适合把本 vault 内文章转成可复制到微信公众号编辑器的格式。
---

# WeChat Styler - 公众号排版工具

将 Markdown 文章转换为优雅的公众号 HTML 格式，支持多主题切换。

## 使用方式

```bash
# 基础用法（使用默认主题）
/wechat-styler path/to/article.md

# 指定主题
/wechat-styler path/to/article.md --theme kami
/wechat-styler path/to/article.md --theme magazine-ink

# 批量转换（支持 glob 模式）
/wechat-styler "articles/*.md" --theme kami
/wechat-styler "01_项目/内容创作/**/*.md" --theme magazine-ink

# 自定义参数
/wechat-styler path/to/article.md --theme kami --font-size 17 --accent-color "#1B365D"

# 输出到指定路径（单文件）
/wechat-styler path/to/article.md --output path/to/output.html
```

## 可用主题

### 1. kami（紙感编辑排版）- 默认主题

**特点：**
- warm parchment 纸感背景：`#f5f4ed`
- ink-blue 单一强调色：`#1B365D`
- 中文标题使用衬线/楷体栈，正文使用稳定无衬线栈
- 温暖灰阶，不使用冷灰和纯白大底
- 标题左侧蓝色竖线、solid tag 背景、克制引用块
- 所有背景色使用 solid hex，并在外层、内容层、文本层重复声明，降低粘贴到公众号后背景丢失风险

**适用场景：** 公众号深度文章、商业分析、课程内容、正式说明文

**参数：**
```yaml
font_family_cn: 'Inter','TsangerJinKai02','Source Han Sans SC','Noto Sans CJK SC','PingFang SC','Microsoft YaHei',Arial,sans-serif
font_family_en: 'Newsreader','Source Serif 4','Source Serif Pro','Charter',Georgia,'Times New Roman',serif
font_size: 16
line_height: 1.55
accent_color: '#1B365D'
background_color: '#f5f4ed'
surface_color: '#faf9f5'
text_color: '#141413'
secondary_color: '#5e5d59'
heading_font: 'TsangerJinKai02','Source Han Serif SC','Noto Serif CJK SC','Songti SC','STSong',Georgia,serif
code_font: 'JetBrains Mono','SF Mono','Fira Code',Consolas,Monaco,'TsangerJinKai02','Source Han Serif SC',monospace
```

### 2. magazine 系列（电子杂志 × 电子墨水）

从 `magazine-web-ppt` 迁移来的 5 套预设，保留 `ink / paper / tint` 的杂志色彩关系，同时改造成微信公众号安全 HTML：不使用 `rgba()`，所有背景色均为 solid hex。

| 主题 | 命令 | 变体 | 字体 / 版式人格 |
|------|------|------|------------------|
| 墨水经典 | `--theme magazine-ink` | `ink-classic` | 无衬线正文 + 衬线标题，细 rule、dash list、pull quote，通用杂志内页 |
| 靛蓝瓷 | `--theme magazine-indigo` | `indigo-research` | Inter/SF Pro 正文 + Source Serif 标题，左侧研究栏、note quote、技术代码块 |
| 森林墨 | `--theme magazine-forest` | `forest-fieldnote` | 楷体/宋体正文 + 非虚构标题，居中标题、field note 引用、自然图片说明 |
| 牛皮纸 | `--theme magazine-kraft` | `kraft-archive` | 宋体正文 + archive 标题盒，档案式引用、罗马数字有序列表、旧纸代码框 |
| 沙丘 | `--theme magazine-dune` | `dune-gallery` | Avenir 正文 + Didot/Bodoni 标题，右对齐画廊标题、gallery quote、极简图片说明 |

**共同特点：**
- 每个主题都有独立字体栈、字号、行距、段距、标题结构、列表 marker、引用块、代码块和图片说明。
- 分隔以留白、短淡线和局部标识为主；不会在每个章节之间自动插入整宽实线。
- 五个主题共享 `magazine-editorial` renderer 入口，但通过 `magazine_variant` 走不同结构分支，不只是替换颜色。
- 所有背景色都使用 solid hex，并在区块与文本 span 上重复声明 `background-color`，降低复制到公众号编辑器后背景色丢失的概率。
- 图片自身带 `margin:0 auto` 居中兜底，避免公众号编辑器复制后改写图片宽度导致图片靠左。
- 版式保留杂志感，但输出仍完全内联，可直接复制到公众号编辑器。

### 3. elegant（优雅复古）

**特点：**
- 中文：方正书宋（FZShuSong-Z01）
- 英文：Garamond
- 整体淡灰色背景
- 红色强调色系统
- 衬线标题 + 等宽代码

**适用场景：** 商业案例、深度分析、知识分享

**参数：**
```yaml
font_family_cn: 'FZShuSong-Z01','Songti SC',STSong,serif
font_family_en: 'Garamond',serif
font_size: 16
line_height: 1.9
accent_color: '#cf4436'
background_color: '#f7f6f1'
heading_font: 'Noto Serif SC','Songti SC',STSong,Georgia,serif
code_font: 'JetBrains Mono','SF Mono',Menlo,Consolas,monospace
```

### 4. modern（现代简约）

**特点：**
- 无衬线字体
- 纯白背景
- 蓝色强调色
- 清晰现代

**适用场景：** 科技产品、教程、快讯

**参数：**
```yaml
font_family_cn: 'PingFang SC','Hiragino Sans GB','Microsoft YaHei',sans-serif
font_family_en: 'SF Pro Display','Helvetica Neue',sans-serif
font_size: 16
line_height: 1.8
accent_color: '#007aff'
background_color: '#ffffff'
heading_font: 'PingFang SC','Hiragino Sans GB',sans-serif
code_font: 'SF Mono',Menlo,Consolas,monospace
```

### 5. minimal（极简主义）

**特点：**
- 极简黑白
- 大量留白
- 灰色调
- 克制优雅

**适用场景：** 哲学思考、个人随笔、艺术评论

**参数：**
```yaml
font_family_cn: 'Noto Sans SC','PingFang SC',sans-serif
font_family_en: 'Inter','Helvetica Neue',sans-serif
font_size: 15
line_height: 2.0
accent_color: '#333333'
background_color: '#fafafa'
heading_font: 'Noto Sans SC',sans-serif
code_font: 'JetBrains Mono',monospace
```

## Renderer Presets

主题不只换颜色。每个主题绑定一个 Markdown 渲染人格，负责标题、正文、引用、列表、代码、图片说明的结构、字号、行高、间距和字重。

| Preset | 绑定主题 | 版式语气 |
|--------|----------|----------|
| `kami-document` | `kami` | 纸感文档：正式、克制、标题左侧 ink-blue 竖线 |
| `magazine-editorial` | `magazine-ink` / `magazine-indigo` / `magazine-forest` / `magazine-kraft` / `magazine-dune` | 电子杂志家族：通过 `magazine_variant` 分别呈现 classic / research / fieldnote / archive / gallery 五种版式 |
| `elegant-essay` | `elegant` | 复古长文：居中标题、舒展行距、摘录式引用 |
| `modern-technical` | `modern` | 现代教程：无衬线层级、提示卡片、技术代码块 |
| `minimal-notes` | `minimal` | 极简笔记：低装饰、大留白、细线引用 |

**公众号兼容硬规则：** 所有 preset 输出均为 inline style；背景色使用 solid hex；外层 section、内容 section、文本 span 会重复声明 `background-color`。

## 主题参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--theme` | 主题名称 | `kami` |
| `--font-size` | 正文字号（px） | `16` |
| `--line-height` | 行高 | `1.55` |
| `--accent-color` | 强调色（标题、链接） | `#1B365D` |
| `--background-color` | 背景色，必须使用 solid hex | `#f5f4ed` |
| `--max-width` | 内容最大宽度（px） | `640` |
| `--output` | 输出文件路径 | 自动生成 |

## 输出规则

**默认输出路径：**
- 输入：`path/to/article.md`
- 输出：`path/to/article_wechat.html`

**输出内容：**
1. 完整的 HTML 文件
2. 内联样式（可直接复制到公众号）
3. 保留图片链接
4. 自动处理代码块、引用块、列表等

## 工作流程

1. **读取 Markdown 文件**
   - 解析 frontmatter（标题、摘要等）
   - 提取正文内容

2. **加载主题配置**
   - 读取主题参数
   - 应用用户自定义参数

3. **转换为 HTML**
   - Markdown → HTML 结构
   - 应用主题样式（内联）
   - 处理特殊元素（代码、图片、引用）

4. **输出文件**
   - 生成完整 HTML
   - 保存到指定路径
   - 输出使用说明

## 主题预览

不确定选哪个主题？使用主题预览生成器对比所有主题效果：

```bash
# 生成所有主题的预览页面（使用默认示例文章）
node scripts/generate-preview.mjs

# 使用自定义文章生成预览
node scripts/generate-preview.mjs path/to/your-article.md

# 只预览指定主题（逗号分隔，无空格）
node scripts/generate-preview.mjs article.md --themes magazine-ink,magazine-indigo,magazine-forest,magazine-kraft,magazine-dune

# 自定义输出路径
node scripts/generate-preview.mjs article.md --themes kami,elegant --output /path/to/my-preview.html
```

预览页面会并排展示所选主题的效果，方便快速对比选择。生成的 `preview.html` 可以在浏览器中打开查看。

## 扩展新主题

**步骤：**

1. 在 `themes/` 目录创建新主题配置文件：
   ```yaml
   # themes/my-theme.yaml
   name: my-theme
   description: 我的自定义主题
   font_family_cn: 'Custom Font CN'
   font_family_en: 'Custom Font EN'
   font_size: 16
   line_height: 1.8
   accent_color: '#ff6b6b'
   background_color: '#f8f9fa'
   heading_font: 'Heading Font'
   code_font: 'Code Font'
   ```

2. 使用新主题：
   ```bash
   /wechat-styler article.md --theme my-theme
   ```

## 注意事项

1. **字体回退**：所有字体都有完整的回退栈，确保在不同系统上都能正常显示
2. **图片处理**：保留原始图片链接，确保图床可访问
3. **代码块**：使用等宽字体 + 浅色背景
4. **引用块**：浅底或细左线，避免厚重边框
5. **图片居中**：图片同时使用父级 `text-align:center` 和自身 `margin:0 auto`，防止公众号编辑器复制后图片偏移
6. **公众号兼容**：所有样式内联，背景色使用 solid hex，避免 rgba / body 背景在编辑器中丢失

## 示例

**输入 Markdown：**
```markdown
---
title: 文章标题
summary: 文章摘要
---

## 章节标题

这是一段正文，包含**加粗**和`代码`。

![图片说明](https://example.com/image.png)

> 这是一段引用
```

**输出 HTML：**
- 完整的公众号可用 HTML
- 所有样式内联
- 可直接复制粘贴

## 技术实现

**核心脚本：** `scripts/convert.mjs`

**依赖：**
- Node.js 18+
- marked（Markdown 解析）
- js-yaml（YAML 解析）

**目录结构：**
```
wechat-styler/
├── SKILL.md
├── scripts/
│   └── convert.mjs
├── themes/
│   ├── elegant.yaml
│   ├── kami.yaml
│   ├── magazine-dune.yaml
│   ├── magazine-forest.yaml
│   ├── magazine-indigo.yaml
│   ├── magazine-ink.yaml
│   ├── magazine-kraft.yaml
│   ├── modern.yaml
│   └── minimal.yaml
└── templates/
    └── base.html
```

---

**最后更新：** 2026-04-24
**版本：** 1.3.0
**作者：** 大鹏
