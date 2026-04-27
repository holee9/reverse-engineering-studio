# 06. Backlog — L3~L5 (Skeleton)

> 상세 태스크는 각 레벨 착수 시점에 분할. 현 시점에는 Epic 수준까지만 정의.

---

## L3: Structure Map (v0.3, 1.5 weeks)

### Epic Issues

#### #E7. Relationship Analysis
- 클래스 상속 그래프 빌더
- 인터페이스 구현 매핑
- Call Graph 정적 분석

#### #E8. Graph Visualization
- MSAGL (AutomaticGraphLayout) 통합
- 그래프 레이아웃 알고리즘 선택
- 줌/팬/노드 선택 인터랙션

#### #E9. Export Enhancement
- Graph PNG/SVG 내보내기
- 확장 JSON 스키마 v3

### 주요 Tasks (착수 시점에 분할)
- MSAGL WPF 컨트롤 통합
- 상속 계층 빌더
- Call Graph 빌더 (IL 기반)
- 노드 필터링 UI
- 레벨 DoD 통합 테스트

---

## L4: Behavior Analysis (v0.4, 2 weeks)

### Spike Issues (레벨 착수 전 필수)

#### #S1. Ghidra Headless 실행 가능성 검증
- **Labels**: `spike`, `level:L4`
- **Timebox**: 1 day
- **Goal**: Ghidra Headless로 샘플 DLL 분석 후 JSON 출력 성공 여부 확인
- **Output**: PoC 코드 + 결론 문서

#### #S2. Ghidra Java Script 데이터 추출 PoC
- **Labels**: `spike`, `level:L4`
- **Timebox**: 1 day
- **Goal**: `ExtractAnalysis.java` 초안으로 Export/CallGraph/Strings 추출 검증

#### #S3. 비동기 외부 프로세스 관리 패턴
- **Labels**: `spike`, `level:L4`
- **Timebox**: 0.5 day
- **Goal**: Long-running 프로세스 + 진행 표시 + 취소 패턴 확정

### Epic Issues

#### #E10. Ghidra Integration
- Headless Analyzer 래퍼
- Java Script 번들링
- 프로젝트 임시 디렉토리 관리

#### #E11. Native Analysis Pipeline
- C++ DLL Export 시그니처
- 문자열 테이블 추출
- 제어 흐름 힌트

#### #E12. dumpbin Integration
- VS2022 BuildTools 자동 탐지
- Import/Export 보조 정보

#### #E13. Async Process Management
- 진행 상태 표시
- 취소 기능
- 에러 복구

### 주요 Tasks (스파이크 이후 분할)
- Ghidra 경로 탐지
- Java script 템플릿
- Output JSON 파서
- Process 관리 유틸
- C++ 전용 UI 뷰

---

## L5: Document Synthesis (v1.0, 1.5 weeks)

### Epic Issues

#### #E14. Template Engine
- Markdown 템플릿 로더
- 변수 치환 엔진
- 섹션별 커스터마이징

#### #E15. Document Generation
- Markdown 리포트 생성
- (선택) Word 내보내기 (`DocumentFormat.OpenXml`)
- 분석 메타데이터 포함

#### #E16. User Customization
- 사용자 정의 템플릿 로드
- 템플릿 저장·관리
- 분석 히스토리 (최근 N개)

### 주요 Tasks (착수 시점 분할)
- Markdig 통합
- 기본 템플릿 3종 (Summary / Full / Interface-only)
- 변수 바인딩 (DLL 이름, 날짜, 섹션별 내용)
- 히스토리 스토리지 (JSON 파일)
- 최종 사용자 매뉴얼

---

## 누적 예상 작업량

| Level | Epic 수 | Task 수 (예상) | 기간 |
|-------|---------|---------------|------|
| L1 | 3 | 23 | 3 days |
| L2 | 3 | ~20 | 1 week |
| L3 | 3 | ~15 | 1.5 weeks |
| L4 | 4 (+ 3 Spikes) | ~20 | 2 weeks |
| L5 | 3 | ~12 | 1.5 weeks |
| **Total** | **16** | **~90** | **7~9 weeks** |
