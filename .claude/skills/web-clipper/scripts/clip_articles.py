#!/usr/bin/env python3
import argparse
import json
import html
import re
import ssl
import sys
import urllib.parse
import urllib.request
from dataclasses import dataclass
from datetime import datetime
from html.parser import HTMLParser
from pathlib import Path
from typing import List, Optional

DEFAULT_UA = "Mozilla/5.0 OpenClaw web-clipper"


@dataclass
class Article:
    url: str
    title: str
    description: str
    published: str
    author: str
    body_markdown: str
    archive: Optional[str] = None


class MarkdownParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.out = []
        self.skip = []
        self.list_stack = []
        self.in_blockquote = 0

    def add(self, text: str = ""):
        self.out.append(text)

    def blank(self):
        text = "".join(self.out)
        if not text.endswith("\n\n"):
            self.out.append("\n\n" if not text.endswith("\n") else "\n")

    def handle_starttag(self, tag, attrs):
        if tag in {"script", "style", "iframe", "svg", "path", "button", "form", "input", "noscript"}:
            self.skip.append(tag)
            return
        if self.skip:
            return
        if tag in {"h1", "h2", "h3", "h4"}:
            self.blank()
            self.add("#" * int(tag[1]) + " ")
        elif tag == "blockquote":
            self.blank()
            self.in_blockquote += 1
            self.add("> ")
        elif tag in {"ul", "ol"}:
            self.list_stack.append(tag)
            self.blank()
        elif tag == "li":
            indent = "  " * (len(self.list_stack) - 1)
            bullet = "- " if (not self.list_stack or self.list_stack[-1] == "ul") else "1. "
            self.add(indent + bullet)
        elif tag in {"strong", "b"}:
            self.add("**")
        elif tag in {"em", "i"}:
            self.add("*")
        elif tag == "code":
            self.add("`")
        elif tag == "br":
            self.add("\n")
        elif tag == "hr":
            self.blank()
            self.add("---\n\n")

    def handle_endtag(self, tag):
        if self.skip:
            if tag == self.skip[-1]:
                self.skip.pop()
            return
        if tag in {"h1", "h2", "h3", "h4", "p", "div", "section", "article", "main"}:
            self.blank()
        elif tag == "blockquote":
            self.in_blockquote = max(0, self.in_blockquote - 1)
            self.blank()
        elif tag in {"ul", "ol"}:
            if self.list_stack:
                self.list_stack.pop()
            self.blank()
        elif tag == "li":
            self.add("\n")
        elif tag in {"strong", "b"}:
            self.add("**")
        elif tag in {"em", "i"}:
            self.add("*")
        elif tag == "code":
            self.add("`")

    def handle_data(self, data):
        if self.skip:
            return
        text = html.unescape(re.sub(r"\s+", " ", data or ""))
        if not text.strip():
            return
        if text.strip() in {"Subscribe", "Sign in", "Share", "Link", "Close", "close"}:
            return
        if self.in_blockquote:
            prev = "".join(self.out)
            if prev.endswith("\n"):
                self.add("> ")
        self.add(text)

    def markdown(self):
        text = "".join(self.out)
        text = re.sub(r"\n{3,}", "\n\n", text)
        text = re.sub(r" +\n", "\n", text)
        lines = [ln.rstrip() for ln in text.splitlines()]
        cleaned = []
        prev = None
        for ln in lines:
            s = ln.strip()
            if not s:
                if cleaned and cleaned[-1] != "":
                    cleaned.append("")
                prev = ""
                continue
            if s == prev and (s.startswith("> ") or s.startswith("- ") or s.startswith("1. ")):
                continue
            if s.startswith("Like (") or s.startswith("View comments") or s in {"Share", "Subscribe", "Sign in"}:
                continue
            cleaned.append(ln)
            prev = s
        while cleaned and cleaned[-1] == "":
            cleaned.pop()
        return "\n".join(cleaned).strip() + "\n"


