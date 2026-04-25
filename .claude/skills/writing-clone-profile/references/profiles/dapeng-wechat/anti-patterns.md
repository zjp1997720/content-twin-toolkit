# Anti-patterns（dapeng-wechat）

这份文件记录大鹏公众号长文最需要避免的具体坏味道。

它和 `anti-ai-mechanics.md` 的关系：

- `anti-ai-mechanics.md` 讲怎么增加活人感和心流。
- 本文件讲哪些写法会把大鹏文章写坏，以及应该怎么修。

## 1) 抽象情绪词代替体感

坏味道：

- 「我非常震撼」
- 「这件事让我深受触动」
- 「这个体验令人印象深刻」

为什么坏：

- 情绪被概括了，读者看不到人。

优先修法：

- 写动作、停顿、现场、身体反应。
- 没有真实体感时，直接克制写判断，不硬造情绪。

证据来源：

- `01_项目/内容创作/260411_AI时代你还在不在场/草稿_final.md`
- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/anti-ai-mechanics.md`

## 2) 方法论悬空，不接真实栈

坏味道：

- 只说「给 Skill 加上下文」「让 AI 更懂你」「形成闭环」。

为什么坏：

- 句子都对，但换一个 AI 博主也能写。

优先修法：

- 写当前真实工具栈、真实输入、真实输出、真实追问。
- 能写 `nmem / Obsidian CLI / 课程数据 / 激活率 / 具体定价`，就不要只写「个人数据」。

证据来源：

- `01_项目/内容创作/260413_爆改栋哥dbs-skill/草稿_final.md`
- `01_项目/内容创作/260402_个人上下文资产/03-Reviews/人工改稿-diff复盘.md`

## 3) 多案例平铺，没有升番

坏味道：

- 三个工具、五个角色、四种变现方式平均展开。
- 每一段结构一样，读者越读越知道下一段会怎么写。

为什么坏：

- 信息看似丰富，情绪和认知强度却越来越平。

优先修法：

- 最容易懂的放前面，最能改变判断的放后面。
- 弱案例压成一两句，强案例展开。
- 多角色文章优先展示碰撞，不展示全员履历。

证据来源：

- `03_归档/已发布文章/_用于初始化skill_精选代表作/我用_Claude_Code_造了个五人智囊团_Team_刘润和罗振宇为我的项目吵了一架.md`
- `01_项目/内容创作/260416_多角色实战效果/草稿_final.md`

## 4) 小标题像课件目录

坏味道：

- 小标题连续出现，每个标题下面直接列表。
- 读起来像「第一部分、第二部分、第三部分」。

为什么坏：

- 心流被切断，文章变成讲义。

优先修法：

- 系统拆解型文章可以保留小标题，但标题下第一段要承接上文。
- 观点/复盘/叙事文里，能用口语转场就不要硬上标题。

证据来源：

- `03_归档/已发布文章/_用于初始化skill_精选代表作/手把手教你打造_AI_写作分身_skill_最佳实践.md`
- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/opening-question-transition-moves.md`

## 5) 营销意图顶到门口

坏味道：

- 开头或中段过早出现课程、咨询、购买、引流动作。
- 文章还没交付价值，读者先闻到转化味。

为什么坏：

- 对 AI 圈读者尤其伤信任，他们识别套路太快。

优先修法：

- 公众号正文先交付认知密度和真实经验。
- 产品、课程、引流只在价值交付之后轻放，或移到文末。
- 如果文章主题是信任修复，正文里不要放销售动作。

证据来源：

