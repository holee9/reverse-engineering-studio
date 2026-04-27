# RevEng Studio

Windows 환경용 개인 `DLL Reverse Engineering` 도구를 위한 문서 우선 저장소다. 이 저장소는 분석 도구 자체보다 먼저 문서, 운영 규칙, 하네스, 개발 진입 구조를 정리하는 데 초점을 둔다.

## 프로젝트 개요

- 목표: Windows `DLL`에서 구조, 시그니처, `import/export`, 동작 단서를 추출한다.
- 목표 사용 흐름: `DLL`을 넣고 결과를 확인한 뒤 재사용 가능한 문서를 내보낸다.
- 대상 기술 스택: `C#` / `WPF` / `.NET 8` / `GitHub Actions`
- 개발 방식: `v0.1`부터 `v1.0`까지 단계적으로 올리는 단계 기반 점진 릴리스

현재 저장소는 `preclean phase`에 있다.

- 현재 집중 범위: 저장소 정리, `workflow` 정렬, `harness` 구축, `backlog` 정제
- 현재 금지 범위: 앱 코드 구현, `solution` 생성, 제품 테스트 구현

## 현재 저장소 역할

지금의 저장소 루트는 구현용 `worktree`가 아니라 공용 제어면이다. 여기서는 아래 항목만 다룬다.

- 프로젝트 문서
- 팀 운영 정책
- `Claude/Codex`용 `bootstrap` 및 `harness` 파일
- `CI` 및 개발 환경 설정

실제 구현 작업은 이 `baseline`이 커밋된 뒤 팀별 `worktree`에서 진행한다.

## 팀 운영 모델

같은 저장소를 두 개의 에이전트 팀이 병렬로 운영한다.

- `Claude 팀`: `CLAUDE.md`, `.claude/`, `.moai/` 사용
- `Codex 팀`: `AGENTS.md`, `.codex/` 사용

공유 규칙은 다음과 같다.

- 하나의 `issue` 또는 `SPEC`는 하나의 담당 팀에만 배정한다.
- 하나의 담당 팀은 하나의 `worktree`만 소유한다.
- 루트 `checkout`은 공용 제어면 변경에만 사용한다.
- 팀 `worktree`는 `.worktrees/claude/`, `.worktrees/codex/` 아래에 만든다.

핵심 운영 문서:

- [04_workflow/13_Agent_Team_Workflow.md](04_workflow/13_Agent_Team_Workflow.md)

## 저장소 구성

### 제품 기획 및 개발 문서

- [00_README.md](00_README.md): 전체 문서 인덱스와 읽는 순서
- [01_overview/00_README.md](01_overview/00_README.md): 프로젝트 개요
- [01_overview/01_Methodology.md](01_overview/01_Methodology.md): 점진적 개발 방법론
- [01_overview/02_Levels.md](01_overview/02_Levels.md): `L1`부터 `L5`까지의 단계 정의
- [02_backlog/03_Roadmap.md](02_backlog/03_Roadmap.md): 로드맵
- [02_backlog/04_Backlog_L1.md](02_backlog/04_Backlog_L1.md): 즉시 착수 가능한 `backlog`

### 아키텍처

- [03_architecture/07_Architecture.md](03_architecture/07_Architecture.md): 아키텍처 개요
- [03_architecture/08_Modules.md](03_architecture/08_Modules.md): 모듈 경계와 책임
- [03_architecture/09_Tech_Stack.md](03_architecture/09_Tech_Stack.md): 기술 스택 결정

### 운영 문서와 템플릿

- [04_workflow/10_Git_Flow.md](04_workflow/10_Git_Flow.md): 브랜치와 `merge` 규칙
- [04_workflow/11_Issue_Flow.md](04_workflow/11_Issue_Flow.md): 이슈 생애주기
- [04_workflow/12_Labels.md](04_workflow/12_Labels.md): 라벨과 마일스톤
- [04_workflow/13_Agent_Team_Workflow.md](04_workflow/13_Agent_Team_Workflow.md): `Claude/Codex` 팀 `worktree` 정책
- [05_cicd/13_CI_Strategy.md](05_cicd/13_CI_Strategy.md): `CI` 전략
- [06_templates/16_PR_Template.md](06_templates/16_PR_Template.md): `PR` 템플릿
- [06_templates/17_Commit_Convention.md](06_templates/17_Commit_Convention.md): `commit` 규칙

### 에이전트 시작 안내

- [AGENTS.md](AGENTS.md): `Codex`용 저장소 지침
- [CLAUDE.md](CLAUDE.md): `Claude`용 저장소 지침
- [.codex/README.md](.codex/README.md): `Codex` 시작 안내
- [.codex/config/harness.json](.codex/config/harness.json): `phase` 및 `worktree` 정책

## 빠른 시작

### 문서 검토 시작 순서

아래 순서로 읽으면 된다.

1. [00_README.md](00_README.md)
2. [01_overview/00_README.md](01_overview/00_README.md)
3. [01_overview/01_Methodology.md](01_overview/01_Methodology.md)
4. [01_overview/02_Levels.md](01_overview/02_Levels.md)
5. [04_workflow/10_Git_Flow.md](04_workflow/10_Git_Flow.md)
6. [05_cicd/13_CI_Strategy.md](05_cicd/13_CI_Strategy.md)

### `Codex 팀` 초기화

```powershell
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\Initialize-Codex.ps1
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\Get-TeamWorktreeStatus.ps1
```

### 팀 `worktree` 생성

공유 `baseline`이 커밋된 뒤에만 실행한다.

```powershell
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\New-TeamWorktree.ps1 `
  -Team codex `
  -Type docs `
  -Identifier 101 `
  -Slug preclean-harness
```

## 예정된 제품 단계

- `L1 Surface Scan`: `PE metadata`와 `CLI` 분석
- `L2 Signature Extract`: `managed` 타입과 시그니처 추출, 최소 `WPF UI`
- `L3 Structure Map`: 관계 구조와 `call graph` 시각화
- `L4 Behavior Analysis`: `Ghidra` 기반 `native` 분석 보강
- `L5 Document Synthesis`: `Markdown/Word` 문서 생성

## Git 및 릴리즈 정책

- `main`은 항상 배포 가능한 상태를 유지한다.
- `develop branch`는 두지 않는다.
- 모든 작업은 `main`에서 분기한다.
- `PR-first workflow`와 `CI gate`를 따른다.
- 기본 `merge strategy`는 `squash merge`다.

관련 문서:

- [04_workflow/10_Git_Flow.md](04_workflow/10_Git_Flow.md)
- [05_cicd/13_CI_Strategy.md](05_cicd/13_CI_Strategy.md)

## 현재 baseline 상태

이 저장소는 아직 첫 공용 제어면 `baseline`을 만드는 단계다. 이 `baseline`이 커밋되고 푸시되기 전까지는 다음 규칙이 유지된다.

- `Codex`용 `harness`가 `worktree` 생성을 의도적으로 막는다.
- 팀 구현 작업은 시작하지 않는다.
- 루트 `checkout` 변경은 문서, `workflow`, 환경 설정에 한정한다.
