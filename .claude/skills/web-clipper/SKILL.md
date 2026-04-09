---
name: web-clipper
description: 从单篇文章 URL 或文章索引页/归档页中抓取正文并保存到本地 Markdown。用户提到“收藏文章”“保存网页”“批量抓取页面里的文章”“把这个 archive 页前 N 篇拉下来”“保存到 Obsidian / Clippings / 本地”时必须优先使用。尤其适合公开网页、Substack、博客文章页、文章归档页。遇到懒加载列表、动态页面、静态抓取不全时，先用 browser 收集文章 URL，再调用脚本批量落地，以成功率优先。
---

# Web Clipper

目标：把「网页文章收藏」做成稳定工作流，而不是一次性手工操作。

## 这个 skill 解决什么问题

它覆盖两类任务：

1. **单篇收藏**
   - 输入一个文章 URL
   - 提取标题、摘要、发布日期、正文
   - 保存为 Markdown 到用户指定目录

2. **批量收藏**
   - 输入一个索引页、归档页、专题页、作者主页
   - 按用户要求抓前 N 篇、热门文章、最新文章，或指定的一组文章
   - 批量保存到本地

## 成功率优先的执行策略

按下面顺序走，不要反过来：

## 首次使用与依赖自检

这个 skill 在分享 zip 给别人后，统一走 wrapper，不要直接打主脚本。

首次运行时，先执行：

```bash
bash <web-clipper-root>/scripts/run_web_clipper.sh --help
```

注意：这条命令有副作用。

它会先运行 bootstrap，可能创建默认 clipping 目录和当前项目下的 `.web-clipper/EXTEND.md`。

wrapper 会先调用 `scripts/bootstrap.sh`，自动做这些事：

1. 检查 Python 3 是否可用
2. Python 3 缺失时尝试自动安装
3. 检查主脚本是否完整
4. 自动创建默认 clipping 目录
5. 首次运行时写入当前项目下的 `.web-clipper/EXTEND.md`

默认把“当前命令所在目录”当成目标项目根目录。

所以要从目标 vault 根目录执行 wrapper，不要在子目录里随手运行。

如果自动安装失败，要明确告诉用户：

- 卡在 Python 运行时，而不是网页抓取逻辑
- 当前平台推荐的安装命令
- 安装完成后重新运行 wrapper 即可

如果用户没给保存目录，优先顺序如下：

1. 当前项目 `.web-clipper/EXTEND.md` 里的 `default_output_dir`
2. 当前仓库下的 `00_收件箱/Clippings/`
3. 当前工作目录下的 `Clippings/`

### 路径 A：静态直抓

适用：

- 公开网页
- 不需要登录
- 文章页 HTML 里直接带正文或结构化 JSON
- Substack / 常规博客 / 简单 CMS

做法：

- 优先调用 `scripts/run_web_clipper.sh`
- 单篇：直接抓 URL
- 批量：先让脚本尝试从索引页静态提取文章链接

### 路径 B：浏览器补链路

适用：

- 索引页懒加载
- 静态 HTML 里只露出部分文章链接
- 需要滚动页面才能拿全前 N 篇
- 页面结构怪，脚本无法可靠收集链接

做法：

1. 用 `browser` 打开索引页
2. 滚动页面，直到收集到足够数量的文章 URL
3. 在页面里执行 JS，返回去重后的文章 URL 列表
4. 把 URL 列表写到临时 txt 文件
5. 再调用 `scripts/run_web_clipper.sh --url-file ...` 批量落地

这个模式很重要：**浏览器负责拿链接，脚本负责落地正文**。

### 路径 C：浏览器直接抽正文

适用：

- 单篇页面静态抓取被封
- `web_fetch` 被拦
- 脚本抓正文失败，但浏览器能正常打开渲染后的页面

做法：

- 用 `browser` 进入文章页
- 用 evaluate 从 DOM 或页面内嵌 JSON 里抽正文
- 组装 Markdown
- 用 `write` 落地文件

只有在 A、B 都不稳时再用 C，因为 C 更重，但成功率高。

## 输入澄清规则

如果用户没说明，优先补齐这 4 件事：

