# 에이전트 우선 개발 하네스

OpenAI "하네스 엔지니어링" 원칙을 적용한 에이전트 우선 개발 환경입니다.
이 리포지터리는 **목차/맵 + 지식베이스 + 역할 에이전트 + 기계적 검증**의 4축으로 구성됩니다.

> 이 파일은 사용 가이드입니다. 리포지터리 규칙·맵은 `AGENTS.md`, 최상위 아키텍처는
> `ARCHITECTURE.md`가 기록 시스템(system of record)입니다.

## 무엇이 들어있나

| 구성 요소        | 위치                                        | 역할                                   |
| ---------------- | ------------------------------------------- | -------------------------------------- |
| 목차/맵          | `AGENTS.md` (~100줄)                        | 에이전트가 가장 먼저 읽는 맵           |
| 아키텍처 맵      | `ARCHITECTURE.md`                           | 레이어 불변 조건 (Types→…→UI, Providers) |
| 지식베이스       | `docs/`                                     | 코드가 아닌 지식의 단일 기록 시스템      |
| 에이전트 팀      | `.opencode/agent/`                          | 역할별 에이전트 7종                     |
| 검증 도구        | `scripts/check.sh` 등                       | 문서 맵·크로스링크·아키텍처·시크릿 검증 |
| CI               | `.github/workflows/harness.yml`             | 문서 하네스 자동 검증                   |

## 개발 워크플로

### 1. 요구사항 정의

`docs/product-specs/PRD.md`를 작성합니다. 검증 가능한 수용 기준을 포함하세요.

### 2. 실행 계획 수립 (큰 변경 시)

`docs/exec-plans/active/<slug>.md`에 계획을 기록합니다. 규약은 `docs/PLANS.md`.
작은 변경은 임시·간단한 계획만으로 진행합니다.

### 3. 에이전트 루프 실행

opencode를 시작하고 **orchestrator**를 선택합니다:

```bash
opencode                       # 기본 에이전트로 시작
opencode --agent orchestrator  # 또는 orchestrator를 1차 에이전트로 선택
```

orchestrator는 아래 루프를 돌립니다:

```
architect (설계 검증) → coder (구현) → reviewer + security (리뷰)
    ↑                                          │
    └────────── 피드백 반영 반복 ───────────────┘
→ committer (커밋/PR) → deployer (배포, 해당 시)
```

예시 프롬프트:

```
docs/product-specs/PRD.md의 요구사항을 실행 계획으로 만들고 구현을 시작해줘
```

### 4. 검증

각 단계 후, 그리고 커밋 전에:

```bash
bash scripts/check.sh        # 문서 맵·크로스링크·아키텍처·시크릿 검증
bash scripts/doc-gardening.sh # 지식베이스 신선도 점검 (주 1회 권장)
```

## 에이전트 팀

| 에이전트     | 모드     | 책임                                                      | 호출 시점              |
| ------------ | -------- | --------------------------------------------------------- | ---------------------- |
| orchestrator | primary  | 목표 분해, 위임, 피드백 루프, 에스컬레이션                | 개발 시작              |
| architect    | subagent | 아키텍처 불변 조건 검증, 설계 문서·품질 등급 관리          | 설계/큰 변경           |
| coder        | subagent | 실행 계획·스펙에 따른 구현 + 테스트                       | 구현                   |
| reviewer     | subagent | 골든 룰·보안·안정성 기준 리뷰 (편집 금지)                 | 구현 후                |
| security     | subagent | OWASP Top 10 중심 취약점 점검 (편집 금지)                 | 구현 후                |
| committer    | subagent | 커밋·PR 관리, 시크릿 스캔, 짧은 PR 유지                   | 리뷰 통과 후           |
| deployer     | subagent | 배포·릴리스, 롤백, 배포 후 관측 확인                      | 배포 시                |

subagent는 orchestrator가 `task` 도구로 호출하며, 필요 시 직접 호출할 수도 있습니다.
세부 규약은 `docs/AGENT_TEAM.md`.

## 지식 관리 규칙

- **보이지 않는 지식은 존재하지 않는다.** 문서·채팅·머릿속 정보는 전부 저장소에 기록.
- 새 문서는 `docs/index.md` 색인에 등록.
- 규칙이 자꾸 문서로 옮겨져야 하면 **도구로 승격**하라 (스크립트/린터).
- 스테일 문서는 `scripts/doc-gardening.sh`로 발견하고 수정 PR을 연다.

## 초기 시작 시 주의

- opencode 설정은 세션 시작 시 1회 로드됩니다. 에이전트를 추가/수정한 뒤에는 **opencode를 재시작**하세요.
- 첫 개발 전: `bash scripts/check.sh`가 통과하는지 확인하세요.
- 실제 제품/스택이 정해지면 `docs/FRONTEND.md`, `docs/generated/db-schema.md`, `docs/QUALITY_SCORE.md`를 채웁니다.
