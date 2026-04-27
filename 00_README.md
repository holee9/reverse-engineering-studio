# RevEng Studio — 개발 문서

> **프로젝트**: 개인용 DLL Reverse Engineering GUI App
> **저장소**: GitHub
> **스택**: C# / WPF / .NET 8
> **CI/CD**: GitHub Actions
> **개발자**: 애이치앤 (1인)
> **기간**: 7~9주

레거시 DLL 분석용 개인 도구. 로컬 Windows 환경에서 실행.

---

## 문서 구성

### 01. Overview
- [00_README.md](01_overview/00_README.md) — 프로젝트 개요
- [01_Methodology.md](01_overview/01_Methodology.md) — 점진적 개발 방법론
- [02_Levels.md](01_overview/02_Levels.md) — L1~L5 정의

### 02. Backlog
- [03_Roadmap.md](02_backlog/03_Roadmap.md) — 전체 로드맵
- [04_Backlog_L1.md](02_backlog/04_Backlog_L1.md) — L1 이슈 목록 (즉시 착수)
- [05_Backlog_L2.md](02_backlog/05_Backlog_L2.md) — L2 이슈 목록
- [06_Backlog_L3_L5.md](02_backlog/06_Backlog_L3_L5.md) — L3~L5 스켈레톤

### 03. Architecture
- [07_Architecture.md](03_architecture/07_Architecture.md) — 아키텍처 개요
- [08_Modules.md](03_architecture/08_Modules.md) — 모듈별 책임
- [09_Tech_Stack.md](03_architecture/09_Tech_Stack.md) — 기술 스택

### 04. Workflow
- [10_Git_Flow.md](04_workflow/10_Git_Flow.md) — 브랜치·커밋 규약
- [11_Issue_Flow.md](04_workflow/11_Issue_Flow.md) — 이슈 생애주기
- [12_Labels.md](04_workflow/12_Labels.md) — 라벨·마일스톤

### 05. CI/CD
- [13_CI_Strategy.md](05_cicd/13_CI_Strategy.md) — CI/CD 전략
- [14_Workflows.md](05_cicd/14_Workflows.md) — GitHub Actions 워크플로우

### 06. Templates
- [15_Issue_Templates.md](06_templates/15_Issue_Templates.md) — 이슈 템플릿
- [16_PR_Template.md](06_templates/16_PR_Template.md) — PR 템플릿
- [17_Commit_Convention.md](06_templates/17_Commit_Convention.md) — 커밋 규약

---

## 읽는 순서

**최초 1회**: `00_README` → `01_Methodology` → `02_Levels` → `03_Roadmap` → `10_Git_Flow` → `13_CI_Strategy`

**개발 착수**: `04_Backlog_L1` → `15_Issue_Templates` → `07_Architecture`

---

## 핵심 원칙

1. 작게 만들어 검증하고 다음 단계로
2. 5분 넘는 작업은 이슈로 만든다
3. 각 레벨은 독립 릴리즈 가능
4. CI 통과 못한 PR은 머지 금지
5. 실용성 최우선, 문서 오버헤드 최소
