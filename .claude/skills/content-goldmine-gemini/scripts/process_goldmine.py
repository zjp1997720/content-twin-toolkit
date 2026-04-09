#!/usr/bin/env python3
"""content-goldmine-gemini

把收藏文章拆解成可复用的中文素材碎片，并按素材库既有模板落库。
设计原则：Gemini 负责理解与提炼；本地脚本负责路径、命名、模板一致性。
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Any

DEFAULT_MODEL = "gemini-3-flash-preview"
PROJECT_ROOT_ENV = "CONTENT_GOLDMINE_PROJECT_ROOT"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="内容挖金矿 - 拆解文章为素材碎片")
    parser.add_argument("--input", "-i", help="单篇文章 Markdown 路径")
    parser.add_argument("--dir", "-d", help="批量处理目录")
    parser.add_argument(
        "--count", "-c", type=int, default=10, help="批量处理数量，默认 10"
    )
    parser.add_argument("--url-file", "-f", help="文件列表，每行一个路径")
    parser.add_argument(
        "--model",
        "-m",
        default=DEFAULT_MODEL,
        help=f"Gemini 模型 ID，默认 {DEFAULT_MODEL}",
    )
    parser.add_argument(
        "--project-root", help="当前项目根目录；默认取环境变量或当前工作目录"
    )
    parser.add_argument("--dry-run", action="store_true", help="只预览，不写文件")
    parser.add_argument(
        "--save-full-analysis", action="store_true", help="额外保存完整解构稿"
    )
    return parser.parse_args()


def parse_frontmatter(content: str) -> tuple[dict[str, Any], str]:
    metadata: dict[str, Any] = {}
    if not content.startswith("---\n"):
        return metadata, content

    parts = content.split("---", 2)
    if len(parts) < 3:
        return metadata, content

    frontmatter = parts[1].strip("\n")
    body = parts[2].lstrip("\n")
    current_list_key = None

    for raw_line in frontmatter.splitlines():
        line = raw_line.rstrip()
        if not line.strip():
            continue
        if re.match(r"^\s+-\s+", line) and current_list_key:
            metadata.setdefault(current_list_key, []).append(
                re.sub(r"^\s+-\s+", "", line).strip().strip('"')
            )
            continue
        if ":" in line:
            key, value = line.split(":", 1)
            key = key.strip()
            value = value.strip()
            if value == "":
                metadata[key] = []
                current_list_key = key
            else:
                metadata[key] = value.strip().strip('"')
                current_list_key = None
    return metadata, body


def resolve_project_root(explicit_root: str | None) -> Path:
    candidate = explicit_root or os_environ(PROJECT_ROOT_ENV) or str(Path.cwd())
    project_root = Path(candidate).expanduser().resolve()
    if not project_root.exists():
        raise RuntimeError(f"项目根目录不存在：{project_root}")
    if not project_root.is_dir():
        raise RuntimeError(f"项目根目录不是文件夹：{project_root}")
    return project_root


def os_environ(key: str) -> str | None:
    value = os.environ.get(key)
    if value is None:
        return None
    stripped = value.strip()
    return stripped or None


def resolve_path_in_project(project_root: Path, relative_path: str) -> Path:
    candidate = (project_root / relative_path).resolve()
    try:
        candidate.relative_to(project_root)
    except ValueError as exc:
        raise RuntimeError(
            f"输出路径越界，不允许写到当前项目之外：{candidate}"
        ) from exc
    return candidate


def output_dirs(project_root: Path) -> dict[str, Path]:
    output_base_dir = resolve_path_in_project(project_root, "02_素材库/灵感素材")
    return {
        "title": output_base_dir / "标题",
        "opening": output_base_dir / "开头",
        "quote": output_base_dir / "金句",
        "structure": output_base_dir / "结构",
    }


def full_analysis_dir(project_root: Path, article_body: str) -> Path:
    relative = (
        "02_素材库/高表现内容/长文"
        if len(article_body.strip()) > 800
        else "02_素材库/高表现内容/短图文"
    )
    return resolve_path_in_project(project_root, relative)


def read_article(file_path: Path) -> dict[str, Any]:
    content = file_path.read_text(encoding="utf-8")
    metadata, body = parse_frontmatter(content)

    author = metadata.get("author", "unknown")
    source_url = metadata.get("source") or metadata.get("source_url", "")
    published = metadata.get("published") or metadata.get("date", "")
    title = metadata.get("title") or file_path.stem
    tags = metadata.get("tags", [])

    source_label = author
    folder_name = file_path.parent.name.strip()
    if source_label == "unknown" and folder_name:
        source_label = folder_name

    return {
        "path": str(file_path),
        "title": title,
        "author": author,
        "source_label": source_label,
        "source_url": source_url,
        "published": published,
        "tags": tags if isinstance(tags, list) else [],
        "body": body,
    }


def build_prompt(article: dict[str, Any]) -> str:
    return f"""你是内容素材库的拆解编辑。你的任务不是写一份泛泛的总结，而是把文章提炼成可以落库的碎片资产。

