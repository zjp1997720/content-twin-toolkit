#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT_RAW="${CONTENT_GOLDMINE_PROJECT_ROOT:-$(pwd)}"
PROJECT_ROOT=""
CONFIG_DIR=""
CONFIG_FILE=""
LOG_DIR=""

AUTO_INSTALL=1
CHECK_ONLY=0
MODEL="gemini-3-flash-preview"

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
Usage: bootstrap.sh [--check-only] [--no-auto-install] [--model MODEL]

Checks the local runtime required by content-goldmine-gemini.
It validates Python 3, Gemini CLI, first-run auth hints, and project-local output directories.
All generated config stays inside the current project root.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --check-only)
      CHECK_ONLY=1
      shift
      ;;
    --no-auto-install)
      AUTO_INSTALL=0
      shift
      ;;
    --model)
      if [ $# -lt 2 ]; then
        fail "--model needs a value"
        exit 2
      fi
      MODEL="$2"
      shift 2
      ;;
    --model=*)
      MODEL="${1#*=}"
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

prepare_log_dir() {
  mkdir -p "$LOG_DIR"
}

validate_project_root() {
  local candidate="$PROJECT_ROOT_RAW"

  if [ -z "$candidate" ]; then
    fail "项目根目录不能为空"
    exit 1
  fi

  if [ ! -d "$candidate" ]; then
    fail "项目根目录不存在或不是文件夹：$candidate"
    exit 1
  fi

  PROJECT_ROOT="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$candidate")"
  CONFIG_DIR="${PROJECT_ROOT}/.content-goldmine-gemini"
  CONFIG_FILE="${CONFIG_DIR}/EXTEND.md"
  LOG_DIR="${CONFIG_DIR}/.logs"
}

detect_python_command() {
  if command -v python3 >"${LOG_DIR}/python3-check.log" 2>&1; then
    rm -f "${LOG_DIR}/python3-check.log"
    printf '%s\n' "python3"
    return 0
  fi
  rm -f "${LOG_DIR}/python3-check.log"

  if command -v python >"${LOG_DIR}/python-check.log" 2>&1; then
    rm -f "${LOG_DIR}/python-check.log"
    if python -c 'import sys; raise SystemExit(0 if sys.version_info.major >= 3 else 1)' >"${LOG_DIR}/python-version.log" 2>&1; then
      rm -f "${LOG_DIR}/python-version.log"
      printf '%s\n' "python"
      return 0
    fi
    rm -f "${LOG_DIR}/python-version.log"
  fi
  rm -f "${LOG_DIR}/python-check.log"
  return 1
}

detect_gemini_command() {
  if command -v gemini >"${LOG_DIR}/gemini-check.log" 2>&1; then
    rm -f "${LOG_DIR}/gemini-check.log"
    printf '%s\n' "gemini"
    return 0
  fi
  rm -f "${LOG_DIR}/gemini-check.log"
  return 1
}

