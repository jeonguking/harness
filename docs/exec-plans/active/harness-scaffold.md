# 실행 계획: 하네스 엔지니어링 스캐폴드

- 상태: IN_PROGRESS
- 생성일: 2026-08-05
- 완료 기준: `scripts/check.sh`가 통과하고, AGENTS.md·ARCHITECTURE.md·docs/ 지식베이스가
  OpenAI 하네스 엔지니어링 원칙(맵 중심, 기계적 검증, 에이전트 가독성)에 따라 구성됨.

## 배경

OpenAI "하네스 엔지니어링: 에이전트 우선 세계에서 Codex 활용하기"를 참고해
빈 리포지터리에 에이전트 우선 하네스를 스캐폴딩한다. 스택은 무관(순수 구조).

## 단계

- [x] 1. git 초기화 + 디렉터리 구조 생성
- [x] 2. AGENTS.md (목차/맵) 작성
- [x] 3. ARCHITECTURE.md (계층 맵) 작성
- [x] 4. docs/ 지식베이스 계층 생성
- [x] 5. 검증 스크립트 작성 (맵·크로스링크·신선도·아키텍처)
- [x] 6. CI 워크플로 작성
- [x] 8. 에이전트 팀 구성 (orchestrator, architect, coder, reviewer, committer, deployer)
- [ ] 7. 최초 커밋 (인간/에이전트 승인 후)

## 진행 로그

- 2026-08-05: 스캐폴드 시작. 구조/문서 계층 생성 완료.
- 2026-08-05: 검증 스크립트·CI 작성. `bash scripts/check.sh` 전체 통과.
- 2026-08-05: 에이전트 팀 추가 (.opencode/agent/ 6개). `docs/AGENT_TEAM.md`에 협업 루프 문서화.
- 2026-08-05: security 에이전트 추가 (OWASP Top 10). SECURITY.md·AGENT_TEAM.md 리뷰 루프에 반영.
