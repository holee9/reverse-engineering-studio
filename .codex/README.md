# Codex Bootstrap

`Codex` 팀은 이 디렉터리를 시작점으로 사용한다. 목적은 제품 코딩이 아니라 저장소 운영층과 worktree 하네스를 표준화하는 것이다.

## 현재 상태

- 현재 phase는 `.codex/config/harness.json` 기준 `preclean`
- 이 phase에서는 `docs`, `chore`, `spike` 브랜치만 허용
- 앱 코드, `.sln`, `.csproj`, `.cs`, `.xaml` 생성/수정은 잠금 상태
- 런타임 산출물은 `.codex.local/` 아래에만 생성

## 구성

- `config/harness.json`: Codex 전용 phase/worktree 정책의 기준 파일
- `scripts/Initialize-Codex.ps1`: 로컬 Codex 작업 디렉터리와 상태를 초기화
- `scripts/Get-TeamWorktreeStatus.ps1`: control checkout 포함 worktree 현황 조회
- `scripts/New-TeamWorktree.ps1`: 팀별 표준 경로와 브랜치명으로 worktree 생성
- `templates/HANDOFF_TEMPLATE.md`: worktree 인수인계 템플릿

## 시작 순서

1. `AGENTS.md`와 `04_workflow/13_Agent_Team_Workflow.md`를 읽는다.
2. `.\.codex\scripts\Initialize-Codex.ps1`를 실행한다.
3. `.\.codex\scripts\Get-TeamWorktreeStatus.ps1`로 현재 worktree 상태를 확인한다.
4. 공유 기준선이 커밋된 뒤에만 `.\.codex\scripts\New-TeamWorktree.ps1`로 팀 worktree를 만든다.

## 예시

```powershell
.\.codex\scripts\Initialize-Codex.ps1
.\.codex\scripts\Get-TeamWorktreeStatus.ps1
.\.codex\scripts\New-TeamWorktree.ps1 -Team codex -Type docs -Identifier 101 -Slug preclean-harness -DryRun
```

## Claude 팀과의 관계

- Claude 팀은 기존 `.claude/`와 `.moai/`를 계속 사용한다.
- Codex 팀은 `AGENTS.md`와 `.codex/`를 기준으로 움직인다.
- 두 팀 모두 worktree 정책 자체는 `04_workflow/13_Agent_Team_Workflow.md`를 공유한다.
