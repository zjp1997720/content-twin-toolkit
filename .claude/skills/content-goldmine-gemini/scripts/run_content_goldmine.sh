#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP="$SCRIPT_DIR/bootstrap.sh"
PROCESSOR="$SCRIPT_DIR/process_goldmine.py"
PROJECT_ROOT_RAW="${CONTENT_GOLDMINE_PROJECT_ROOT:-$(pwd)}"
PROJECT_ROOT=""
CONFIG_FILE=""
MODEL=""
ARGS=()
NEEDS_MODEL=0

validate_project_root() {
  local candidate="$PROJECT_ROOT_RAW"

  if [ -z "$candidate" ]; then
    printf '%s\n' "项目根目录不能为空" >&2
    exit 1
  fi

  if [ ! -d "$candidate" ]; then
    printf '%s\n' "项目根目录不存在或不是文件夹：$candidate" >&2
    exit 1
  fi

  PROJECT_ROOT="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$candidate")"
  CONFIG_FILE="${PROJECT_ROOT}/.content-goldmine-gemini/EXTEND.md"
}

detect_python_command() {
  if command -v python3 >"${PROJECT_ROOT}/.content-goldmine-python3-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.content-goldmine-python3-check.log"
    printf '%s\n' "python3"
    return 0
  fi
  rm -f "${PROJECT_ROOT}/.content-goldmine-python3-check.log"

  if command -v python >"${PROJECT_ROOT}/.content-goldmine-python-check.log" 2>&1; then
    rm -f "${PROJECT_ROOT}/.content-goldmine-python-check.log"
    if python -c 'import sys; raise SystemExit(0 if sys.version_info.major >= 3 else 1)' >"${PROJECT_ROOT}/.content-goldmine-python-version.log" 2>&1; then
      rm -f "${PROJECT_ROOT}/.content-goldmine-python-version.log"
      printf '%s\n' "python"
      return 0
    fi
    rm -f "${PROJECT_ROOT}/.content-goldmine-python-version.log"
  fi
  rm -f "${PROJECT_ROOT}/.content-goldmine-python-check.log"
  return 1
}

load_default_model() {
  if [ -f "$CONFIG_FILE" ]; then
    local saved
    saved="$(grep '^default_model:' "$CONFIG_FILE" | head -n 1 | cut -d':' -f2- | sed 's/^ *//')"
    saved="${saved#\"}"
    saved="${saved%\"}"
    if [ -n "$saved" ]; then
      printf '%s\n' "$saved"
      return 0
    fi
  fi

  printf '%s\n' "gemini-3-flash-preview"
}

for arg in "$@"; do
  if [ "$NEEDS_MODEL" -eq 1 ]; then
    MODEL="$arg"
    ARGS+=("$arg")
    NEEDS_MODEL=0
    continue
  fi

  case "$arg" in
    --model)
      NEEDS_MODEL=1
      ARGS+=("$arg")
      ;;
    --model=*)
      MODEL="${arg#*=}"
      ARGS+=("$arg")
      ;;
    *)
      ARGS+=("$arg")
      ;;
  esac
done

validate_project_root

if [ "$NEEDS_MODEL" -eq 1 ]; then
  printf '%s\n' "--model 需要一个值" >&2
  exit 2
fi

if [ -z "$MODEL" ]; then
  MODEL="$(load_default_model)"
  ARGS+=("--model" "$MODEL")
fi

bash "$BOOTSTRAP" --model "$MODEL"
PYTHON_CMD="$(detect_python_command)"
exec "$PYTHON_CMD" "$PROCESSOR" --project-root "$PROJECT_ROOT" "${ARGS[@]}"
