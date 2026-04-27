# 04. Backlog — L1: Surface Scan

**Milestone**: M1 — L1 Release
**Target Version**: v0.1
**Duration**: 3 days

---

## Epic Issues

### #E1. Repository & CI/CD Bootstrap
**Labels**: `epic`, `level:L1`, `area:infra`
**Description**: GitHub 저장소 초기 설정, CI/CD 파이프라인 구축

### #E2. PE Header Analysis Core
**Labels**: `epic`, `level:L1`, `area:core`
**Description**: PE 파일 파싱 및 메타데이터 추출 엔진

### #E3. CLI Infrastructure
**Labels**: `epic`, `level:L1`, `area:cli`
**Description**: 콘솔 애플리케이션 프레임, 인자 처리, JSON 출력

---

## Task Issues

### Infrastructure (E1 하위)

#### #T1. GitHub Repo 초기화 및 디렉토리 구조 셋업
**Labels**: `task`, `level:L1`, `area:infra`, `priority:high`
**Estimate**: 1h
**Parent**: #E1
**DoD**:
- [ ] Repo 생성 (private)
- [ ] 기본 `.gitignore` (C#/VS 템플릿)
- [ ] `README.md` 초안
- [ ] `LICENSE` (MIT 또는 Proprietary)
- [ ] 디렉토리 구조:
  ```
  src/
    RevEngStudio.Core/
    RevEngStudio.Cli/
  tests/
    RevEngStudio.Core.Tests/
  docs/
  .github/
    workflows/
    ISSUE_TEMPLATE/
  ```

#### #T2. .NET 8 솔루션 생성 및 프로젝트 참조 설정
**Labels**: `task`, `level:L1`, `area:infra`, `priority:high`
**Estimate**: 1h
**Parent**: #E1
**DoD**:
- [ ] `RevEngStudio.sln`
- [ ] Core (클래스 라이브러리), Cli (콘솔 앱), Tests (xUnit)
- [ ] Central Package Management (`Directory.Packages.props`)
- [ ] `dotnet build` 성공

#### #T3. Issue/PR 템플릿 생성
**Labels**: `task`, `level:L1`, `area:infra`, `priority:medium`
**Estimate**: 1h
**Parent**: #E1
**DoD**:
- [ ] `.github/ISSUE_TEMPLATE/epic.yml`
- [ ] `.github/ISSUE_TEMPLATE/task.yml`
- [ ] `.github/ISSUE_TEMPLATE/bug.yml`
- [ ] `.github/ISSUE_TEMPLATE/spike.yml`
- [ ] `.github/pull_request_template.md`

#### #T4. 라벨·마일스톤 일괄 생성 (GitHub CLI 스크립트)
**Labels**: `task`, `level:L1`, `area:infra`, `priority:medium`
**Estimate**: 1h
**Parent**: #E1
**DoD**:
- [ ] `scripts/setup-labels.sh` 작성
- [ ] 모든 라벨 생성 완료 (`12_Labels.md` 참조)
- [ ] M1~M5 마일스톤 생성

#### #T5. CI Workflow — Build & Test
**Labels**: `task`, `level:L1`, `area:infra`, `priority:high`
**Estimate**: 2h
**Parent**: #E1
**DoD**:
- [ ] `.github/workflows/ci.yml`
- [ ] PR 및 main push 시 트리거
- [ ] `dotnet restore → build → test` 단계
- [ ] 테스트 결과 artifact 업로드
- [ ] Branch protection: CI 통과 없이 merge 불가

#### #T6. CI Workflow — Code Format Check
**Labels**: `task`, `level:L1`, `area:infra`, `priority:medium`
**Estimate**: 1h
**Parent**: #E1
**DoD**:
- [ ] `.editorconfig` 작성
- [ ] `dotnet format --verify-no-changes` CI 단계 추가

#### #T7. CI Workflow — Release Build (Tag Trigger)
**Labels**: `task`, `level:L1`, `area:infra`, `priority:medium`
**Estimate**: 2h
**Parent**: #E1
**DoD**:
- [ ] `.github/workflows/release.yml`
- [ ] `v*` 태그 push 시 실행
- [ ] self-contained single-file publish
- [ ] GitHub Release 자동 생성 (binary 첨부)

---

### Core Analysis (E2 하위)

#### #T8. PeNet 패키지 통합 및 파일 로드 검증
**Labels**: `task`, `level:L1`, `area:core`, `priority:high`
**Estimate**: 2h
**Parent**: #E2
**DoD**:
- [ ] PeNet NuGet 추가
- [ ] `IPeLoader` 인터페이스 정의
- [ ] `PeLoader.Load(path)` 구현
- [ ] 잘못된 파일 경로·비-PE 파일 예외 처리
- [ ] 단위 테스트 3건 이상

#### #T9. DLL Type Detector 구현 (Managed/Native/Mixed)
**Labels**: `task`, `level:L1`, `area:core`, `priority:high`
**Estimate**: 3h
**Parent**: #E2
**DoD**:
- [ ] `DllTypeDetector` 클래스
- [ ] CLI Header 유무로 Managed 판별
- [ ] `enum DllType { Managed, Native, Mixed, Unknown }`
- [ ] 각 타입 샘플 DLL 테스트 통과

#### #T10. PE 메타데이터 추출 (아키텍처, 서브시스템, 엔트리포인트)
**Labels**: `task`, `level:L1`, `area:core`, `priority:high`
**Estimate**: 2h
**Parent**: #E2
**DoD**:
- [ ] `PeMetadata` 모델 클래스
- [ ] 아키텍처 (x86/x64/ARM64)
- [ ] Subsystem, Entry Point, Timestamp
- [ ] 단위 테스트 2건 이상

#### #T11. Export 함수 목록 추출
**Labels**: `task`, `level:L1`, `area:core`, `priority:high`
**Estimate**: 2h
**Parent**: #E2
**DoD**:
- [ ] `ExportedFunction` 모델 (Name, Ordinal, Address, RVA)
- [ ] Export 없는 DLL 처리 (빈 리스트 반환)
- [ ] 테스트: 최소 1개 Export 있는 DLL로 검증

#### #T12. Import 의존성 추출
**Labels**: `task`, `level:L1`, `area:core`, `priority:high`
**Estimate**: 2h
**Parent**: #E2
**DoD**:
- [ ] `ImportedDll` 모델 (DllName, Functions)
- [ ] DLL별 그룹핑
- [ ] 테스트 통과

#### #T13. Section 정보 추출
**Labels**: `task`, `level:L1`, `area:core`, `priority:medium`
**Estimate**: 1h
**Parent**: #E2
**DoD**:
- [ ] `SectionInfo` 모델 (Name, Size, Characteristics)
- [ ] 테스트 통과

#### #T14. 파일 해시 계산 (SHA256)
**Labels**: `task`, `level:L1`, `area:core`, `priority:medium`
**Estimate**: 1h
**Parent**: #E2
**DoD**:
- [ ] SHA256 계산 유틸리티
- [ ] 대용량 파일 스트리밍 처리

#### #T15. 통합 Report 모델 및 Aggregator
**Labels**: `task`, `level:L1`, `area:core`, `priority:high`
**Estimate**: 2h
**Parent**: #E2
**DoD**:
- [ ] `SurfaceScanReport` 클래스 (모든 결과 통합)
- [ ] `IAnalyzer` 인터페이스 정의
- [ ] `SurfaceScanAnalyzer` 구현
- [ ] 통합 테스트 통과

---

### CLI (E3 하위)

#### #T16. CLI 인자 파서 통합 (System.CommandLine)
**Labels**: `task`, `level:L1`, `area:cli`, `priority:high`
**Estimate**: 2h
**Parent**: #E3
**DoD**:
- [ ] `System.CommandLine` NuGet 추가
- [ ] `reveng-cli analyze <dll-path> [--output <json>] [--verbose]`
- [ ] `--help` 출력 확인

#### #T17. JSON 출력 포맷터
**Labels**: `task`, `level:L1`, `area:cli`, `priority:high`
**Estimate**: 2h
**Parent**: #E3
**DoD**:
- [ ] `System.Text.Json` 직렬화
- [ ] Indented 출력
- [ ] Enum → String 변환 설정
- [ ] 파일 또는 stdout 출력

#### #T18. 콘솔 출력 포맷터 (사람이 읽기 좋은 형태)
**Labels**: `task`, `level:L1`, `area:cli`, `priority:medium`
**Estimate**: 2h
**Parent**: #E3
**DoD**:
- [ ] 섹션별 구분 출력
- [ ] Export/Import 테이블 형태
- [ ] 컬러링 (선택)

#### #T19. 에러 핸들링 및 Exit Code
**Labels**: `task`, `level:L1`, `area:cli`, `priority:high`
**Estimate**: 1h
**Parent**: #E3
**DoD**:
- [ ] 파일 없음 → exit 2
- [ ] 비-PE 파일 → exit 3
- [ ] 예상치 못한 에러 → exit 1
- [ ] 정상 → exit 0

---

### Validation & Release

#### #T20. 샘플 DLL 테스트 세트 수집
**Labels**: `task`, `level:L1`, `area:test`, `priority:high`
**Estimate**: 2h
**DoD**:
- [ ] Managed 샘플 2개
- [ ] Native 샘플 2개
- [ ] Mixed 샘플 1개 (가능하면)
- [ ] `tests/samples/README.md`에 출처 기록

#### #T21. L1 JSON 출력 스키마 문서화
**Labels**: `task`, `level:L1`, `area:docs`, `priority:medium`
**Estimate**: 1h
**DoD**:
- [ ] `docs/L1_Output_Schema.md`
- [ ] 모든 필드 설명
- [ ] 예시 JSON 포함

#### #T22. L1 Checkpoint Review
**Labels**: `task`, `level:L1`, `priority:high`
**Estimate**: 1h
**DoD**:
- [ ] 모든 L1 DoD 체크리스트 통과 확인
- [ ] 실제 타겟 DLL 1개 분석 결과 검토
- [ ] L2 진행 여부 결정 (Go / No-Go)

#### #T23. v0.1 Release
**Labels**: `task`, `level:L1`, `area:infra`, `priority:high`
**Estimate**: 30m
**DoD**:
- [ ] CHANGELOG.md 업데이트
- [ ] `git tag v0.1.0`
- [ ] CI 릴리즈 워크플로우 성공 확인
- [ ] GitHub Release 노트 작성

---

## 착수 순서 권장

```
Day 1 오전: T1 → T2 → T3 → T4
Day 1 오후: T5 → T6 → T8 → T9
Day 2 오전: T10 → T11 → T12 → T13 → T14
Day 2 오후: T15 → T16 → T17
Day 3 오전: T18 → T19 → T20
Day 3 오후: T7 → T21 → T22 → T23
```

## 총 예상 시간

- Infrastructure: ~8h
- Core: ~15h
- CLI: ~7h
- Validation & Release: ~4.5h
- **합계: ~34.5h** (3일 기준 11.5h/일 → 버퍼 포함하여 3.5~4일 예상)