- `01_项目/内容创作/260417_AI自媒体变现复盘/草稿_final.md`
- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/examples.md`

## 6) 结尾只总结，没有推进

坏味道：

- 「以上就是我的思考」
- 「希望对你有帮助」
- 把前文观点换一种说法再说一遍。

为什么坏：

- 读者没有带走动作、规矩、画面或更硬的判断。

优先修法：

- 给一个最小行动。
- 给一个个人规矩。
- 回到开头的场景或问题，给新理解。
- 用一句能复述的判断收住。

证据来源：

- `01_项目/内容创作/260402_个人上下文资产/03-Reviews/人工改稿-diff复盘.md`
- `01_项目/内容创作/260411_AI时代你还在不在场/草稿_final.md`

## 7) 伪完整结构

坏味道：

- 为了显得完整，硬写 5-6 个模块。
- 每个模块都对，但新增信息很少。
- 后半段其实在重复前半段已经成立的主张。

为什么坏：

- AI 最容易写出这种「正确但不值钱」的长文。

优先修法：

- 回到 `Module Budget`：每个模块必须说清新增信息和删除损失。
- 强观点文章优先 4 拍压缩，不为完整感拉长。

证据来源：

- `.claude/skills/writing-clone-profile/references/redundancy-lint.md`
- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/style-profile.md`

## 8) 外部素材盖过大鹏本人

坏味道：

- 引了很多外部作者、报告、金句，但大鹏自己的判断变少。
- 文章像资料汇编，而不是一个人在跟读者说话。

为什么坏：

- `dapeng-wechat` 的信任来自真实实践和判断，不来自素材密度。

优先修法：

- 外部素材只补槽位：hook、结构、金句、ending。
- 每条外部素材后都要回到大鹏自己的经历、项目或判断。

证据来源：

- `.claude/skills/writing-clone-profile/references/goldmine-retrieval-strategy.md`
- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/style-profile.md`

## 8.5) 外部高手拆成百科

坏味道：

- 介绍外部作者是谁、做过什么、方法论有哪些。
- 长篇概括外部文章，却没有回到大鹏自己的问题。

为什么坏：

- 大鹏的优势不是做百科，而是把外部材料转译成自己的判断和可执行动作。

优先修法：

- 外部材料只做镜子，不做主角。
- 每个外部观点后都问：它照见了我最近哪个困惑、哪个系统问题、哪个行动选择？
- 不连续引用外部作者超过两段。

证据来源：

- `03_归档/已发布文章/_用于初始化skill_精选代表作/我的数字分身是如何把Dan_Koe爆文讲透的_一天重启人生.md`
- `01_项目/内容创作/260324_别再把AI当聊天机器人而要把它驯化成工作系统/草稿_final.wechat.md`

## 9) 口头禅表演

坏味道：

- 「说实话」「你想想」「本质是」「一句话」密集出现。
- 删掉口头禅后，句子信息不受影响。

为什么坏：

- 这是模仿腔，不是活人感。

优先修法：

- 只有在判断转向、承认误判、压缩结论时使用。
- 每个主要小节最多保留 1 个强口语钉子。

证据来源：

- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/voice-cues.md`
- `.claude/skills/writing-clone-profile/references/profiles/dapeng-wechat/opening-question-transition-moves.md`

## 10) 事实精确性被活人感冲掉

坏味道：

- 为了像人，随手写「大概」「我记得」「应该」。
- 在价格、时间、收入、工具能力、承诺边界上模糊。

为什么坏：

- 大鹏可以口语，但不能用口语逃避准确。

优先修法：

- 核心事实进 Claim Ledger。
- 没来源就降级成主观判断，或删除。
- 模糊表达只用于非核心记忆，不用于数据和承诺。

证据来源：

- `.claude/skills/writing-clone-profile/references/claim-ledger-spec.md`
- `.claude/skills/writing-clone-profile/references/human-feel-flow-review.md`

## 快速审稿问题

写后快速问 8 个问题：

1. 哪一段只有抽象情绪，没有动作或场景？
2. 哪个方法论没有接到大鹏自己的真实栈？
3. 哪些案例是平铺的，能不能排序或压缩？
4. 哪个小标题下面直接进入列表，缺转场？
5. 有没有在价值交付前先露出营销意图？
6. 结尾有没有给动作、规矩、画面或 callback？
7. 哪个模块删掉后文章几乎不损失？
8. 哪句话是在靠口头禅装风格？
