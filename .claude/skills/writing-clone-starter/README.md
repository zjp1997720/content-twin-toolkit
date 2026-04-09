# Writing Clone Starter

这是给学员和用户的新写作入口。

它解决的问题不是“像用户自己写”，而是：

- 用户没什么个人沉淀，也能先写出一篇强文章
- 用户可以先体验“像某个内置作者方向写”

它和 `writing-clone-profile` 的区别很简单：

- `writing-clone-profile`：像用户自己写
- `writing-clone-starter`：先帮没有个人资产的新手写出强文章，或先体验像某个内置作者写

## 适用场景

- 用户只有一个主题，但没有完整素材和长期沉淀
- 用户想先低门槛起稿，而不是先做个人 clone
- 用户明确说想体验 Dan Koe、粥左罗、Justin Welsh、刘润、梁宁、薛辉 方向
- 用户要的是“先写出强稿”，不是“先像我自己写”

## 不适用场景

- 用户已经有成熟个人风格，要继续沿用自己的 profile
- 用户已经处在 `writing-clone-profile` / `writing-clone-lite` 的既有流程里
- 当前任务不是写文章，而是继续研究系统或扩素材

## 当前已落地

1. 共同标准（强文章 / 高拟态）
2. 强文章模式首批 4 个原型
3. Dan Koe 正式作者 profile 雏形
4. 粥左罗正式作者 profile 雏形
5. Justin Welsh 正式作者 profile 雏形
6. 刘润正式作者 profile 雏形
7. 梁宁正式作者 profile 雏形
8. 薛辉正式作者 profile 雏形
9. runtime 收口协议
10. 内置人物 profile 蒸馏模块（维护者路径）
11. 内置 profile probe 评测模块（维护者路径）

> 成熟度不等价：Dan Koe、粥左罗是更成熟的试点作者；Justin Welsh 已到可试用 draft 水位；刘润、梁宁、薛辉当前更适合在各自核心带宽内试用，不建议默认按同成熟度理解。

## 当前未落地

- 动作库
- 更大规模的内置作者 profile 池
- 完整 runtime 自动路由实现

## 维护者内置模块

除了学员写作入口外，starter 现在还内置了一组只给维护者使用的参考文件：

- `references/profile-distillation/`
- `references/profile-probe/`

它的职责是：

- 新增一个大 IP 的作者 profile
- 更新已有 profile
- 同步把高价值素材落到 Obsidian 素材库

其中分工要区分：

- `profile-distillation/`：生成或更新 profile
- `profile-probe/`：验证 profile 是否能稳定带出高拟态正文

这不是普通用户写文章时的默认路径。

## 当前模式

- **强文章模式**：默认模式，不绑定作者
- 首批原型：观点拆解型、方法教程型、案例复盘型、认知升级型
- **高拟态模式**：当前已支持 Dan Koe、粥左罗、Justin Welsh、刘润、梁宁、薛辉；如果主题超出作者原生带宽，会自动降级

## 当前默认主路径

如果用户没有显式指定作者，starter 默认按这条链工作：

强文章标准 → 原型路由 → 命中原型 → 按原型取料 → anti-bleed 检查 → 交付正文

也就是说：

- 强文章不是 fallback
- 高拟态不是默认并列主入口
- `response.md` 是主成品，`run_summary.md` 是辅助说明

## 硬约束

- 本 skill 不使用 `form-normalized-anchors`
- 高拟态模式超出作者原生带宽时，自动降级到强文章模式

## 当前目标

这版的目标不是把所有功能一次做完。

这版的目标是先把：

- 入口文档
- 共同标准
- 强文章原型库初版
- 首批内置作者 profile

做成一个更正式、更可继续迭代的 skill 初版。
