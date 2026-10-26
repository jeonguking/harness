#!/usr/bin/env bash
# 문서 크로스링크 검증: docs/ 아래 마크다운의 상대 링크와 이미지가 실제 존재하는지 확인.
# docs/index.md에 색인된 문서가 모두 존재하는지도 확인한다.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS="$ROOT/docs"
FAILED=0

# 1) docs/ 내 모든 .md의 상대 링크/이미지가 존재하는지 확인
while IFS= read -r file; do
  dir="$(dirname "$file")"
  # [text](path) 와 ![](path) 만 추출, URL/앵커/이메일 제외
  while IFS= read -r target; do
    case "$target" in
      http:*|https:*|mailto:*|'#'*) continue ;;
    esac
    # URL 인코딩 등 특수문자 제외 (간단히 공백/제어문자 있으면 스킵)
    if printf '%s' "$target" | grep -qE '[[:space:]]|[()<>]'; then continue; fi
    if [ ! -e "$dir/$target" ]; then
      echo "깨진 링크: $file -> $target"
      FAILED=1
    fi
  done < <(grep -oE '\[[^]]*\]\([^)]*\)|!\[[^]]*\]\([^)]*\)' "$file" \
           | sed -E 's/^!?\[[^]]*\]\(([^)]*)\).*/\1/' | sort -u)
done < <(find "$DOCS" -name '*.md' -type f)

# 2) docs/index.md 색인에 언급된 문서 존재 확인
if [ -f "$DOCS/index.md" ]; then
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    if [ ! -e "$DOCS/$ref" ] && [ ! -e "$ROOT/$ref" ] \
       && ! find "$DOCS" -name "$(basename "$ref")" | grep -q .; then
      echo "index.md 색인에 없는 문서: $ref"
      FAILED=1
    fi
  done < <(grep -oE '`[A-Za-z0-9_./-]+\.(md|txt)`' "$DOCS/index.md" | tr -d '`' | sort -u)
fi

if [ "$FAILED" -ne 0 ]; then
  echo "크로스링크를 수정하거나, 링크 대상을 docs/에 추가하세요 (지식은 저장소 안에)."
  exit 1
fi
echo "크로스링크 유효: 모든 링크가 존재합니다."