can_use_sudo_noninteractive() {
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi

  if ! command -v sudo >"${LOG_DIR}/sudo-check.log" 2>&1; then
    rm -f "${LOG_DIR}/sudo-check.log"
    return 1
  fi
  rm -f "${LOG_DIR}/sudo-check.log"

  if sudo -n true >"${LOG_DIR}/sudo-ready.log" 2>&1; then
    rm -f "${LOG_DIR}/sudo-ready.log"
    return 0
  fi
  rm -f "${LOG_DIR}/sudo-ready.log"
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

  if command -v brew >"${LOG_DIR}/brew-check.log" 2>&1; then
    rm -f "${LOG_DIR}/brew-check.log"
    brew install python && return 0
  fi
  rm -f "${LOG_DIR}/brew-check.log"

  if ! can_use_sudo_noninteractive; then
    warn "当前环境无法免交互提权，跳过 apt/dnf/yum/pacman 自动安装"
    return 1
  fi

  if command -v apt-get >"${LOG_DIR}/apt-check.log" 2>&1; then
    rm -f "${LOG_DIR}/apt-check.log"
    run_elevated apt-get update && run_elevated apt-get install -y python3 && return 0
  fi
  rm -f "${LOG_DIR}/apt-check.log"

  if command -v dnf >"${LOG_DIR}/dnf-check.log" 2>&1; then
    rm -f "${LOG_DIR}/dnf-check.log"
    run_elevated dnf install -y python3 && return 0
  fi
  rm -f "${LOG_DIR}/dnf-check.log"

  if command -v yum >"${LOG_DIR}/yum-check.log" 2>&1; then
    rm -f "${LOG_DIR}/yum-check.log"
    run_elevated yum install -y python3 && return 0
  fi
  rm -f "${LOG_DIR}/yum-check.log"

  if command -v pacman >"${LOG_DIR}/pacman-check.log" 2>&1; then
    rm -f "${LOG_DIR}/pacman-check.log"
    run_elevated pacman -Sy --noconfirm python && return 0
  fi
  rm -f "${LOG_DIR}/pacman-check.log"

  if command -v winget >"${LOG_DIR}/winget-check.log" 2>&1; then
    rm -f "${LOG_DIR}/winget-check.log"
    winget install -e --id Python.Python.3.12 && return 0
  fi
  rm -f "${LOG_DIR}/winget-check.log"

  if command -v choco >"${LOG_DIR}/choco-check.log" 2>&1; then
    rm -f "${LOG_DIR}/choco-check.log"
    choco install -y python && return 0
  fi
  rm -f "${LOG_DIR}/choco-check.log"

  return 1
}

install_gemini() {
  if [ "$AUTO_INSTALL" -ne 1 ]; then
    return 1
  fi

  log "  -> 尝试自动安装 Gemini CLI"

  if command -v brew >"${LOG_DIR}/brew-check.log" 2>&1; then
    rm -f "${LOG_DIR}/brew-check.log"
    brew install gemini-cli && return 0
  fi
  rm -f "${LOG_DIR}/brew-check.log"

  if command -v npm >"${LOG_DIR}/npm-check.log" 2>&1; then
    rm -f "${LOG_DIR}/npm-check.log"
    npm install -g @google/gemini-cli && return 0
  fi
  rm -f "${LOG_DIR}/npm-check.log"

  return 1
}

write_default_config() {
  mkdir -p "$CONFIG_DIR"
  if [ -f "$CONFIG_FILE" ]; then
    return 0
  fi

  cat > "$CONFIG_FILE" <<EOF
version: 1
skill_root: "$SKILL_ROOT"
project_root: "$PROJECT_ROOT"
default_model: "$MODEL"
title_dir: "02_素材库/灵感素材/标题"
opening_dir: "02_素材库/灵感素材/开头"
quote_dir: "02_素材库/灵感素材/金句"
structure_dir: "02_素材库/灵感素材/结构"
full_analysis_long_dir: "02_素材库/高表现内容/长文"
full_analysis_short_dir: "02_素材库/高表现内容/短图文"
auto_install_python: true
auto_install_gemini_cli: true
preferred_auth: "google-login"
EOF

  pass "首次配置已写入 $CONFIG_FILE"
}

ensure_project_dirs() {
  local dirs
  dirs=(
    "02_素材库/灵感素材/标题"
    "02_素材库/灵感素材/开头"
    "02_素材库/灵感素材/金句"
    "02_素材库/灵感素材/结构"
    "02_素材库/高表现内容/长文"
    "02_素材库/高表现内容/短图文"
  )

  for dir in "${dirs[@]}"; do
    if [ "$CHECK_ONLY" -eq 1 ]; then
      if [ -d "$PROJECT_ROOT/$dir" ]; then
        pass "目录已存在: $PROJECT_ROOT/$dir"
      else
        warn "目录不存在: $PROJECT_ROOT/$dir"
      fi
    else
      mkdir -p "$PROJECT_ROOT/$dir"
      pass "目录可用: $PROJECT_ROOT/$dir"
    fi
  done
}

