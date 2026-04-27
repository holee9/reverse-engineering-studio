# 13. CI/CD Strategy

## 원칙

1. **모든 PR에 CI 필수**: 통과 없이는 머지 금지
2. **빠른 피드백**: 전체 CI 5분 이내 완료 목표
3. **로컬 = CI**: 로컬에서 실행 가능한 스크립트로 CI 구성
4. **릴리즈 자동화**: 태그 푸시 → 빌드 → GitHub Release 자동 생성

## 파이프라인 구조

```
┌─────────────────────────────────────────────────────┐
│  Trigger: PR or push to main                         │
├─────────────────────────────────────────────────────┤
│  ci.yml (On every PR/push)                          │
│    1. Checkout                                       │
│    2. Setup .NET 8                                   │
│    3. Restore                                        │
│    4. Format Check (dotnet format --verify)          │
│    5. Build (Release config)                         │
│    6. Test (with coverage)                           │
│    7. Upload test results + coverage artifact        │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│  Trigger: Push tag v*                                │
├─────────────────────────────────────────────────────┤
│  release.yml (On version tag)                       │
│    1. Checkout (tag)                                 │
│    2. Setup .NET 8                                   │
│    3. Build + Test (regression)                      │
│    4. Publish (self-contained, win-x64)              │
│    5. Zip artifacts                                  │
│    6. Create GitHub Release                          │
│    7. Upload assets                                  │
└─────────────────────────────────────────────────────┘
```

## 레벨별 CI 확장

| Level | 추가되는 CI 단계 |
|-------|------------------|
| L1 | Base: restore, build, test, format |
| L2 | WPF 빌드 추가 (`windows-latest` 러너) |
| L3 | 그래프 렌더링 스모크 테스트 |
| L4 | Ghidra 통합 테스트 (수동 트리거) |
| L5 | 생성된 Markdown 템플릿 검증 |

## 빌드 매트릭스

### PR/CI 빌드
- OS: `windows-latest`
- .NET: 8.0.x
- Configuration: `Release`

### 릴리즈 빌드
- OS: `windows-latest`
- Target: `win-x64`
- 형태: self-contained single-file executable

## 성공 기준

### CI (ci.yml)
- 모든 프로젝트 빌드 성공 (경고 0 허용, 에러 0)
- 모든 테스트 통과
- 포맷 검증 통과
- 코드 커버리지 레벨별 목표 이상

### Release (release.yml)
- CI 재실행 성공
- Publish 성공
- Zip 생성 성공
- GitHub Release 생성 성공

---

## 로컬에서 CI 재현

개발자가 CI와 동일한 명령을 로컬 실행할 수 있어야 함.

`scripts/ci-local.ps1`:
```powershell
# CI 파이프라인 로컬 재현
param([string]$Config = "Release")

Write-Host "=== Restore ===" -ForegroundColor Cyan
dotnet restore
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== Format Check ===" -ForegroundColor Cyan
dotnet format --verify-no-changes
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== Build ===" -ForegroundColor Cyan
dotnet build -c $Config --no-restore
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== Test ===" -ForegroundColor Cyan
dotnet test -c $Config --no-build --collect:"XPlat Code Coverage"
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== CI Checks Passed ===" -ForegroundColor Green
```

사용:
```powershell
./scripts/ci-local.ps1
```

---

## Secrets 관리

### 필요한 GitHub Secrets
L1~L4에서는 필요 없음. L5 이후 고려:
- (선택) 코드 사이닝 인증서 — self-signed도 가능
- (선택) Snyk / CodeQL 토큰 — 보안 스캔

### 환경 변수 (public)
- `DOTNET_VERSION: '8.0.x'`
- `BUILD_CONFIG: 'Release'`

---

## 캐싱 전략

- `~/.nuget/packages` 캐시로 restore 시간 단축
- 커밋 해시 기반 캐시 키
- 캐시 만료: 7일

---

## 실패 대응

### CI 실패 시 Triage
1. 로그 확인 (`gh run view --log`)
2. 로컬 재현 (`scripts/ci-local.ps1`)
3. 원인에 따라:
   - 코드 문제 → 수정 후 push
   - 환경 문제 → 재실행 (`gh run rerun <run-id>`)
   - 의존성 문제 → 캐시 삭제 후 재실행

### 자주 발생하는 실패
- 포맷 실패 → `dotnet format` 로컬 실행 후 재커밋
- 테스트 flaky → 재실행 1회, 계속 실패 시 이슈 생성
- Restore 실패 → NuGet 피드 상태 확인, 캐시 삭제

---

## 미래 확장 (Out of MVP)

- Dependabot 자동 의존성 업데이트
- CodeQL 보안 스캔
- 릴리즈 노트 자동 생성 (`release-drafter`)
- 사이닝된 바이너리 배포
