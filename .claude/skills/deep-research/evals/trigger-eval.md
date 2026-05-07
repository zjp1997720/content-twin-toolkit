# 触发路由验证

用于验证 deep-research skill 的 description 是否正确路由。

## 应当触发的输入

以下输入应该触发 deep-research skill：

1. 「帮我深度调研一下 Claude Code 的 MCP 机制」
2. 「深度研究 RAG 技术的最新进展」
3. 「帮我系统梳理 2026 年 AI 编程工具的竞争格局」
4. 「全面了解 Anthropic 的 Claude Agent SDK」
5. 「帮我做个文献综述，关于 context engineering」
6. 「/deep-research Feynman CLI 的深度调研流程」
7. 「调研一下 Cursor 和 Windsurf 的区别」
8. 「我想了解这个领域的前沿进展，帮我做一次全面调研」

## 不应触发的输入

以下输入不应触发 deep-research skill（应走其他路由）：

1. 「MCP 是什么？」→ 简单问答，WebSearch 直接回答
2. 「帮我写一篇关于 AI 的公众号文章」→ writing-clone-profile
3. 「这篇文章帮我拆成素材」→ content-goldmine-gemini
4. 「帮我修一下这个 bug」→ 代码调试
5. 「总结一下这个文件」→ 简单总结
6. 「Claude Code 怎么安装？」→ 单一事实问题

## 边界案例

| 输入 | 应触发？ | 原因 |
|------|---------|------|
| 「帮我搜索一下 X」 | 否 | 单次搜索，不是深度调研 |
| 「帮我调研 X，只需要简单了解」 | 否 | 用户明确说简单，走 WebSearch |
| 「帮我调研 X，要写一份完整报告」 | 是 | 明确要求深度 + 报告 |
| 「对比一下 A 和 B」 | 视情况 | 单维度对比可能只需搜索；多维度应触发 |
| 「深度分析这篇文章」 | 否 | 这是内容分析，不是联网调研 |

## 路由冲突

与以下 skill 存在潜在路由冲突：

| Skill | 区分点 |
|-------|--------|
| `deep-collide` | deep-collide 是认知碰撞/思考，不需要联网搜索 |
| `content-goldmine-gemini` | goldmine 是拆素材，调研是产报告 |
| `writing-clone-profile` | writing 是写文章，调研是收集信息 |
| `web-clipper` | clipper 是保存网页，调研是分析信息 |

区分核心：**deep-research = 联网搜索 + 多源整合 + 引用验证 + 报告产出**
