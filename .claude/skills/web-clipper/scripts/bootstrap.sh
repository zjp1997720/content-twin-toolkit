#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="${WEB_CLIPPER_PROJECT_ROOT:-$(pwd)}"
CONFIG_DIR="${PROJECT_ROOT}/.web-clipper"
CONFIG_FILE="${CONFIG_DIR}/EXTEND.md"

AUTO_INSTALL=1
CHECK_ONLY=0
OUTPUT_DIR=""

log() {
  printf '%s\n' "$1"
}

pass() {
  printf '  [OK] %s\n' "$1"
}

warn() {
  printf '  [WARN] %s\n' "$1"
}

fail() {
  printf '  [FAIL] %s\n' "$1" >&2
}

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [--output-dir PATH] [--check-only] [--no-auto-install]

Checks the local runtime required by web-clipper.
If Python 3 is missing, tries to install it with an available package manager.
All generated config stays inside the current project root.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --output-dir)
      if [ $# -lt 2 ]; then
        fail "--output-dir needs a value"
        exit 2
      fi
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --output-dir=*)
      OUTPUT_DIR="${1#*=}"
      shift
      ;;
    --check-only)
      CHECK_ONLY=1
      shift
      ;;
    --no-auto-install)
      AUTO_INSTALL=0
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      shift
      ;;
  esac
done

expand_path() {
  local raw="$1"
  if [ -z "$raw" ]; then
    return 0
  fi

  if [ "${raw#~/}" != "$raw" ]; then
    printf '%s\n' "${HOME}/${raw#~/}"
    return 0
  fi

  if [ "${raw#/}" != "$raw" ]; then
    printf '%s\n' "$raw"
    return 0
  fi

  printf '%s\n' "${PROJECT_ROOT}/$raw"
}

normalize_relative_path() {
  local raw="$1"

  if [ -z "$raw" ]; then
    return 1
  fi

  if [ "${raw#${PROJECT_ROOT}/}" != "$raw" ]; then
    raw="${raw#${PROJECT_ROOT}/}"
  fi

  raw="${raw#./}"

  case "$raw" in
    /*|~*)
      return 1
      ;;
  esac

  case "/$raw/" in
    */../*|*/./*)
      return 1
      ;;
  esac

  if [ "$raw" = "." ] || [ "$raw" = ".." ]; then
    return 1
  fi

  printf '%s\n' "$raw"
}

resolve_output_dir() {
  local raw="$1"
  local normalized

  if ! normalized="$(normalize_relative_path "$raw")"; then
    return 1
  fi

  printf '%s\n' "${PROJECT_ROOT}/${normalized}"
}

read_saved_output_dir() {
  if [ ! -f "$CONFIG_FILE" ]; then
    return 1
  fi

  local saved
  saved="$(grep '^default_output_dir:' "$CONFIG_FILE" | head -n 1 | cut -d':' -f2- | sed 's/^ *//')"
  saved="${saved#\"}"
  saved="${saved%\"}"

  if [ -z "$saved" ]; then
    return 1
  fi

  normalize_relative_path "$saved"
}

default_output_dir() {
  local normalized

  if [ -n "$OUTPUT_DIR" ]; then
    if normalized="$(normalize_relative_path "$OUTPUT_DIR")"; then
      printf '%s\n' "$normalized"
      return 0
    fi

    warn "输出目录超出当前项目边界，回退到默认 clipping 目录"
  fi

  if normalized="$(read_saved_output_dir)"; then
    printf '%s\n' "$normalized"
    return 0
  fi

  if [ -d "${PROJECT_ROOT}/00_收件箱/Clippings" ] || [ -d "${PROJECT_ROOT}/00_收件箱" ]; then
    printf '%s\n' "00_收件箱/Clippings"
    return 0
  fi

  printf '%s\n' "Clippings"
}

detect_python_command() {
  if command -v python3 >"${PROJECT_ROOT}/.web-clipper-python3-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-python3-check.log"
    printf '%s\n' "python3"
    return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-python3-check.log"

  if command -v python >"${PROJECT_ROOT}/.web-clipper-python-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-python-check.log"
    if python -c 'import sys; raise SystemExit(0 if sys.version_info.major >= 3 else 1)' >"${PROJECT_ROOT}/.web-clipper-python-version.log" 2>&1; then
      rm -f "${PROJECT_ROOT}/.web-clipper-python-version.log"
      printf '%s\n' "python"
      return 0
    fi
    rm -f "${PROJECT_ROOT}/.web-clipper-python-version.log"
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-python-check.log"
  return 1
}

can_use_sudo_noninteractive() {
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi

  if ! command -v sudo >"${PROJECT_ROOT}/.web-clipper-sudo-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-sudo-check.log"
    return 1
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-sudo-check.log"

  if sudo -n true >"${PROJECT_ROOT}/.web-clipper-sudo-ready.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-sudo-ready.log"
    return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-sudo-ready.log"
  return 1
}

run_elevated() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
    return 0
  fi

  sudo -n "$@"
}

