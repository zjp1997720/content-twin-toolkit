---
name: first-time-setup
description: First-time bootstrap flow for web-clipper
---

# First-Time Setup

## Overview

当当前项目下的 `.web-clipper/EXTEND.md` 不存在时，先完成首次使用引导，再继续抓取。

这一步的目标不是让用户手工折腾，而是：

1. 自动检查 Python 3 是否存在
2. 缺失时优先自动安装
3. 自动创建默认 clipping 目录
4. 保存项目内默认配置，后续复用

## Blocking Rule

首次使用时，先完成 bootstrap，再继续正文抓取。

不要直接跳过检查去调用 `clip_articles.py`。

## Runtime Entry

统一入口：

```bash
bash <web-clipper-root>/scripts/run_web_clipper.sh ...
```

从目标项目根目录执行这条命令。

`run_web_clipper.sh --help` 也会触发 bootstrap，这是有意设计，不是 bug。

不要直接调用：

```bash
python3 <web-clipper-root>/scripts/clip_articles.py ...
```

因为 wrapper 会先做自检、安装和默认目录处理。

## What Bootstrap Does

`bootstrap.sh` 会按顺序处理：

1. 检查 `python3` / `python`
2. 缺失时尝试自动安装（brew / apt-get / dnf / yum / pacman / winget / choco）
3. 检查 `clip_articles.py` 是否存在
4. 检查或创建默认输出目录
5. 保存首次配置到当前项目下的 `.web-clipper/EXTEND.md`
6. 检查浏览器增强能力是否可用（只告警，不阻塞静态抓取）
7. 拒绝写到项目边界之外的输出目录

## Saved Config

首次运行后会在当前项目生成：

```md
version: 1
skill_root: "..."
default_output_dir: "..."
auto_create_output_dir: true
auto_install_python: true
browser_fallback_enabled: true
```

## Agent Guidance

- 如果用户没指定输出目录，优先使用当前项目 `.web-clipper/EXTEND.md` 里保存的 `default_output_dir`
- 如果用户第一次使用且 bootstrap 自动安装失败，要明确告诉用户失败在“运行时依赖层”，并给出对应平台的安装命令
- 如果只是缺浏览器，不要中断单篇静态抓取任务
- 如果用户在子目录里运行 wrapper，要提醒他切回目标 vault 根目录再执行
