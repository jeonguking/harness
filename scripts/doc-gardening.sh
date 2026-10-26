#!/usr/bin/env bash
# doc-gardening: 지식베이스의 신선도/스테일 검사 및 수정 가이드.
# - 미완료 스텁(DRAFT/TODO/예시) 문서를 찾아 알린다.
# - 기술 부채 트래커와 품질 등급 검토를 안내한다.
# - 문서가 코드와 드리프트한 징후(금지 경로 누락 등)를 점검한다.
#
# 정기 실행 권장: 주 1회. 발견 사항은 수정 PR로 열 것.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS="$ROOT/docs"

echo "== doc-gardening 실행 =="

# 1) 스테일 마커가 있는 문서 찾기
stale=()
while IFS= read -r f; do
  if grep -aqE '(^#+.*\(예시\)|DRAFT|스캐폴드|아직 미작성|구조 미정|\(없음\))' "$f" 2>/dev/null; then
    stale+=("$f")
  fi
done < <(find "$DOCS" -name '*.md' -type f)

if [ "${#stale[@]}" -gt 0 ]; then
  echo
  echo "스테일/스캐폴드 문서 (갱신 또는 완료 표시 필요):"
  printf '  %s\n' "${stale[@]}"
else
  echo "스테일 문서 없음."
fi

# 2) 실행 계획 완료 상태 점검
echo
echo "진행 중인 실행 계획:"
for f in "$ROOT"/docs/exec-plans/active/*.md; do
  [ -e "$f" ] || { echo "  (없음)"; break; }
  status=$(grep -m1 -E '^- 상태:' "$f" || echo "- 상태: (미기재)")
  echo "  - $(basename "$f"): $status"
done

# 3) 기술 부채 트래커 점검
echo
if [ -f "$DOCS/exec-plans/tech-debt-tracker.md" ]; then
  echo "기술 부채 트래커: $(grep -cE '^\| [0-9]+' "$DOCS/exec-plans/tech-debt-tracker.md")개 항목"
else
  echo "기술 부채 트래커 누락: $DOCS/exec-plans/tech-debt-tracker.md"
fi

echo
echo "다음 실행: 'bash scripts/check.sh'로 문서 맵·크로스링크·아키텍처 검증."
echo "스테일 문서가 발견되면 본 리포지터리 안에서 수정 PR을 열고, 반복되는 규칙은 도구로 승격하세요."
