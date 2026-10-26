#!/usr/bin/env bash
# 시크릿 스캔: 커밋 대상 트랙 파일에서 유력 시크릿 패턴을 찾는다.
# 신규 시크릿이 발견되면 커밋 전에 정리하도록 실패한다.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0

if ! git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "git 리포지터리가 아닙니다. 스캔을 건너뜁니다."
  exit 0
fi

# 트랙된 파일만 대상 (미추적 파일은 커밋되지 않으므로 무시)
git -C "$ROOT" ls-files -z | while IFS= read -r -d '' f; do
  # 바이너리/이미지 제외
  case "$f" in
    *.png|*.jpg|*.jpeg|*.gif|*.svg|*.ico|*.woff|*.woff2|*.ttf) continue ;;
  esac
  if grep -aEq '(AKIA[0-9A-Z]{16}|BEGIN (RSA|OPENSSH|PRIVATE) KEY|ghp_[0-9A-Za-z]{36}|sk-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z_-]{35})' "$ROOT/$f" 2>/dev/null; then
    echo "시크릿 의심 패턴 발견: $f"
    exit 1
  fi
done || FAILED=1

if [ "$FAILED" -ne 0 ]; then
  echo "시크릿을 저장소에서 제거하고 .gitignore에 추가하거나, 환경변수/시크릿 매니저로 옮기세요."
  exit 1
fi
echo "시크릿 스캔 통과."
