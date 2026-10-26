#!/usr/bin/env bash
# 아키텍처 불변 조건의 기계적 검증.
# 스캐폴드 단계에서는 지식베이스가 불변 조건을 갖추고 있는지 확인한다.
# 실제 코드가 생기면 구조 테스트로 확장하라 (예: 의존성 방향, 레이어 역류).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0

# 1) 필수 지식베이스 문서 존재
required=(
  "$ROOT/AGENTS.md"
  "$ROOT/ARCHITECTURE.md"
  "$ROOT/docs/index.md"
  "$ROOT/docs/DESIGN.md"
  "$ROOT/docs/PLANS.md"
  "$ROOT/docs/QUALITY_SCORE.md"
  "$ROOT/docs/RELIABILITY.md"
  "$ROOT/docs/SECURITY.md"
  "$ROOT/docs/design-docs/core-beliefs.md"
  "$ROOT/docs/exec-plans/tech-debt-tracker.md"
)
for f in "${required[@]}"; do
  if [ ! -f "$f" ]; then
    echo "필수 문서 누락: $f"
    FAILED=1
  fi
done

# 2) AGENTS.md는 목차이어야 한다 (<= 120줄, 백과사전 금지)
if [ -f "$ROOT/AGENTS.md" ]; then
  lines=$(wc -l < "$ROOT/AGENTS.md")
  if [ "$lines" -gt 120 ]; then
    echo "AGENTS.md가 너무 깁니다 ($lines줄). 목차/맵만 유지하고 깊이는 docs/로 옮기세요."
    FAILED=1
  fi
fi

# 3) ARCHITECTURE.md가 레이어 불변 조건을 명시하는지
if [ -f "$ROOT/ARCHITECTURE.md" ] \
   && ! grep -q "Types.*Config.*Repo.*Service.*Runtime.*UI" "$ROOT/ARCHITECTURE.md"; then
  echo "ARCHITECTURE.md에 레이어 순서 불변 조건이 없습니다."
  FAILED=1
fi

# 4) 실행 계획 규약: active/ 파일은 상태 필드를 가져야 한다
for f in "$ROOT"/docs/exec-plans/active/*.md; do
  [ -e "$f" ] || continue
  if ! grep -qE '^- 상태:' "$f"; then
    echo "실행 계획에 상태 필드 누락: $f"
    FAILED=1
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo "아키텍처 불변 조건 위반. 오류 메시지에 따라 수정 지침을 적용하세요."
  exit 1
fi
echo "아키텍처 불변 조건 충족."
