# 15. Issue Templates

> 실제 YAML 파일은 [14_Workflows.md](../05_cicd/14_Workflows.md)의 "Issue Template" 섹션 참조.
> 이 문서는 템플릿의 **사용 가이드**.

## 템플릿 4종

| 템플릿 | 파일 | 용도 |
|--------|------|------|
| Epic | `epic.yml` | 여러 Task를 포함하는 대규모 작업 |
| Task | `task.yml` | 실제 구현 작업 (2~8h) |
| Bug | `bug.yml` | 버그 리포트 |
| Spike | `spike.yml` | Timeboxed 탐색 |

---

## Epic 사용 예시

**제목**: `[Epic] PE Header Analysis Core`

**본문**:
```markdown
## Description
PE 파일의 헤더를 파싱하고 메타데이터를 구조화하는 코어 엔진 구현.

## Goals
- PE 파일 유효성 검증
- Managed/Native/Mixed 자동 분류
- Export/Import/Section 정보 완전 추출
- 통합 리포트 모델로 조립

## Child Tasks
- [ ] #8 PeNet 패키지 통합 및 파일 로드 검증
- [ ] #9 DLL Type Detector 구현
- [ ] #10 PE 메타데이터 추출
- [ ] #11 Export 함수 목록 추출
- [ ] #12 Import 의존성 추출
- [ ] #13 Section 정보 추출
- [ ] #14 파일 해시 계산
- [ ] #15 통합 Report 모델 및 Aggregator
```

**라벨**: `epic`, `level:L1`, `area:core`

---

## Task 사용 예시

**제목**: `[Task] Add DllTypeDetector for Managed/Native classification`

**본문**:
```markdown
## What
`DllTypeDetector` 클래스를 구현해 입력 DLL이 Managed (.NET), Native (C/C++),
Mixed (C++/CLI) 중 어느 유형인지 자동 판별한다.

## Why
이후 분석 엔진(ManagedAnalyzer vs NativeAnalyzer)을 분기하기 위해 필수.
L1부터 L4까지 공통으로 사용됨.

## Definition of Done
- [ ] `DllTypeDetector` 클래스 구현
- [ ] `enum DllType { Managed, Native, Mixed, Unknown }` 정의
- [ ] CLI Header 유무 기반 판별 로직
- [ ] 단위 테스트 (Managed/Native/Mixed 각 1건 이상)
- [ ] `SurfaceScanReport.Type` 필드에 결과 반영
- [ ] 모든 기존 테스트 통과
- [ ] CI 통과

## Estimate
3h

## Parent Epic
#E2
```

**라벨**: `task`, `level:L1`, `area:core`, `priority:high`

---

## Bug 사용 예시

**제목**: `[Bug] CLI crashes on DLL with no export table`

**본문**:
```markdown
## Description
Export 섹션이 없는 DLL을 분석할 때 `NullReferenceException` 발생.

## Steps to Reproduce
1. Export 없는 Native DLL 준비 (예: `nothing.dll`)
2. `reveng-cli analyze nothing.dll` 실행
3. Exception stack trace 발생

## Expected Behavior
Export 배열이 빈 상태로 정상 리포트 생성, exit code 0.

## Actual Behavior
Unhandled `NullReferenceException`, exit code 1.

## Version
v0.1.0

## Stack Trace
```
System.NullReferenceException: Object reference not set...
   at RevEngStudio.Analysis.Pe.ExportExtractor.Extract(...)
```
```

**라벨**: `bug`, `level:L1`, `area:analysis`, `priority:high`

---

## Spike 사용 예시

**제목**: `[Spike] Validate Ghidra Headless execution feasibility`

**본문**:
```markdown
## Question to Answer
Ghidra Headless Analyzer를 .NET 앱에서 외부 프로세스로 실행하고 JSON 결과를
받아올 수 있는가? 안정적이며 허용 가능한 시간(< 10분) 내에 가능한가?

## Timebox
1 day

## Approach
1. Ghidra 11.x 로컬 설치
2. 샘플 C++ DLL로 `analyzeHeadless.bat` 수동 실행
3. Post Script Java 템플릿 작성하여 JSON 출력
4. .NET `Process.Start()`로 래핑
5. 대형/소형 DLL 각 1개로 성능 측정

## Expected Output
- `spikes/S1-ghidra-poc/` 디렉토리에 PoC 코드
- `spikes/S1-ghidra-poc/DECISION.md` 결론 문서:
  - Feasibility (Yes/No)
  - 평균 소요 시간
  - 리스크 및 대응 방안
  - L4 착수 Go/No-Go 권고
```

**라벨**: `spike`, `level:L4`, `priority:high`

---

## 이슈 작성 체크리스트

### Task 이슈 작성 시
- [ ] 제목이 동사로 시작하는가?
- [ ] What / Why가 명확한가?
- [ ] DoD가 체크박스 형태인가?
- [ ] DoD 항목이 객관적으로 검증 가능한가?
- [ ] Estimate가 2~8시간 범위인가?
- [ ] Parent Epic이 연결되었는가?
- [ ] Level / Area / Priority 라벨이 부착되었는가?

### Epic 이슈 작성 시
- [ ] Description에 전체 맥락이 있는가?
- [ ] Goals가 측정 가능한가?
- [ ] Child Tasks가 식별되었는가 (이후 분할 가능)?

### Spike 이슈 작성 시
- [ ] Question이 명확한 Yes/No 또는 선택지 형태인가?
- [ ] Timebox가 설정되었는가?
- [ ] Expected Output이 구체적인가?

---

## Anti-Pattern

### 금지 사항
- ❌ 제목만 있는 이슈 (`"TODO"`, `"fix later"`)
- ❌ DoD 없는 Task
- ❌ 1일 초과 예상 Task (분할 필요)
- ❌ 여러 목적 섞인 Task (`"Add X and fix Y"`)
- ❌ 라벨 없는 이슈
