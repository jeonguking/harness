#!/usr/bin/env bash
# AGENTS.md 맵 유효성: AGENTS.md의 리포지터리 구조 블록에 나열된 파일/디렉터리가
# 실제로 존재하는지 확인한다. 죽은 링크가 있으면 실패.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS="$ROOT/AGENTS.md"
MISSING=0

if [ ! -f "$AGENTS" ]; then
  echo "AGENTS.md가 존재하지 않습니다. 맵의 기준이 필요합니다."
  exit 1
fi

# AGENTS.md의 코드 블록(```) 안에서 경로 형태(token)를 추출해 존재 확인.
paths=$(awk '/^```/{inblock=!inblock; next} inblock{print}' "$AGENTS" \
        | grep -oE '[A-Za-z_./-]+\.(md|txt|sh)|[A-Za-z_./-]+\/' \
        | sed 's/^[[:space:]]*//' | sort -u)

exists() {
  local p="$1"
  p="${p#./}"
  [ -e "$ROOT/$p" ] && return 0
  [ -e "$ROOT/docs/$p" ] && return 0
  # docs/ 아래 어디든 존재하면 인정 (예: exec-plans/active/ 는 docs/exec-plans/active/)
  find "$ROOT/docs" -name "$(basename "$p")" -o -type d -name "$(basename "$p")" 2>/dev/null \
    | grep -q . && return 0
  return 1
}

for p in $paths; do
  # AGENTS.md 자체와 주석용 경로는 건너뛴다.
  case "$p" in
    AGENTS.md|ARCHITECTURE.md|scripts/|docs/) continue ;;
  esac
  if ! exists "$p"; then
    echo "AGENTS.md 맵의 경로가 존재하지 않음: $p"
    MISSING=1
  fi
done

if [ "$MISSING" -ne 0 ]; then
  echo "AGENTS.md 맵을 실제 구조와 동기화하세요. 맵은 목차이므로 거짓 항목을 두지 않습니다."
  exit 1
fi
echo "AGENTS.md 맵 유효: 모든 나열 경로가 존재합니다."