check_gemini_auth() {
  local gemini_cmd="$1"
  local auth_hint=""

  if [ -n "${GEMINI_API_KEY:-}" ]; then
    auth_hint="检测到 GEMINI_API_KEY，将验证 API Key 是否可用"
  elif [ -n "${GOOGLE_API_KEY:-}" ] && [ "${GOOGLE_GENAI_USE_VERTEXAI:-}" = "true" ]; then
    auth_hint="检测到 Vertex AI 认证环境变量，将验证 Vertex AI 认证是否可用"
  fi

  if [ -n "$auth_hint" ]; then
    pass "$auth_hint"
  fi

  if [ -f "$HOME/.gemini/settings.json" ]; then
    pass "检测到 ~/.gemini/settings.json，可能已完成登录缓存"
  else
    warn "尚未发现 Gemini 登录缓存"
  fi

  if "$gemini_cmd" -p "Reply with OK" --output-format json >"${LOG_DIR}/gemini-auth-test.log" 2>&1; then
    rm -f "${LOG_DIR}/gemini-auth-test.log"
    pass "Gemini CLI 认证可用"
    return 0
  fi

  warn "Gemini CLI 已安装，但当前还不能直接完成请求"
  log "  请先运行：gemini"
  log "  然后选择：Sign in with Google"
  log "  如果你更想用 API Key，也可以先配置 GEMINI_API_KEY，再重新运行本 skill。"
  log "  如果当前环境打不开浏览器，可先设置：NO_BROWSER=true"
  rm -f "${LOG_DIR}/gemini-auth-test.log"
  return 1
}

main() {
  local python_cmd=""
  local gemini_cmd=""

  log "========================================"
  log "Content Goldmine Gemini Bootstrap"
  log "========================================"
  log ""

  validate_project_root
  prepare_log_dir
  pass "当前项目根目录: $PROJECT_ROOT"
  log ""

  log "1. 检查 Python 3 ..."
  if python_cmd="$(detect_python_command)"; then
    pass "检测到 $python_cmd ($($python_cmd --version 2>&1))"
  else
    warn "未检测到可用的 Python 3"
    if install_python; then
      if python_cmd="$(detect_python_command)"; then
        pass "Python 3 自动安装完成 ($($python_cmd --version 2>&1))"
      else
        fail "安装流程返回成功，但当前 shell 还没检测到 Python 3"
        exit 1
      fi
    else
      fail "无法自动安装 Python 3"
      log "  macOS 推荐：brew install python"
      log "  Windows 推荐：winget install -e --id Python.Python.3.12"
      log "  Linux 推荐：使用系统包管理器安装 python3"
      exit 1
    fi
  fi
  log ""

  log "2. 检查 Gemini CLI ..."
  if gemini_cmd="$(detect_gemini_command)"; then
    pass "检测到 $gemini_cmd ($($gemini_cmd --version 2>&1))"
  else
    warn "未检测到 Gemini CLI"
    if install_gemini; then
      if gemini_cmd="$(detect_gemini_command)"; then
        pass "Gemini CLI 自动安装完成 ($($gemini_cmd --version 2>&1))"
      else
        fail "安装流程返回成功，但当前 shell 还没检测到 Gemini CLI"
        log "  请重开终端后重新运行本 skill。"
        exit 1
      fi
    else
      fail "无法自动安装 Gemini CLI"
      log "  推荐安装方式："
      log "  - npm install -g @google/gemini-cli"
      log "  - 或 brew install gemini-cli"
      exit 1
    fi
  fi
  log ""

  log "3. 检查主脚本 ..."
  if [ -f "$SCRIPT_DIR/process_goldmine.py" ]; then
    pass "找到主脚本 process_goldmine.py"
  else
    fail "缺少主脚本 $SCRIPT_DIR/process_goldmine.py"
    exit 1
  fi
  log ""

  log "4. 检查项目素材库目录 ..."
  ensure_project_dirs
  log ""

  if [ "$CHECK_ONLY" -ne 1 ]; then
    write_default_config
    log ""
  fi

  log "5. 检查 Gemini 登录状态 ..."
  if ! check_gemini_auth "$gemini_cmd"; then
    if [ "$CHECK_ONLY" -eq 1 ]; then
      warn "当前是 check-only 模式，继续输出引导信息"
    else
      fail "Gemini CLI 还没有完成可用认证"
      exit 1
    fi
  fi
  log ""

  if [ "$CHECK_ONLY" -ne 1 ]; then
    log "下一步："
    log "- 后续统一运行 scripts/run_content_goldmine.sh"
    log "- 如需调整默认模型或目录，编辑 $CONFIG_FILE"
  fi
}

main