要求：
1. 输出必须是一个合法 JSON 对象，不要输出 markdown，不要加代码块。
2. 所有分析字段用中文。
3. 如果原文是英文，碎片必须同时给出：原文片段 + 中文转写。
4. 严格按素材库思路输出：只保留可复用内容，宁缺毋滥。
5. `why_good` 和 `variants` 都输出为字符串数组。
6. `pass` 必须是 true 或 false。
7. `keyword` 用于命名文件，尽量短，优先英文/拼音/简短中文，不要带空格和特殊字符。
8. 标题、开头最多 1 条；金句、结构公式可以多条。

文章信息：
- 标题：{article["title"]}
- 作者：{article["author"]}
- 来源：{article["source_url"]}
- 发布日期：{article["published"]}

文章正文：
{article["body"]}

请返回如下 JSON 结构：
{{
  "article": {{
    "title": "文章标题",
    "source": "来源名称",
    "url": "原文链接",
    "published": "发布日期",
    "keyword": "用于命名的短关键词"
  }},
  "analysis": {{
    "philosophy": "哲学层一句话",
    "psychology": "心理层一句话",
    "distribution": "传播层一句话",
    "social": "社会层一句话"
  }},
  "assets": {{
    "title": [{{
      "original": "原文标题或原文片段",
      "zh": "中文转写或中文改写",
      "pass": true,
      "why_good": ["要点1", "要点2"],
      "rewrite_suggestion": "若 fail 则给改写建议，否则写空字符串",
      "variants": ["变体方向1", "变体方向2"]
    }}],
    "opening": [{{
      "original": "原文开头片段",
      "zh": "中文转写",
      "pass": true,
      "why_good": ["要点1", "要点2"],
      "rewrite_suggestion": "",
      "variants": ["变体方向1", "变体方向2"]
    }}],
    "quotes": [{{
      "original": "原文金句",
      "zh": "中文转写",
      "pass": true,
      "why_good": ["要点1", "要点2"],
      "rewrite_suggestion": "",
      "variants": ["变体方向1", "变体方向2"]
    }}],
    "structures": [{{
      "original": "原始结构公式或留空",
      "zh": "中文结构公式",
      "pass": true,
      "why_good": ["要点1", "要点2"],
      "rewrite_suggestion": "",
      "variants": ["变体方向1", "变体方向2"]
    }}]
  }}
}}
"""


def run_gemini(prompt: str, model: str) -> subprocess.CompletedProcess[str]:
    commands = [
        ["gemini", "-p", prompt, "--model", model, "--output-format", "json"],
        ["gemini", "--model", model, "--output-format", "json", prompt],
    ]
    last_error: RuntimeError | None = None

    for command in commands:
        try:
            return subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=180,
                check=True,
            )
        except FileNotFoundError as exc:
            raise RuntimeError(
                "未检测到 Gemini CLI。请先安装 Gemini CLI，并完成登录授权后再运行。"
            ) from exc
        except subprocess.TimeoutExpired as exc:
            raise RuntimeError("Gemini CLI 超时") from exc
        except subprocess.CalledProcessError as exc:
            stderr = (exc.stderr or "").strip()
            stdout = (exc.stdout or "").strip()
            combined = "\n".join(part for part in [stderr, stdout] if part)
            normalized = combined.lower()
            if (
                "unknown option" in normalized
                or "unknown flag" in normalized
                or "unexpected argument" in normalized
            ):
                last_error = RuntimeError(combined or "Gemini CLI 参数不兼容")
                continue
            if (
                "auth" in normalized
                or "login" in normalized
                or "credential" in normalized
                or "api key" in normalized
            ):
                raise RuntimeError(
                    "Gemini CLI 已安装，但当前还没有完成认证。请先运行 `gemini`，选择登录方式并完成授权。"
                ) from exc
            raise RuntimeError(f"Gemini CLI 错误：{combined or '未知错误'}") from exc

    raise RuntimeError(f"Gemini CLI 参数不兼容：{last_error}")


def call_gemini_json(prompt: str, model: str) -> dict[str, Any]:
    if shutil.which("gemini") is None:
        raise RuntimeError(
            "未检测到 Gemini CLI。请先安装 Gemini CLI，并完成登录授权后再运行。"
        )

    result = run_gemini(prompt, model)
    stdout = (result.stdout or "").strip()
    try:
        return json.loads(stdout)
    except json.JSONDecodeError:
        match = re.search(r"\{[\s\S]*\}\s*$", stdout)
        if match:
            return json.loads(match.group(0))
        raise RuntimeError(f"Gemini 输出不是合法 JSON：\n{stdout[:1200]}")


def slugify(text: str, fallback: str = "asset") -> str:
    text = (text or "").strip().lower()
    text = re.sub(r"[\s/]+", "_", text)
    text = re.sub(r"[^0-9a-zA-Z_\-\u4e00-\u9fff]+", "", text)
    text = text.strip("_")
    return text[:32] or fallback


def mostly_ascii(text: str) -> bool:
    if not text:
        return False
    chars = [ch for ch in text if not ch.isspace()]
    if not chars:
        return False
    ascii_count = sum(1 for ch in chars if ord(ch) < 128)
    return ascii_count / len(chars) > 0.8


def build_fragment_markdown(
    item: dict[str, Any], article: dict[str, Any], analysis: dict[str, Any]
) -> str:
    lines = [
        "---",
        f"source: {article['source_label']}",
        f"url: {article['source_url']}",
        f"collected: {datetime.now().strftime('%Y-%m-%d')}",
        f"from_article: {article['title']}",
        "---",
        "",
        "## 内容",
        "",
        item.get("original") or item.get("zh") or "",
    ]

    zh = (item.get("zh") or "").strip()
    original = (item.get("original") or "").strip()
    if zh and zh != original and (mostly_ascii(original) or original == ""):
        lines.extend(["", "## 中文转写", "", zh])

    lines.extend(["", "## 为什么好", ""])
    for reason in item.get("why_good", []) or []:
        lines.append(f"- {reason}")
    if not (item.get("why_good") or []):
        lines.append("- 暂无")

    lines.extend(
        [
            "",
            "## 4D标签",
            "",
            f"- 哲学层：{analysis.get('philosophy', '')}",
            f"- 心理层：{analysis.get('psychology', '')}",
            f"- 传播层：{analysis.get('distribution', '')}",
            f"- 社会层：{analysis.get('social', '')}",
            "",
            "## 可变体方向",
            "",
        ]
    )
    for variant in item.get("variants", []) or []:
        lines.append(f"- {variant}")
    if not (item.get("variants") or []):
        lines.append("- 暂无")
    return "\n".join(lines).rstrip() + "\n"


def next_available_path(base_dir: Path, base_name: str) -> Path:
    candidate = base_dir / f"{base_name}.md"
    if not candidate.exists():
        return candidate
    idx = 1
    while True:
        candidate = base_dir / f"{base_name}_{idx}.md"
        if not candidate.exists():
            return candidate
        idx += 1


def save_asset(
    asset_type: str,
    item: dict[str, Any],
    article: dict[str, Any],
    analysis: dict[str, Any],
    keyword: str,
    index: int,
    dry_run: bool,
    type_dir_map: dict[str, Path],
) -> str:
    base_dir = type_dir_map[asset_type]
    date_str = datetime.now().strftime("%Y%m%d")
    source_slug = slugify(article["source_label"], "source")
    keyword_slug = slugify(keyword, "asset")
    base_name = f"{date_str}_{source_slug}_{keyword_slug}"
    if asset_type in {"quote", "structure"}:
        base_name = f"{base_name}_{index}"

    file_path = next_available_path(base_dir, base_name)
    content = build_fragment_markdown(item, article, analysis)

    if dry_run:
        return f"[DRY-RUN] {file_path}"

    base_dir.mkdir(parents=True, exist_ok=True)
    file_path.write_text(content, encoding="utf-8")
    return str(file_path)


def save_full_analysis(
    article: dict[str, Any], parsed: dict[str, Any], dry_run: bool, target_dir: Path
) -> str:
    target_dir.mkdir(parents=True, exist_ok=True)
    date_str = datetime.now().strftime("%Y%m%d")
    source_slug = slugify(article["source_label"], "source")
    parsed_article = parsed.get("article", {}) if isinstance(parsed, dict) else {}
    if not isinstance(parsed_article, dict):
        parsed_article = {}
    keyword_slug = slugify(
        parsed_article.get("keyword") or article["title"], "analysis"
    )
    file_path = next_available_path(
        target_dir, f"{date_str}_{source_slug}_{keyword_slug}"
    )

    analysis = parsed.get("analysis", {}) or {}
    body = [
        "---",
        f"title: {article['title']}",
        f"source: {article['source_label']}",
        f"url: {article['source_url']}",
        f"collected: {datetime.now().strftime('%Y-%m-%d')}",
        "---",
        "",
        "## 4D拆解",
        "",
        f"- 哲学层：{analysis.get('philosophy', '')}",
        f"- 心理层：{analysis.get('psychology', '')}",
        f"- 传播层：{analysis.get('distribution', '')}",
        f"- 社会层：{analysis.get('social', '')}",
        "",
        "## 原始结构化结果",
        "",
        "```json",
        json.dumps(parsed, ensure_ascii=False, indent=2),
        "```",
        "",
    ]
    content = "\n".join(body)
    if dry_run:
        return f"[DRY-RUN] {file_path}"
    file_path.write_text(content, encoding="utf-8")
    return str(file_path)


def normalize_assets(parsed: dict[str, Any]) -> dict[str, list[dict[str, Any]]]:
    assets = parsed.get("assets", {}) or {}
    return {
        "title": assets.get("title", []) or [],
        "opening": assets.get("opening", []) or [],
        "quote": assets.get("quotes", []) or [],
        "structure": assets.get("structures", []) or [],
    }


def process_single_article(
    file_path: Path,
    model: str,
    project_root: Path,
    dry_run: bool = False,
    save_full: bool = False,
) -> dict[str, Any]:
    print(f"\n📄 处理文章: {file_path.name}")
    article = read_article(file_path)
    print(f"   标题: {article['title']}")
    print(f"   作者: {article['author']}")
    print(f"   模型: {model}")
    print(f"   项目根目录: {project_root}")

    parsed = call_gemini_json(build_prompt(article), model)
    analysis = parsed.get("analysis", {}) or {}
    parsed_article = parsed.get("article", {}) or {}
    keyword = parsed_article.get("keyword") or article["title"]
    type_dir_map = output_dirs(project_root)

    saved_paths: list[str] = []
    skipped: list[str] = []

    for asset_type, items in normalize_assets(parsed).items():
        for idx, item in enumerate(items, start=1):
            if not item.get("pass"):
                skipped.append(
                    f"{asset_type}:{item.get('zh') or item.get('original') or '未命名'}"
                )
                continue
            saved_paths.append(
                save_asset(
                    asset_type,
                    item,
                    article,
                    analysis,
                    keyword,
                    idx,
                    dry_run,
                    type_dir_map,
                )
            )

    full_analysis_path = None
    if save_full:
        full_analysis_path = save_full_analysis(
            article, parsed, dry_run, full_analysis_dir(project_root, article["body"])
        )

    return {
        "success": True,
        "article": article,
        "parsed": parsed,
        "saved_paths": saved_paths,
        "skipped": skipped,
        "full_analysis_path": full_analysis_path,
    }


def iter_input_files(args: argparse.Namespace) -> list[Path]:
    project_root = resolve_project_root(args.project_root)

    def resolve_input_path(raw: str) -> Path:
        path = Path(raw).expanduser()
        if not path.is_absolute():
            path = project_root / path
        return path.resolve()

    if args.input:
        return [resolve_input_path(args.input)]
    if args.dir:
        dir_path = resolve_input_path(args.dir)
        md_files = sorted(
            dir_path.glob("*.md"), key=lambda p: p.stat().st_mtime, reverse=True
        )
        return md_files[: args.count]
    if args.url_file:
        list_file = resolve_input_path(args.url_file)
        return [
            resolve_input_path(line.strip())
            for line in list_file.read_text(encoding="utf-8").splitlines()
            if line.strip()
        ]
    return []


def main() -> None:
    args = parse_args()
    project_root = resolve_project_root(args.project_root)
    files = iter_input_files(args)
    if not files:
        print("❌ 请指定输入模式：--input、--dir 或 --url-file", file=sys.stderr)
        sys.exit(1)

    total_saved = 0
    for idx, file_path in enumerate(files, start=1):
        if not file_path.exists():
            print(f"⚠️ 跳过不存在的文件：{file_path}")
            continue
        print(f"\n[{idx}/{len(files)}]", end=" ")
        try:
            result = process_single_article(
                file_path,
                args.model,
                project_root,
                args.dry_run,
                args.save_full_analysis,
            )
        except Exception as exc:
            print(f"\n❌ 处理失败：{file_path.name}\n   原因：{exc}")
            continue

        print("   已写入：")
        for path in result["saved_paths"]:
            print(f"   - {path}")
        if result["full_analysis_path"]:
            print(f"   - {result['full_analysis_path']}")
        if result["skipped"]:
            print("   未入库：")
            for item in result["skipped"]:
                print(f"   - {item}")
        total_saved += len(result["saved_paths"])

    print(f"\n✅ 完成，共写入 {total_saved} 个碎片文件")


if __name__ == "__main__":
    main()