install_python() {
  if [ "$AUTO_INSTALL" -ne 1 ]; then
    return 1
  fi

  log "  -> 尝试自动安装 Python 3"

  if command -v brew >"${PROJECT_ROOT}/.web-clipper-brew-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-brew-check.log"
    brew install python && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-brew-check.log"

  if ! can_use_sudo_noninteractive; then
    warn "当前环境无法免交互提权，跳过 apt/dnf/yum/pacman 自动安装"
    return 1
  fi

  if command -v apt-get >"${PROJECT_ROOT}/.web-clipper-apt-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-apt-check.log"
    run_elevated apt-get update && run_elevated apt-get install -y python3 && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-apt-check.log"

  if command -v dnf >"${PROJECT_ROOT}/.web-clipper-dnf-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-dnf-check.log"
    run_elevated dnf install -y python3 && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-dnf-check.log"

  if command -v yum >"${PROJECT_ROOT}/.web-clipper-yum-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-yum-check.log"
    run_elevated yum install -y python3 && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-yum-check.log"

  if command -v pacman >"${PROJECT_ROOT}/.web-clipper-pacman-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-pacman-check.log"
    run_elevated pacman -Sy --noconfirm python && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-pacman-check.log"

  if command -v winget >"${PROJECT_ROOT}/.web-clipper-winget-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-winget-check.log"
    winget install -e --id Python.Python.3.12 && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-winget-check.log"

  if command -v choco >"${PROJECT_ROOT}/.web-clipper-choco-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-choco-check.log"
    choco install -y python && return 0
  fi
  rm -f "${PROJECT_ROOT}/.web-clipper-choco-check.log"

  return 1
}

write_default_config() {
  local relative_output_dir="$1"

  mkdir -p "$CONFIG_DIR"
  if [ -f "$CONFIG_FILE" ]; then
    return 0
  fi

  cat > "$CONFIG_FILE" <<EOF
version: 1
skill_root: "$SKILL_ROOT"
project_root: "$PROJECT_ROOT"
default_output_dir: "$relative_output_dir"
auto_create_output_dir: true
auto_install_python: true
browser_fallback_enabled: true
EOF

  pass "首次配置已写入 $CONFIG_FILE"
}

main() {
  local relative_output_dir
  local resolved_output_dir
  local python_cmd=""

  log "========================================"
  log "Web Clipper Bootstrap"
  log "========================================"
  log ""

  relative_output_dir="$(default_output_dir)"
  resolved_output_dir="$(resolve_output_dir "$relative_output_dir")"

  log "1. 检查 Python 3 ..."
  if python_cmd="$(detect_python_command)"; then
    pass "检测到 $python_cmd ($($python_cmd --version 2>&1))"
  else
    warn "未检测到可用的 Python 3"
    if install_python; then
      if python_cmd="$(detect_python_command)"; then
        pass "Python 3 自动安装完成 ($($python_cmd --version 2>&1))"
        warn "如果你是在 Windows 或刚装完 Python 的新 shell 环境里，仍可能需要重开终端后再运行一次。"
      else
        fail "安装流程返回成功，但当前 shell 还没检测到 Python 3"
        log "  请重开终端后重新运行 Web Clipper。"
        exit 1
      fi
    else
      fail "无法自动安装 Python 3"
      log "  请先手动安装 Python 3，再重新运行 Web Clipper。"
      log "  macOS 推荐：brew install python"
      log "  Windows 推荐：winget install -e --id Python.Python.3.12"
      log "  Linux 推荐：使用系统包管理器安装 python3"
      exit 1
    fi
  fi
  log ""

  log "2. 检查运行脚本 ..."
  if [ -f "$SCRIPT_DIR/clip_articles.py" ]; then
    pass "找到主脚本 clip_articles.py"
  else
    fail "缺少主脚本 $SCRIPT_DIR/clip_articles.py"
    exit 1
  fi
  log ""

  log "3. 检查输出目录 ..."
  if [ -d "$resolved_output_dir" ]; then
    pass "输出目录已存在: $resolved_output_dir"
  elif [ "$CHECK_ONLY" -eq 1 ]; then
    warn "输出目录不存在: $resolved_output_dir"
  else
    mkdir -p "$resolved_output_dir"
    pass "已创建输出目录: $resolved_output_dir"
  fi
  log ""

  log "4. 检查浏览器增强能力 ..."
  if [ -d "/Applications/Google Chrome.app" ] || [ -d "/Applications/Chromium.app" ] || command -v google-chrome >"${PROJECT_ROOT}/.web-clipper-browser-check.log" 2>&1 || command -v chromium >"${PROJECT_ROOT}/.web-clipper-browser-check.log" 2>&1 || command -v chromium-browser >"${PROJECT_ROOT}/.web-clipper-browser-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.web-clipper-browser-check.log"
    pass "检测到浏览器，可用于懒加载页面补链路"
  else
    rm -f "${PROJECT_ROOT}/.web-clipper-browser-check.log"
    warn "未检测到 Chrome/Chromium；静态抓取仍可正常使用"
  fi
  log ""

  if [ "$CHECK_ONLY" -ne 1 ]; then
    write_default_config "$relative_output_dir"
    log ""
    log "下一步："
    log "- 直接继续运行 Web Clipper 即可"
    log "- 如需修改默认目录，编辑 $CONFIG_FILE"
  fi
}

main
