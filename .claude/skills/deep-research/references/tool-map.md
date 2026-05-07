# 工具映射与使用指南

本 Skill 使用的工具清单、调用方式、注意事项。

## 工具清单

### 通用搜索

| 工具 | 调用方式 | 用途 |
|------|---------|------|
| `WebSearch` | Claude Code 内置 | 通用网页搜索，大多数场景的首选 |
| `mcp__web_reader__webReader` | MCP | 深度抓取 URL 内容（返回 Markdown） |

### 论文搜索（alpha CLI）

| 命令 | 状态 | 用途 |
|------|------|------|
| `alpha get <arXiv-ID>` | ✅ 可用 | 获取 AI 生成的论文详细分析报告 |
| `alpha code <github-url> [path]` | ✅ 可用 | 读取论文关联的 GitHub 仓库 |
| `alpha annotate <arXiv-ID> <note>` | ✅ 可用 | 本地持久化论文批注 |
| `alpha search <query>` | ❌ 当前不可用 | 语义论文搜索（后端 bug，用 WebSearch 替代） |
| `alpha ask <arXiv-ID> <question>` | ❌ 当前不可用 | 论文问答（后端 bug） |

### 记忆系统

| 工具 | 调用方式 | 用途 |
|------|---------|------|
| `mcp__Nowledge_Mem__memory_search` | MCP | 搜索历史调研记忆 |
| `mcp__Nowledge_Mem__memory_add` | MCP | 存储调研发现 |

### Agent 编排

| 工具 | 调用方式 | 用途 |
|------|---------|------|
| `Agent` | Claude Code 内置 | 派生子 agent 做并行搜索 |
| `TeamCreate` | Claude Code 内置 | 创建 agent team 做 complex 级别调研 |

## 搜索策略模板

### 通用搜索

```
WebSearch: "<关键词> <年份>"
WebSearch: "<关键词> review overview"  # 找综述类内容
WebSearch: "<关键词> vs <替代方案>"     # 找对比分析
```

### 论文搜索

```
# 第一步：发现论文
WebSearch: "<topic> site:arxiv.org"

# 第二步：从搜索结果提取 arXiv ID（如 2301.01234）

# 第三步：获取详细分析
Bash: "alpha get <arXiv-ID> --json"
```

### 技术文档搜索

```
WebSearch: "<技术名> official documentation"
WebSearch: "<技术名> site:docs.xxx.com"
```

### 中文内容搜索

```
WebSearch: "<关键词> <年份> 行业报告"
WebSearch: "<关键词> 深度分析"
```

## alpha CLI 备忘

```bash
# 安装（已完成）
npm install -g @companion-ai/alpha-hub

# 登录状态检查
alpha status

# 获取论文分析（核心用法）
alpha get 1706.03762 --json    # arXiv ID
alpha get https://arxiv.org/abs/1706.03762 --json  # arXiv URL

# 读取论文代码
alpha code https://github.com/openai/gpt-2 /          # 仓库根目录
alpha code https://github.com/openai/gpt-2 src/model.py  # 具体文件

# 批注
alpha annotate 1706.03762 "Flash Attention 已超越此方法"
alpha annotate --list   # 列出所有批注
```
