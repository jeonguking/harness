# 에이전트 팀 (Agent Team)

opencode 에이전트 팀의 역할과 워크플로를 정의합니다. 실제 정의 파일은
`.opencode/agent/<name>.md`이며, 이 문서는 팀 차원의 협업 규약입니다.

## 구성

| 에이전트     | 모드     | 책임                                              |
| ------------ | -------- | ------------------------------------------------- |
| orchestrator | primary  | 목표 분해, 위임, 피드백 루프, 에스컬레이션        |
| architect    | subagent | 아키텍처 불변 조건 검증, 설계 문서·품질 등급 관리 |
| coder        | subagent | 실행 계획·스펙에 따른 구현 + 테스트               |
| reviewer     | subagent | 골든 룰·보안·안정성 기준 리뷰 (편집 금지)         |
| security     | subagent | OWASP Top 10 중심 취약점 점검 (편집 금지)         |
| committer    | subagent | 커밋·PR 관리, 시크릿 스캔, 짧은 PR 유지           |
| deployer     | subagent | 배포·릴리스, 롤백, 배포 후 관측 확인              |

## 협업 루프 (Ralph Wiggum Loop)

큰 변경은 orchestrator가 아래 루프를 돌립니다.

```
architect (영향 평가/설계) → coder (구현) → reviewer (골든 룰 리뷰)
                                          ↘ security (OWASP Top 10 점검)
    ↑                                                       │
    └────────────── 피드백 반영 반복 ───────────────────────┘
→ committer (커밋/PR) → deployer (배포, 해당 시)
```

- 각 단계 후 `scripts/check.sh`로 문서 맵·크로스링크·아키텍처 검증.
- 리뷰 피드백은 coder가 반영하고, **reviewer와 security 모두** 승인할 때까지 반복.
- 판단이 필요한 경우에만 사람에게 에스컬레이션.

## 원칙

- **에이전트가 생성**: 코드, 테스트, CI, 문서, 평가 하네스, 리뷰 응답, 저장소 관리 스크립트.
- **사람은 루프에 남는다**: 우선순위·수용 기준·검증만. 코드 직접 작성은 피한다.
- **권한 최소화**: subagent는 편집 권한을 최소화하고(reviewer/committer/deployer는 edit: deny),
  검토는 읽기 전용으로 수행.
- **신호 해석**: 에이전트가 어려워하면 도구·가드레일·문서 부족으로 보고 보완.

## 관련 문서

- 워크플로 규약: `docs/PLANS.md`
- 골든 룰: `docs/DESIGN.md`
- 리뷰 기준: `docs/DESIGN.md`, `docs/SECURITY.md`, `docs/RELIABILITY.md`