class Clipper:
    def __init__(self, timeout: int = 40, user_agent: str = DEFAULT_UA):
        self.timeout = timeout
        self.ctx = ssl.create_default_context()
        self.user_agent = user_agent

    def fetch(self, url: str) -> str:
        req = urllib.request.Request(url, headers={"User-Agent": self.user_agent})
        with urllib.request.urlopen(req, context=self.ctx, timeout=self.timeout) as r:
            return r.read().decode("utf-8", errors="ignore")

    def absolute_url(self, base: str, href: str) -> str:
        return urllib.parse.urljoin(base, href)

    def extract_links(self, page_url: str, html_text: str, count: int, same_origin_only: bool = True, link_pattern: Optional[str] = None) -> List[str]:
        hrefs = re.findall(r'href=\\?"([^\"]+)\\?"', html_text)
        urls = []
        base_host = urllib.parse.urlparse(page_url).netloc
        for href in hrefs:
            full = self.absolute_url(page_url, href)
            if any(x in full for x in ["/comments", "#comments", "/podcast/"]):
                continue
            parsed = urllib.parse.urlparse(full)
            if parsed.scheme not in {"http", "https"}:
                continue
            if same_origin_only and parsed.netloc != base_host:
                continue
            if link_pattern and not re.search(link_pattern, full):
                continue
            if not link_pattern:
                path = parsed.path or ""
                if path in {"", "/"}:
                    continue
                # bias toward article-like URLs
                if path.count("/") < 2:
                    continue
            if full not in urls:
                urls.append(full)
            if len(urls) >= count:
                break
        return urls

    def extract_json_escaped_field(self, html_text: str, field: str) -> Optional[str]:
        marker = f'{field}\\":\\"'
        start = html_text.find(marker)
        if start == -1:
            return None
        i = start + len(marker)
        buf = []
        while i < len(html_text):
            ch = html_text[i]
            if ch == '"':
                bs = 0
                j = i - 1
                while j >= 0 and html_text[j] == "\\":
                    bs += 1
                    j -= 1
                if bs % 2 == 0:
                    break
            buf.append(ch)
            i += 1
        try:
            return json.loads('"' + ''.join(buf) + '"')
        except Exception:
            return None

    def extract_meta(self, html_text: str, prop: str = None, name: str = None) -> str:
        if prop:
            m = re.search(rf'<meta[^>]+property="{re.escape(prop)}"[^>]+content="([^"]+)"', html_text, re.I)
            if m:
                return html.unescape(m.group(1)).strip()
        if name:
            m = re.search(rf'<meta[^>]+name="{re.escape(name)}"[^>]+content="([^"]+)"', html_text, re.I)
            if m:
                return html.unescape(m.group(1)).strip()
        return ""

    def extract_json_ld(self, html_text: str) -> List[dict]:
        blocks = re.findall(r'<script[^>]+type="application/ld\+json"[^>]*>(.*?)</script>', html_text, re.I | re.S)
        docs = []
        for block in blocks:
            raw = block.strip()
            if not raw:
                continue
            try:
                data = json.loads(raw)
                if isinstance(data, list):
                    docs.extend([x for x in data if isinstance(x, dict)])
                elif isinstance(data, dict):
                    docs.append(data)
            except Exception:
                continue
        return docs

    def parse_article(self, url: str, archive: Optional[str] = None) -> Article:
        html_text = self.fetch(url)
        title = self.extract_meta(html_text, prop="og:title") or self.extract_meta(html_text, name="twitter:title")
        description = self.extract_meta(html_text, name="description") or self.extract_meta(html_text, prop="og:description")
        published = ""
        author = self.extract_meta(html_text, name="author")

        for field in ["datePublished", "date_created", "post_date"]:
            m = re.search(rf'"{field}":"([^"]+)"', html_text)
            if m:
                published = m.group(1)[:10]
                break

        for doc in self.extract_json_ld(html_text):
            t = doc.get("@type")
            types = t if isinstance(t, list) else [t]
            if any(x in {"Article", "NewsArticle", "BlogPosting"} for x in types):
                title = title or doc.get("headline") or ""
                description = description or doc.get("description") or ""
                date = doc.get("datePublished") or doc.get("dateCreated") or ""
                if date and not published:
                    published = str(date)[:10]
                if not author:
                    a = doc.get("author")
                    if isinstance(a, dict):
                        author = a.get("name") or ""
                    elif isinstance(a, list) and a and isinstance(a[0], dict):
                        author = a[0].get("name") or ""

        body_html = None
        for field in ["body_html", "articleBody"]:
            body_html = self.extract_json_escaped_field(html_text, field)
            if body_html:
                break

        if not body_html:
            m = re.search(r'<article[^>]*>(.*?)</article>', html_text, re.I | re.S)
            if not m:
                m = re.search(r'<main[^>]*>(.*?)</main>', html_text, re.I | re.S)
            if m:
                body_html = m.group(1)

        if not body_html:
            raise RuntimeError("article body not found")

        parser = MarkdownParser()
        parser.feed(body_html)
        body_markdown = parser.markdown()

        title = title or urllib.parse.urlparse(url).path.rstrip("/").split("/")[-1].replace("-", " ")
        published = published or "unknown-date"
        author = author or "Unknown"

        return Article(
            url=url,
            title=title,
            description=description,
            published=published,
            author=author,
            body_markdown=body_markdown,
            archive=archive,
        )


