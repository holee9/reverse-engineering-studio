# 10. Git Flow

## 브랜치 전략

### 기본 구조 (단순화된 Trunk-Based)

```
main         ◄── 항상 릴리즈 가능 상태, 보호됨
 │
 ├─ feature/123-add-pe-loader        ◄── 이슈 기반 단기 브랜치
 ├─ feature/145-wpf-shell
 ├─ fix/152-export-encoding
 └─ spike/160-ghidra-poc
```

**규칙**:
- `develop` 브랜치 없음 (1인 개발, 오버헤드 회피)
- 모든 변경은 `feature/*` 또는 `fix/*` 브랜치에서 PR로 진행
- PR → CI 통과 → Self-merge → 브랜치 삭제

## 브랜치 명명

```
<type>/<issue-number>-<short-slug>

예:
feature/12-pe-loader
feature/34-wpf-treeview
fix/87-null-export-crash
spike/110-ghidra-poc
docs/50-update-readme
chore/22-bump-dependencies
```

### Type 종류
| Type | 용도 |
|------|------|
| `feature` | 신규 기능 |
| `fix` | 버그 수정 |
| `spike` | 탐색적 실험 |
| `docs` | 문서 변경 |
| `chore` | 빌드·설정 변경 |
| `refactor` | 기능 변경 없는 리팩터링 |
| `test` | 테스트 추가·개선 |

---

## 브랜치 보호 규칙 (main)

GitHub Settings → Branches → main:

- [x] Require pull request before merging
- [x] Require status checks to pass before merging
  - `ci / build`
  - `ci / test`
  - `ci / format-check`
- [x] Require branches to be up to date before merging
- [x] Require linear history (rebase only)
- [x] Do not allow bypassing the above settings

---

## 커밋 전략

### 작업 중
- 원하는 만큼 작은 커밋 유지 (로컬 체크포인트)
- WIP 커밋 허용

### PR 전
- `git rebase -i` 로 의미 있는 단위로 정리
- 최종 PR의 커밋 수: **1~5개 권장**

### 머지
- **Squash and merge** 기본 (feature 브랜치 → main)
- 매우 잘 정리된 PR은 **Rebase and merge** 허용
- Merge commit 금지

---

## 커밋 메시지 (Conventional Commits)

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 예시
```
feat(core): add DllTypeDetector for managed/native classification

Detects CLI header presence to distinguish .NET assemblies from
native DLLs. Mixed (C++/CLI) classification deferred to L4.

Closes #12
```

```
fix(cli): handle missing file with proper exit code

Previously threw unhandled exception; now returns exit code 2
with user-friendly message.

Fixes #87
```

### Type 종류 (커밋용)
| Type | 의미 |
|------|------|
| `feat` | 신규 기능 |
| `fix` | 버그 수정 |
| `docs` | 문서 |
| `style` | 포매팅 (기능 변경 없음) |
| `refactor` | 리팩터링 |
| `test` | 테스트 |
| `chore` | 빌드, 설정, 의존성 |
| `perf` | 성능 개선 |
| `ci` | CI/CD 변경 |

### Scope (선택)
- `core`, `analysis`, `cli`, `wpf`, `export`, `ci`, `docs`

### Footer (이슈 연동)
- `Closes #123` — 이슈 자동 Close
- `Fixes #87` — 버그 이슈 Close
- `Refs #45` — 참조만 (Close 안 함)

---

## 일일 개발 플로우

```bash
# 1. 이슈 선정 후 최신 main 기준 브랜치
git checkout main
git pull
git checkout -b feature/12-pe-loader

# 2. 개발 + 로컬 커밋
git add -p
git commit -m "feat(core): add PE file loader skeleton"
# ... 반복 ...

# 3. 커밋 정리 (필요 시)
git rebase -i main

# 4. Push + PR
git push -u origin feature/12-pe-loader
gh pr create --fill --label "level:L1,area:core"

# 5. CI 통과 대기 → Self-review → Merge
gh pr merge --squash --delete-branch

# 6. 로컬 정리
git checkout main
git pull
git branch -d feature/12-pe-loader
```

---

## 태그 및 릴리즈

### 버전 규칙 (SemVer)
```
v<MAJOR>.<MINOR>.<PATCH>

L1 → v0.1.0
L2 → v0.2.0
L3 → v0.3.0
L4 → v0.4.0
L5 → v1.0.0

패치 릴리즈: v0.1.1, v0.1.2, ...
```

### 태그 생성 흐름
```bash
# main에서 최신 상태 확인
git checkout main && git pull

# CHANGELOG.md 업데이트 후 커밋
git commit -am "chore: release v0.1.0"
git push

# 태그 생성 + push → CI 릴리즈 워크플로우 자동 실행
git tag -a v0.1.0 -m "Release v0.1.0: Surface Scan"
git push origin v0.1.0
```

---

## 충돌 해결 (참고)

1인 개발이므로 충돌 드묾. 발생 시:

```bash
# feature 브랜치에서
git fetch origin
git rebase origin/main
# 충돌 해결 후
git add .
git rebase --continue
git push --force-with-lease
```

**절대 금지**: `git push --force` (use `--force-with-lease` only)
