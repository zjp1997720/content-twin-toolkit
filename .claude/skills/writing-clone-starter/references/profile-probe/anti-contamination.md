# Profile Probe｜防污染规则

## 生成 / 评价必须分离

### 生成侧不要读

- 历史 `evaluator_score.md`
- 本轮评分模板中的结论性语言
- 上一轮明确的打分结果

### 评分侧不要读

- `generator-brief.md`
- `run_summary.md`
- 历史 probe 的生成说明
- profile 作者资产以外的生成备注

## 说明层不能取代正文层

- `run_summary.md` 只能做辅助说明
- 不能让“像度”主要靠 run summary 成立

## 防止误把 probe 当优化对象

- 评分者指出的问题，默认回写 profile
- 不默认把这些问题当成“这篇文章还要继续润”的理由

## 防止题材抬分

- 题材特别贴脸时，要额外做 false-positive 检查
- 如果题材本身就很容易像，不应高估 profile 的稳定性
