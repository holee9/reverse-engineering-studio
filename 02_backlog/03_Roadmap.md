# 03. Roadmap

## 전체 타임라인

```
Week 1       Week 2      Week 3       Week 4-5     Week 6-7     Week 8-9
─────────    ───────     ──────────   ─────────    ─────────    ─────────
[L1 v0.1]    [L2 v0.2]   [L3 v0.3]    [L4 v0.4]    [L4 cont.]   [L5 v1.0]
Surface      Signature   Structure    Behavior     Behavior     Document
Scan         Extract     Map          Analysis     (C++ DLL)    Synthesis
```

## 마일스톤 (GitHub Milestones)

| Milestone | Due Date | 주요 산출물 |
|-----------|----------|-------------|
| M1 — L1 Release | +3 days | CLI 도구, JSON 출력 |
| M2 — L2 Release | +1.5 weeks | WPF GUI, C# 완전 분석 |
| M3 — L3 Release | +3 weeks | Call Graph 시각화 |
| M4 — L4 Release | +5 weeks | C++ DLL 지원 |
| M5 — L5 Release (v1.0) | +7~9 weeks | 문서 자동 생성 |

## 레벨별 Epic 구조

각 레벨은 1개 이상의 Epic Issue와 다수의 Task Issues로 구성.

### L1 Epics
- Epic: PE Header Analysis
- Epic: CLI Infrastructure
- Epic: CI/CD Bootstrap

### L2 Epics
- Epic: Managed DLL Decompilation
- Epic: WPF GUI Shell
- Epic: Data Model & JSON Export

### L3 Epics
- Epic: Relationship Analysis
- Epic: Graph Visualization
- Epic: Export Enhancement

### L4 Epics
- Epic: Ghidra Integration (Spike 선행)
- Epic: Native Analysis Pipeline
- Epic: Async Process Management

### L5 Epics
- Epic: Template Engine
- Epic: Document Generation
- Epic: User Customization

## 종료 조건 (프로젝트 전체)

v1.0 기준:
- [ ] 실제 레거시 DLL 5건 이상 성공 분석
- [ ] 분석 소요 시간 목표 달성
- [ ] CI/CD 안정 동작
- [ ] 사용자 매뉴얼 작성
- [ ] README에 스크린샷·사용 예시 포함

## 우선순위 규칙

**High**
- 레벨 DoD 필수 항목
- CI/CD 관련 이슈
- 블로커 이슈

**Medium**
- 사용성 개선
- 에러 처리
- 성능 최적화

**Low**
- 문서 개선
- UI 다듬기
- Nice-to-have 기능
