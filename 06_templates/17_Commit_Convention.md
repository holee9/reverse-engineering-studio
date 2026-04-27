# 17. Commit Convention

## Conventional Commits 기반

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Subject 규칙
- 소문자로 시작
- 명령형 현재 시제 (`add` O, `added` X, `adds` X)
- 마침표 없음
- 50자 이내

### Body 규칙 (선택)
- Subject와 빈 줄 분리
- 72자 내 줄바꿈
- **왜** 그렇게 했는지 설명
- **무엇을** 변경했는지가 아니라

### Footer 규칙 (선택)
- 이슈 참조: `Closes #N`, `Fixes #N`, `Refs #N`
- BREAKING CHANGE 명시

---

## Type 목록

| Type | 용도 | 예시 |
|------|------|------|
| `feat` | 신규 기능 | `feat(core): add DllTypeDetector` |
| `fix` | 버그 수정 | `fix(cli): handle null export table` |
| `docs` | 문서 | `docs: update README with L1 usage` |
| `style` | 포매팅, 세미콜론 (기능 영향 없음) | `style: apply dotnet format` |
| `refactor` | 기능 변경 없는 코드 개선 | `refactor(analysis): extract IExtractor` |
| `perf` | 성능 개선 | `perf(analysis): cache PE reads` |
| `test` | 테스트 추가·수정 | `test(core): add DllTypeDetector tests` |
| `chore` | 빌드·설정·의존성 | `chore: bump PeNet to 4.1.0` |
| `ci` | CI/CD 변경 | `ci: add format check to workflow` |
| `build` | 빌드 시스템 | `build: enable central package management` |

---

## Scope 목록

| Scope | 영역 |
|-------|------|
| `core` | RevEngStudio.Core |
| `analysis` | RevEngStudio.Analysis |
| `cli` | RevEngStudio.Cli |
| `wpf` | RevEngStudio.Wpf |
| `export` | RevEngStudio.Export |
| `ci` | CI/CD 워크플로우 |
| `deps` | 의존성 변경 |
| `docs` | 문서 |

Scope 생략 가능 (전역 변경 시).

---

## 실제 예시

### 좋은 예 1: 단순 기능 추가
```
feat(core): add DllTypeDetector for PE type classification

Detects CLI header presence to distinguish .NET, native, and mixed
C++/CLI DLLs. Mixed detection currently returns Managed; proper
mixed-mode handling deferred to L4.

Closes #9
```

### 좋은 예 2: 버그 수정
```
fix(cli): return exit code 2 when file not found

Previously threw FileNotFoundException to stderr; now catches it
early and returns a user-friendly message with proper exit code.

Fixes #87
```

### 좋은 예 3: 리팩터링
```
refactor(analysis): extract IMetadataExtractor interface

Prepares for L2 by allowing injection of multiple extractors.
No functional change.
```

### 좋은 예 4: 의존성 업데이트
```
chore(deps): bump ICSharpCode.Decompiler to 9.1.0

Includes bug fixes for generic constraint parsing. Tested against
L2 sample DLLs without regression.
```

### 좋은 예 5: 문서
```
docs: add L1 output schema reference

Closes #21
```

---

## 나쁜 예와 수정

### ❌ 너무 모호
```
update code
```
✅ 수정:
```
refactor(core): rename IAnalyzer.Execute to AnalyzeAsync
```

### ❌ 과거형, 마침표
```
Added a new feature.
```
✅ 수정:
```
feat(cli): add --verbose flag
```

### ❌ 여러 변경 섞음
```
feat: add detector and fix bug and update docs
```
✅ 수정: 3개의 커밋으로 분리
```
feat(core): add DllTypeDetector
fix(cli): handle empty export table
docs: document L1 JSON schema
```

### ❌ 이슈 번호 누락
```
feat(core): add PE loader
```
✅ 수정:
```
feat(core): add PE loader

Wraps PeNet library with IPeLoader abstraction for testability.

Closes #8
```

---

## 커밋 작성 흐름

### 로컬 개발 중
작은 커밋 자유롭게 (WIP 포함):
```
wip: trying XYZ approach
wip: debugging null ref
wip: tests passing now
```

### PR 준비 시 (rebase -i)
의미 단위로 재조합:
```bash
git rebase -i main
# pick → squash 로 묶기
# 최종 커밋 메시지 작성
```

결과:
```
feat(core): add DllTypeDetector with full test coverage

Implements CLI header check for .NET assembly detection. Covers
Managed/Native/Mixed types with unit tests on fixture DLLs.

Closes #9
```

### Merge 시
- **Squash merge**: 여러 커밋 → 1개 (PR 제목이 커밋 메시지)
- **Rebase merge**: 이미 잘 정리된 경우만

---

## 자주 쓰는 패턴

### Revert
```
revert: revert "feat(core): add DllTypeDetector"

This reverts commit <SHA>.

Reason: breaks Mixed DLL detection. To be reimplemented in #120.
```

### Breaking Change
```
feat(core)!: change IAnalyzer signature to async

BREAKING CHANGE: IAnalyzer.Analyze is now AnalyzeAsync returning Task.
All implementations must be updated.
```

### Multi-issue 참조
```
fix(analysis): handle exception cascade in metadata extractors

Closes #45
Closes #46
Refs #50
```

---

## 자동화 도움

### Git hooks (선택)
`commitlint` 또는 `husky` 없이도 충분. 필요 시 `.gitmessage` 템플릿:

```bash
git config commit.template .gitmessage
```

`.gitmessage`:
```
# <type>(<scope>): <subject>   (50 chars)
#
# <body> (72 chars per line)
#
# <footer>
#   Closes #
#
# Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build
# Scopes: core, analysis, cli, wpf, export, ci, deps, docs
```
