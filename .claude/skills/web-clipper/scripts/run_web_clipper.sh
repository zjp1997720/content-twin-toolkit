#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP="$SCRIPT_DIR/bootstrap.sh"
CLIPPER="$SCRIPT_DIR/clip_articles.py"
PROJECT_ROOT="${WEB_CLIPPER_PROJECT_ROOT:-$(pwd)}"
CONFIG_FILE="${PROJECT_ROOT}/.web-clipper/EXTEND.md"

ARGS=()
OUTPUT_DIR=""
NEEDS_VALUE=0

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

load_default_output_dir() {
  if [ -f "$CONFIG_FILE" ]; then
    local saved
    saved="$(grep '^default_output_dir:' "$CONFIG_FILE" | head -n 1 | cut -d':' -f2- | sed 's/^ *//')"
    saved="${saved#\"}"
    saved="${saved%\"}"
    if [ -n "$saved" ] && saved="$(normalize_relative_path "$saved")"; then
      printf '%s\n' "$saved"
      return 0
    fi
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

for arg in "$@"; do
  if [ "$NEEDS_VALUE" -eq 1 ]; then
    OUTPUT_DIR="$arg"
    NEEDS_VALUE=0
    ARGS+=("$arg")
    continue
  fi

  case "$arg" in
    --output-dir)
      NEEDS_VALUE=1
      ARGS+=("$arg")
      ;;
    --output-dir=*)
      OUTPUT_DIR="${arg#*=}"
      ARGS+=("$arg")
      ;;
    *)
      ARGS+=("$arg")
      ;;
  esac
done

if [ "$NEEDS_VALUE" -eq 1 ]; then
  printf '%s\n' "--output-dir 需要一个值" >&2
  exit 2
fi

if [ -z "$OUTPUT_DIR" ]; then
  OUTPUT_DIR="$(load_default_output_dir)"
  ARGS+=("--output-dir" "$OUTPUT_DIR")
elif ! OUTPUT_DIR="$(normalize_relative_path "$OUTPUT_DIR")"; then
  printf '%s\n' "--output-dir 必须是当前项目内的相对路径" >&2
  exit 2
fi

bash "$BOOTSTRAP" --output-dir "$OUTPUT_DIR"
PYTHON_CMD="$(detect_python_command)"
exec "$PYTHON_CMD" "$CLIPPER" "${ARGS[@]}"
