# 저장소 에이전트 가이드

이 저장소는 현재 에이전트 기반 `preclean` 단계로 운영한다.

## 먼저 읽을 문서

1. `04_workflow/13_Agent_Team_Workflow.md`
2. `.codex/README.md`
3. `04_workflow/10_Git_Flow.md`
4. `04_workflow/11_Issue_Flow.md`
5. 활성 팀이 `Claude team`이면 `CLAUDE.md`

## 현재 phase 잠금

- 현재 `phase`: `preclean`
- 허용 작업: 문서 정리, `backlog` 정제, `harness`, `CI`/환경 설정, 저장소 정리
- 금지 작업: 앱 코드, `solution/project` 생성, 제품 테스트 구현

## 팀 구조

- 저장소 루트 `checkout`은 공용 제어 `checkout`이다.
- 공용 제어 `checkout`은 공유 문서, 정책, `harness`, 환경 설정에만 사용한다.
- 팀 `worktree`는 `.worktrees/claude/*`, `.worktrees/codex/*` 아래에 둔다.
- 하나의 `issue` 또는 `SPEC`는 하나의 팀과 하나의 `worktree`에만 매핑한다.

## `Codex` 작업 흐름

- `.\.codex\scripts\Initialize-Codex.ps1` 실행
- `.\.codex\scripts\Get-TeamWorktreeStatus.ps1`로 활성 `worktree` 확인
- `.\.codex\scripts\New-TeamWorktree.ps1`로 승인된 `worktree` 생성
- 인수인계 메모는 `.codex/templates/HANDOFF_TEMPLATE.md` 사용

## 가드레일

- 공용 제어 `checkout`에서 앱 코드를 수정하지 않는다.
- 다른 팀의 `worktree`를 재사용하지 않는다.
- 명시적 승인 없이 `.codex/config/harness.json`의 `phase`를 바꾸지 않는다.
- 첫 팀 `worktree` 생성 전에는 공용 제어면 `baseline`을 먼저 커밋한다.
