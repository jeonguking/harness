#!/usr/bin/env bash
# 전체 검증 진입점: 문서 맵 + 크로스링크 + 신선도 + 아키텍처 불변 조건.
# 모든 검증은 비어 있으면 통과, 실패 시 비-zero exit으로 수정 지침을 남긴다.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0

run() {
  local name="$1"
  local script="$2"
  echo "==> $name"
  if bash "$script"; then
    echo "    ok"
  else
    echo "    FAILED"
    FAILED=1
  fi
}

run "AGENTS 맵 유효성" "$ROOT/scripts/check-agents-map.sh"
run "문서 크로스링크"  "$ROOT/scripts/check-links.sh"
run "아키텍처 불변 조건" "$ROOT/scripts/check-architecture.sh"
run "시크릿 스캔"     "$ROOT/scripts/check-secrets.sh"

if [ "$FAILED" -ne 0 ]; then
  echo
  echo "하나 이상의 검증이 실패했습니다. 위 오류를 보고 수정 지침을 따르세요."
  exit 1
fi

echo
echo "모든 검증 통과."
