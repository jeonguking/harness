# AGENTS.md

이 파일은 **목차이지 백과사전이 아닙니다.** 짧게 유지하고(100줄 이내) 깊이 있는 정보는
`docs/` 지식베이스가 단일 기록 시스템(system of record)으로 제공합니다.

코드가 아닌 지식은 반드시 이 리포지터리 안에 있어야 합니다. 에이전트가 검색할 수 없는
지식(문서, 채팅, 사람 머릿속)은 존재하지 않는 것으로 간주합니다.

## 시작하기

1. `ARCHITECTURE.md`를 읽어 도메인/패키지 레이어링의 최상위 맵을 파악하세요.
2. 작업과 관련된 `docs/` 문서를 참조하세요. 맵 순서는 `docs/index.md`를 참고.
3. 리포지터리 규칙(골든 룰)은 `docs/DESIGN.md`에 있습니다.
4. 작업 규모가 크면 실행 계획을 세우고 `docs/exec-plans/active/`에 넣으세요.

## 리포지터리 구조

```
AGENTS.md                 이 파일. 목차/맵.
ARCHITECTURE.md           도메인·패키지 레이어링 최상위 맵
.opencode/agent/          에이전트 팀 (orchestrator, architect, coder, reviewer, committer, deployer)
docs/                     지식베이스 (단일 기록 시스템)
├── index.md              지식베이스 색인
├── design-docs/          설계 문서 (검증 상태 + 핵심 신념)
├── exec-plans/           실행 계획 (active/ completed/ tech-debt-tracker.md)
├── generated/            생성 산출물 (예: db-schema.md)
├── product-specs/        제품 스펙 (index.md, 기능별)
├── references/           외부 참조 (설계 시스템, 도구 규약 등)
├── DESIGN.md             설계/골든 룰
├── FRONTEND.md           프론트엔드 규약
├── PLANS.md              계획 수립 규약
├── PRODUCT_SENSE.md      제품 원칙/취향
├── QUALITY_SCORE.md      품질 등급 (도메인·레이어별)
├── RELIABILITY.md        안정성 기준
└── SECURITY.md           보안 기준
```

## 작업 규약

- **작은 변경**: 임시·간단한 계획만으로 작업. PR은 짧게 유지.
- **큰 변경**: `docs/exec-plans/`에 실행 계획을 기록하고 진행/결정 로그를 남긴다.
- **검증**: 변경 후 `scripts/check.sh`를 실행해 문서 맵·크로스링크·신선도가 깨지지 않았는지 확인.
- **엣지**: 데이터는 경계에서 파싱/검증한다(parse, don't validate). 추측한 형태로 사용하지 말 것.
- **병합**: 병합 게이트는 최소로. 불안정한 테스트가 진행을 무한정 막지 않도록 후속 실행으로 해결.

## 지식 유지 (doc-gardening)

- 지식베이스는 최신 상태여야 합니다. 코드 동작과 맞지 않는 문서는 드리프트입니다.
- 스테일 문서를 발견하면 문서를 코드에 맞게 갱신하거나 `scripts/doc-gardening.sh` 안내에 따라 수정 PR을 여세요.
- 규칙이 자꾸 문서로 옮겨져야 한다면, 그 규칙은 **도구로 승격**하는 것을 고려하세요.

## 아키텍처 불변 조건

- 각 비즈니스 도메인은 고정 레이어(Types → Config → Repo → Service → Runtime → UI)를 통해서만 전달.
- 교차 관심사(인증, 커넥터, 텔레메트리, 기능 플래그)는 오직 명시적 인터페이스(Providers)로만 유입.
- 위 규칙은 사람의 취향이 아니라 **기계적 검증**(린터/구조 테스트) 대상입니다.
  세부 사항은 `ARCHITECTURE.md` 참조.

## 상태

- 진행 중인 실행 계획: `docs/exec-plans/active/`
- 기술 부채: `docs/exec-plans/tech-debt-tracker.md`
- 품질 등급: `docs/QUALITY_SCORE.md`

# CTF Agent Harness Map
- **목표:** 주어진 바이너리 취약점을 분석하고 pwntools로 플래그를 획득한다.
- **불변 조건:** 
  1. 모든 익스플로잇 실행은 `scripts/sandbox-run.sh`(Docker)를 통해서만 수행한다.
  2. 호스트 시스템 직접 공격이나 외부 네트워크 스캔은 절대 금지한다.
- **워크플로:** `PRD.md` 작성 → `analyzer` (분석) → `pwner` (코드 작성) → `verifier` (샌드박스 테스트) 반복
