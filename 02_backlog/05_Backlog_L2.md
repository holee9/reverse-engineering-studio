# 05. Backlog — L2: Signature Extract

**Milestone**: M2 — L2 Release
**Target Version**: v0.2
**Duration**: 1 week

---

## Epic Issues

### #E4. Managed DLL Decompilation
ILSpy 통합, C# 메타데이터 완전 추출

### #E5. WPF GUI Shell
최소 기능 GUI, MVVM 구조

### #E6. Data Model & JSON Export
확장된 결과 모델, 직렬화

---

## Task Issues

### E4 하위

#### T24. ICSharpCode.Decompiler 패키지 통합
- DoD: NuGet 추가, `CSharpDecompiler` 기본 동작 검증

#### T25. TypeDefinition 추출기 구현
- DoD: Class/Interface/Struct/Enum 모두 처리, 접근자별 구분

#### T26. MethodSignature 추출기
- DoD: 파라미터·반환타입·제네릭·ref/out 플래그 완전 추출

#### T27. Property/Field/Event 추출기
- DoD: Getter/Setter 여부, 타입, 접근자

#### T28. Attribute 메타데이터 추출기
- DoD: `[DllImport]`, `[Serializable]` 등 주요 속성 인식

#### T29. P/Invoke 전용 추출기
- DoD: 타겟 DLL 이름, 함수 매핑 테이블 생성

#### T30. XML 주석 파서
- DoD: `.xml` 문서 파일 로드 시 주석 결합

#### T31. ManagedAnalyzer 통합 및 테스트
- DoD: 5개 이상 실제 C# DLL 분석 통과

---

### E5 하위

#### T32. WPF 프로젝트 생성 및 MVVM 기반 구조
- DoD: `RevEngStudio.Wpf` 추가, CommunityToolkit.Mvvm 통합

#### T33. MainWindow 레이아웃 (입력/결과 영역)
- DoD: 파일 선택 UI, 결과 TabControl

#### T34. 파일 드래그 앤 드롭 지원
- DoD: DLL 파일 드롭 → 경로 수신

#### T35. 트리뷰 (Namespace → Type → Member)
- DoD: 계층 표시, 아이콘 구분

#### T36. 멤버 상세 패널
- DoD: 선택 멤버 시그니처·속성 표시

#### T37. 분석 진행 표시 (ProgressBar + StatusBar)
- DoD: 비동기 분석 중 UI 반응성 유지

#### T38. JSON Export 버튼
- DoD: SaveFileDialog → JSON 저장

---

### E6 하위

#### T39. 확장 Report 모델 정의
- DoD: L1 모델 + L2 확장 필드 통합

#### T40. JSON 스키마 v2 문서화
- DoD: `docs/L2_Output_Schema.md`

#### T41. 대용량 DLL 비동기 처리
- DoD: 50MB DLL UI 블로킹 없이 분석

---

### Validation

#### T42. L2 샘플 DLL 추가 (C# 전용)
- DoD: 복잡도 높은 실제 DLL 3건 이상

#### T43. L2 Checkpoint Review
- DoD: DoD 전체 통과, L3 Go/No-Go 결정

#### T44. v0.2 Release
- DoD: 태그, CHANGELOG, Release 노트