def clean_filename(name: str) -> str:
    name = re.sub(r'[\\/:*?"<>|]', ' - ', name)
    name = re.sub(r'\s+', ' ', name).strip()
    return name[:180]


def render_markdown(article: Article, clipped_at: str, tags: List[str]) -> str:
    frontmatter = {
        "title": article.title,
        "author": article.author,
        "source": article.url,
        "published": article.published,
        "clipped": clipped_at,
        "tags": tags,
    }
    if article.archive:
        frontmatter["archive"] = article.archive

    lines = ["---"]
    for key in ["title", "author", "source", "archive", "published", "clipped"]:
        if key in frontmatter:
            lines.append(f"{key}: {json.dumps(frontmatter[key], ensure_ascii=False)}")
    lines.append("tags:")
    for tag in frontmatter["tags"]:
        lines.append(f"  - {tag}")
    lines.append("---\n")
    lines.append(f"# {article.title}\n")
    if article.description:
        lines.append(f"> {article.description}\n")
    lines.append(article.body_markdown)
    return "\n".join(lines).rstrip() + "\n"


def write_article(article: Article, output_dir: Path, clipped_at: str, tags: List[str]) -> Path:
    output_dir.mkdir(parents=True, exist_ok=True)
    filename = f"{article.published} {clean_filename(article.title)}.md"
    path = output_dir / filename
    path.write_text(render_markdown(article, clipped_at, tags), encoding="utf-8")
    return path


def load_url_file(path: Path) -> List[str]:
    urls = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        urls.append(line)
    return urls


def main():
    ap = argparse.ArgumentParser(description="Clip one or more web articles to Markdown")
    ap.add_argument("--mode", choices=["single", "batch"], required=True)
    ap.add_argument("--url", help="article URL or index/archive page URL")
    ap.add_argument("--url-file", help="text file with one article URL per line")
    ap.add_argument("--output-dir", required=True)
    ap.add_argument("--count", type=int, default=1)
    ap.add_argument("--link-pattern", default=None, help="regex to identify article links on batch pages")
    ap.add_argument("--same-origin-only", action="store_true", default=False)
    ap.add_argument("--author", default=None, help="force author name")
    ap.add_argument("--tag", action="append", default=[])
    ap.add_argument("--summary-json", default=None, help="where to save run summary json")
    args = ap.parse_args()

    if not args.url and not args.url_file:
        print("Need --url or --url-file", file=sys.stderr)
        sys.exit(2)

    clipper = Clipper()
    output_dir = Path(args.output_dir).expanduser()
    clipped_at = datetime.now().astimezone().replace(microsecond=0).isoformat()
    tags = ["clipping"] + [t for t in args.tag if t]

    if args.url_file:
        urls = load_url_file(Path(args.url_file).expanduser())
        archive_url = args.url if args.mode == "batch" else None
    elif args.mode == "single":
        urls = [args.url]
        archive_url = None
    else:
        page_url = args.url
        html_text = clipper.fetch(page_url)
        urls = clipper.extract_links(
            page_url,
            html_text,
            count=args.count,
            same_origin_only=args.same_origin_only,
            link_pattern=args.link_pattern,
        )
        archive_url = page_url

    if args.mode == "single":
        urls = urls[:1]
    else:
        urls = urls[: args.count]

    results = []
    success = 0
    failed = 0
    for idx, url in enumerate(urls, 1):
        try:
            article = clipper.parse_article(url, archive=archive_url)
            if args.author:
                article.author = args.author
            path = write_article(article, output_dir, clipped_at, tags)
            results.append({"index": idx, "ok": True, "title": article.title, "url": url, "path": str(path)})
            success += 1
            print(f"OK {idx:02d} {article.title}\t{path}")
        except Exception as e:
            results.append({"index": idx, "ok": False, "url": url, "error": str(e)})
            failed += 1
            print(f"ERR {idx:02d} {url}\t{e}", file=sys.stderr)

    summary = {
        "mode": args.mode,
        "source": args.url,
        "count_requested": args.count,
        "count_attempted": len(urls),
        "success": success,
        "failed": failed,
        "results": results,
    }

    if args.summary_json:
        Path(args.summary_json).expanduser().write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    if failed and success == 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
