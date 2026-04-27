# 02. Levels (L1~L5)

| Level | 이름 | 기간 | 버전 |
|-------|------|------|------|
| **L1** | Surface Scan | 3일 | v0.1 |
| **L2** | Signature Extract | 1주 | v0.2 |
| **L3** | Structure Map | 1.5주 | v0.3 |
| **L4** | Behavior Analysis | 2주 | v0.4 |
| **L5** | Document Synthesis | 1.5주 | v1.0 |

---

## L1: Surface Scan (3일, v0.1)

### 목표
PE 헤더 기본 정보 추출. CLI 동작. GUI 없음.

### 범위
- PE 파일 검증
- Managed/Native/Mixed 판별
- 아키텍처 (x86/x64)
- Export / Import 목록
- Section 정보
- 파일 메타 (크기, 버전, SHA256)

### 기술
- `.NET 8 Console App`
- `PeNet` NuGet

### DoD
- [ ] 3개 이상 샘플 DLL 검증
- [ ] Managed/Native/Mixed 각 1건 테스트 통과
- [ ] JSON 출력 스키마 문서화
- [ ] 손상 PE 파일 에러 핸들링
- [ ] 단위 테스트 기본 작성
- [ ] CI: build + test 통과
- [ ] Release v0.1 태그

### 산출물
- `RevEngStudio.Cli.exe`
- `docs/L1_Output_Schema.md`

---

## L2: Signature Extract (1주, v0.2)

### 목표
C# DLL 전용 모든 타입·시그니처 추출. 최소 WPF GUI.

### 범위
- L1 기능 포함
- Type 추출 (Class/Interface/Struct/Enum)
- Method Signature
- Property / Field / Event
- Attribute 메타데이터
- DllImport (P/Invoke) 추출
- XML 주석 수집

### GUI (최소)
- 파일 드롭/선택
- 결과 트리뷰 (Namespace → Type → Member)
- 선택 멤버 상세 패널
- JSON Export

### 기술 추가
- `ICSharpCode.Decompiler`
- `WPF` + `CommunityToolkit.Mvvm`

### DoD
- [ ] L1 DoD 유지
- [ ] 5개 이상 실제 C# DLL 검증
- [ ] P/Invoke 추출 정확도 100%
- [ ] GUI 기본 동작 (로드 → 표시 → Export)
- [ ] 10MB+ DLL 비동기 처리 (UI 블로킹 방지)
- [ ] CI: build + test + WPF 패키징 통과
- [ ] Release v0.2 태그

### 체크포인트
- C# 전용만으로 실무 투입 가능한가?
- L3 투자 가치 vs L2 품질 향상 가치?

---

## L3: Structure Map (1.5주, v0.3)

### 목표
타입·메서드 사이 **관계 시각화**.

### 범위
- L2 기능 포함
- 클래스 상속 다이어그램
- 인터페이스 구현 관계
- 메서드 Call Graph (Static)
- 네임스페이스 트리 구조
- P/Invoke 타겟 매핑 테이블

### 기술 추가
- `AutomaticGraphLayout.WpfGraphControl` (MSAGL)

### DoD
- [ ] L2 DoD 유지
- [ ] Call Graph 노드 > 500개 렌더링 가능
- [ ] 그래프 Export (PNG/SVG)
- [ ] Release v0.3 태그

### 체크포인트
- Call Graph가 실제 문서화에 유용한가?
- C++ 대응(L4)이 필요한가?

---

## L4: Behavior Analysis (2주, v0.4)

### 목표
C++ DLL 대응. Ghidra 통합.

### 범위
- L3 기능 포함
- C++ DLL Export 시그니처 (Ghidra)
- 문자열 테이블 (매직 넘버, 에러 메시지)
- 제어 흐름 힌트
- dumpbin 보조 정보

### 기술 추가
- Ghidra Headless (외부 프로세스)
- Java Post Script (`ExtractAnalysis.java`)
- dumpbin (VS2022 BuildTools)

### Spike 이슈 선행
레벨 착수 전 다음 스파이크 필수:
1. Ghidra Headless 로컬 실행 검증
2. JSON 스키마 설계
3. 비동기 프로세스 관리 패턴 검증

### DoD
- [ ] L3 DoD 유지
- [ ] C++ DLL 3개 이상 검증
- [ ] Ghidra 분석 백그라운드 실행
- [ ] 분석 진행률 표시
- [ ] 분석 취소 기능
- [ ] Release v0.4 태그

### 체크포인트
- 실제로 C++ 분석이 쓸만한가?
- L5 문서 자동화가 필요한가?

---

## L5: Document Synthesis (1.5주, v1.0)

### 목표
분석 결과를 Markdown/Word 문서로 자동 변환.

### 범위
- L4 기능 포함
- Markdown 리포트 템플릿 엔진
- (선택) Word 내보내기
- 섹션별 커스텀 템플릿 지원
- 분석 히스토리 (최근 N개 DLL)

### 기술 추가
- `Markdig`
- `DocumentFormat.OpenXml` (선택)

### DoD
- [ ] L4 DoD 유지
- [ ] 템플릿 3종 이상 제공
- [ ] 사용자 정의 템플릿 로드 가능
- [ ] Release v1.0 태그
