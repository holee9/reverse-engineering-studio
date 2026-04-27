# 13. Agent Team Workflow

## 목적

이 문서는 `Claude 팀`과 `Codex 팀`이 같은 저장소를 병렬 운영할 때 사용하는 공통 `worktree` 정책을 정의한다. 기존 `10_Git_Flow.md`와 `11_Issue_Flow.md`를 대체하는 문서가 아니라, 에이전트 기반 병렬 운영을 위한 상위 보완 규칙이다.

## 현재 운영 단계

현재 `phase`는 `preclean`이다.

- 허용: 문서 정리, `backlog` 정제, 하네스 구축, `CI`/환경 정리, `worktree` 정책 확정
- 금지: 앱 기능 구현, `.sln`/`.csproj` 생성, `*.cs`/`*.xaml` 변경, 제품 테스트 작성

`phase` 기준 파일은 `.codex/config/harness.json`이다.

## 작업공간 구조

```text
repo-root/                         <- 공용 제어 checkout
  .worktrees/
    claude/
      <issue-or-spec>-<slug>/      <- Claude 팀 worktree
    codex/
      <issue-or-spec>-<slug>/      <- Codex 팀 worktree
```

### 공용 제어 checkout

- 저장소 루트 `checkout`은 공용 제어면이다.
- 여기서는 문서, 정책, 하네스, 환경설정만 수정한다.
- 앱 코드 수정은 허용하지 않는다.

### 팀 worktree

- 실제 구현 단위는 반드시 팀별 `worktree`에서 수행한다.
- `1 issue/SPEC = 1 담당 팀 = 1 worktree`를 기본 규칙으로 둔다.
- 같은 이슈를 두 팀이 동시에 같은 `worktree`에서 작업하지 않는다.

## 팀별 기준 레이어

### Claude 팀

- 실행 지침: `CLAUDE.md`
- 기존 운영 레이어: `.claude/`, `.moai/`

### Codex 팀

- 실행 지침: `AGENTS.md`
- `Codex` 전용 운영 레이어: `.codex/`

두 팀 모두 공유 `worktree` 정책은 이 문서를 따른다.

## 브랜치 규칙

기본 형식:

```text
<type>/<issue-or-spec>-<slug>
```

예:

```text
docs/101-preclean-harness
chore/102-worktree-bootstrap
spike/103-branch-policy-validation
feature/210-pe-loader
fix/211-null-export-crash
```

### phase별 허용 타입

`preclean`
- `docs`
- `chore`
- `spike`

`implementation`
- `feature`
- `fix`
- `docs`
- `chore`
- `refactor`
- `test`
- `spike`

## worktree 생성 규칙

1. 공유 제어면 변경이 아직 커밋되지 않았다면 `worktree`를 만들지 않는다.
2. `worktree`는 팀 루트 아래에만 만든다.
3. `worktree` 생성 시 현재 `phase`에서 허용된 브랜치 타입만 사용한다.
4. 승인된 `issue` 또는 `SPEC`에만 `worktree`를 만든다.

## 표준 명령

```powershell
.\.codex\scripts\Initialize-Codex.ps1
.\.codex\scripts\Get-TeamWorktreeStatus.ps1
.\.codex\scripts\New-TeamWorktree.ps1 -Team codex -Type docs -Identifier 101 -Slug preclean-harness
```

## handoff 규칙

- 각 팀은 작업 종료 시 `.codex/templates/HANDOFF_TEMPLATE.md` 형식으로 인수인계 메모를 남긴다.
- `handoff`에는 최소한 팀, 브랜치, `worktree`, 현재 `phase`, 완료 범위, 남은 작업, `blocker`를 적는다.
- 다른 팀은 기존 `handoff`를 읽기 전에는 해당 `worktree`를 이어받지 않는다.

## 운영 체크리스트

### 시작 전

- 현재 `phase` 확인
- 공용 제어 `checkout`이 정리된 `baseline`인지 확인
- `issue/SPEC` 담당 팀 확정
- 기존 동일 목적 `worktree` 존재 여부 확인

### 종료 전

- 변경 범위가 `phase` 정책을 어기지 않았는지 확인
- `handoff` 작성
- 다음 작업과 `blocker` 기록
- 루트 `checkout`과 팀 `worktree`를 혼용하지 않았는지 확인
