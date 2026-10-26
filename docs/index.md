# 지식베이스 색인

이 디렉터리는 단일 기록 시스템(system of record)입니다. 코드가 아닌 지식은 전부 여기 있어야
합니다. 문서는 짧게 유지하고, 맵은 `AGENTS.md`, 최상위 아키텍처는 `ARCHITECTURE.md`입니다.

## 읽는 순서 (신규 에이전트용)

1. `AGENTS.md` — 목차/맵
2. `ARCHITECTURE.md` — 계층 아키텍처
3. 이 파일(`index.md`) — 지식베이스 색인
4. 작업에 해당하는 문서

> 개발 진행 방법은 루트의 `README.md` 참조.

## 문서 종류

| 디렉터리/파일      | 내용                                             |
| ------------------ | ------------------------------------------------ |
| `AGENT_TEAM.md`    | 에이전트 팀 역할·협업 루프 (orchestrator 등).    |
| `design-docs/`     | 설계 문서. 검증 상태 + 핵심 신념(core beliefs).  |
| `exec-plans/`      | 실행 계획. active/ completed/ + 기술 부채 추적.  |
| `generated/`       | 생성 산출물 (예: `db-schema.md`). 수동 편집 금지. |
| `product-specs/`   | 제품 스펙. `index.md` + 기능별 스펙.             |
| `references/`      | 외부 참조 (설계 시스템, 도구 규약 등).           |
| `DESIGN.md`        | 골든 룰/설계 원칙.                               |
| `FRONTEND.md`      | 프론트엔드 규약.                                 |
| `PLANS.md`         | 계획 수립 규약.                                  |
| `PRODUCT_SENSE.md` | 제품 원칙/취향.                                  |
| `QUALITY_SCORE.md` | 도메인·레이어별 품질 등급.                       |
| `RELIABILITY.md`   | 안정성 기준.                                     |
| `SECURITY.md`      | 보안 기준.                                       |

## 유지 규칙

- 새 문서를 만들면 반드시 이 색인에 추가하세요. 색인에 없는 문서는 존재하지 않는 것으로 간주.
- 문서 링크는 상대 경로로만. 외부 URL은 `references/`에 리소스를 두고 연결.
- 문서 상태(최신/드리프트)는 `scripts/doc-gardening.sh`로 점검합니다.