1. **单篇还是批量**
2. **抓多少篇**
3. **保存到哪里**
4. **是否只抓正文，还是顺带保留 frontmatter 元数据**

默认值：

- 单篇：抓 1 篇
- 批量：如果用户说“前几篇/前 20 篇/热门文章”就按用户要求；没说数量时，先问
- 输出格式：Markdown + YAML frontmatter
- 默认保存目录：如果用户没指定，就放用户已有的 clipping 目录；当前已知常用路径是 `00_收件箱/Clippings/`

## 推荐命令

### 单篇

```bash
WEB_CLIPPER_ROOT="<web-clipper-root>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" \
  --url "<文章URL>" \
  --mode single \
  --output-dir "<输出目录>"
```

### 批量，静态收集链接

```bash
WEB_CLIPPER_ROOT="<web-clipper-root>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" \
  --url "<索引页URL>" \
  --mode batch \
  --count 20 \
  --output-dir "<输出目录>"
```

### 批量，浏览器先收集链接再落地

```bash
WEB_CLIPPER_ROOT="<web-clipper-root>"
bash "$WEB_CLIPPER_ROOT/scripts/run_web_clipper.sh" \
  --url-file /tmp/article_urls.txt \
  --mode batch \
  --count 20 \
  --output-dir "<输出目录>"
```

如果用户没有显式传 `--output-dir`，wrapper 会优先读取 `.web-clipper/EXTEND.md` 的默认目录；如果没有配置，再自动回退到 `00_收件箱/Clippings/` 或 `Clippings/`。

## 浏览器收集 URL 的建议 JS

当静态页面拿不全链接时，用 `browser.act(kind="evaluate")` 执行类似逻辑：

```js
async () => {
  const collect = () => [
    ...new Set(
      Array.from(document.querySelectorAll('a[href*="/p/"]'))
        .map((a) => a.href)
        .filter((h) => !h.includes("/comments")),
    ),
  ];

  let urls = collect();
  for (let i = 0; i < 8 && urls.length < 20; i++) {
    window.scrollTo(0, document.body.scrollHeight);
    await new Promise((r) => setTimeout(r, 1500));
    urls = collect();
  }
  return urls;
};
```

然后把结果写到 `/tmp/article_urls.txt`，每行一个 URL。

## 输出要求

每篇文章输出一个 Markdown 文件，推荐结构：

```markdown
---
title: "..."
author: "..."
source: "..."
archive: "..."
published: "YYYY-MM-DD"
clipped: "ISO时间"
tags:
  - clipping
---

# 标题

> 摘要

正文...
```

## 文件命名

默认格式：

```text
YYYY-MM-DD 标题.md
```

如果日期缺失，就用：

```text
unknown-date 标题.md
```

## 失败处理

如果批量任务失败，不要一句“失败了”就结束。按这个顺序排查：

1. 索引页是否懒加载，导致静态只拿到部分链接
2. 文章页是否是公开页
3. 文章正文是否藏在结构化 JSON，例如 `body_html`
4. 是否需要浏览器渲染后再抽正文

要明确告诉用户卡在哪一层：

- 链接收集失败
- 正文提取失败
- 文件写入失败

## 当前已验证成功的站点模式

### Substack

已验证：

- 可从 archive 页收集文章 URL
- 可从文章页内嵌 JSON 字段 `body_html` 提取正文
- 适合保存到 Obsidian Clippings

这类站点优先用脚本批量处理；当 archive 页是懒加载时，用浏览器补 URL 收集。

## 交付回执

完成后，用简短结果回执，不要啰嗦：

```markdown
已保存到: <目录或文件路径>
类型: clipping / Markdown
理由: 已按要求完成单篇或批量文章收藏
```

如果是批量任务，再补一行：

- 成功 X 篇
- 失败 Y 篇

## 不该触发这个 skill 的情况

这些情况不要硬用本 skill：

- 用户要的是摘要、改写、翻译，而不是收藏落地
- 用户要抓登录后内容，且没有可用登录态
- 用户要抓整站所有页面做爬虫归档
- 用户要的是浏览器自动化测试，而不是文章收藏
