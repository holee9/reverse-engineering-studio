# 00. Project Overview

## 목표

레거시 DLL을 드롭하면 구조·시그니처·동작 단서를 추출해 **개발 문서 초안**을 자동 생성하는 개인용 도구.

## 왜 만드는가

- 파편화된 도구(dnSpy, Ghidra, dumpbin) 워크플로우 통합
- 레거시 DLL 유지보수·재개발 시 문서화 작업 자동화
- 미래의 내가 오늘의 분석 결과를 빠르게 복기할 수 있도록

## In Scope

- Windows x86/x64 PE DLL 정적 분석
- Managed (.NET) / Native (C/C++) / Mixed (C++/CLI)
- 구조·시그니처·호출관계·문자열 추출
- Markdown 형식 분석 리포트 자동 생성

## Out of Scope

- 동적 분석 (실행 추적)
- 난독화 자동 해제
- 원본 소스코드 수준 복원
- Linux/macOS 바이너리
- 멀티 플랫폼 배포
- 규제 문서 구조 (PRD/SRS/SDS 자동 생성은 선택적 L5에서만)

## 성공 기준

| 기준 | 목표 |
|------|------|
| 분석 시간 | L3 수준 단일 DLL < 30분 |
| 비용 | 신규 라이선스 0원 |
| 코드 품질 | CI 통과 100%, 테스트 커버리지 레벨별 DoD 준수 |
| 사용성 | 드래그 앤 드롭 → 결과 보기까지 3 클릭 이하 |

## 핵심 구성요소

```
입력 DLL
  ↓
[Type Detector] → Managed / Native / Mixed 분류
  ↓
[Analyzer Engines]
  ├─ PE Info (PeNet)
  ├─ Managed (ICSharpCode.Decompiler)
  └─ Native (Ghidra Headless)
  ↓
[Aggregator] → 통합 분석 데이터 (JSON)
  ↓
[WPF Viewer]  +  [Document Generator]
  - 트리 뷰           - Markdown 리포트
  - Call Graph        - (선택) PRD/SRS 초안
  - 상세 패널
```
