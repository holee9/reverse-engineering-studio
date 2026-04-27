# 12. Labels & Milestones

## 라벨 체계

라벨은 **4개 카테고리**로 제한. 복잡도 관리 최우선.

### 1. Type (이슈 종류)

| 라벨 | 색상 | 용도 |
|------|------|------|
| `epic` | `#8B00FF` | 대규모 기능 단위 (여러 Task 포함) |
| `task` | `#0E8A16` | 일반 작업 단위 |
| `bug` | `#D73A4A` | 버그 수정 |
| `spike` | `#FBCA04` | 탐색적 조사 (timeboxed) |
| `docs` | `#1D76DB` | 문서 전용 |
| `chore` | `#C5DEF5` | 설정·의존성·빌드 |

### 2. Level (레벨)

| 라벨 | 색상 |
|------|------|
| `level:L1` | `#E99695` |
| `level:L2` | `#F9D0C4` |
| `level:L3` | `#FEF2C0` |
| `level:L4` | `#C2E0C6` |
| `level:L5` | `#BFD4F2` |

### 3. Area (영역)

| 라벨 | 색상 |
|------|------|
| `area:core` | `#5319E7` |
| `area:analysis` | `#5319E7` |
| `area:cli` | `#006B75` |
| `area:wpf` | `#006B75` |
| `area:export` | `#006B75` |
| `area:infra` | `#B60205` |
| `area:ci` | `#B60205` |
| `area:test` | `#0075CA` |
| `area:docs` | `#0075CA` |

### 4. Priority (우선순위)

| 라벨 | 색상 |
|------|------|
| `priority:high` | `#B60205` |
| `priority:medium` | `#FBCA04` |
| `priority:low` | `#CFD3D7` |

### 5. Status (상태, 선택)

| 라벨 | 색상 |
|------|------|
| `status:blocked` | `#000000` |
| `status:needs-discussion` | `#5319E7` |
| `wontfix` | `#FFFFFF` |

---

## 라벨 사용 규칙

### 필수 라벨 (모든 이슈)
- Type 1개
- Level 1개 (해당 없으면 생략)
- Priority 1개

### 선택 라벨
- Area 1~2개
- Status (특수 상황)

### 예시
```
Type: task
Level: level:L1
Area: area:core
Priority: priority:high
```

---

## 마일스톤

### 레벨별 마일스톤

| Milestone | 기간 | 완료 기준 |
|-----------|------|----------|
| **M1 — L1 Release (v0.1)** | +3 days | L1 DoD 전체 통과 |
| **M2 — L2 Release (v0.2)** | +1.5 weeks | L2 DoD 전체 통과 |
| **M3 — L3 Release (v0.3)** | +3 weeks | L3 DoD 전체 통과 |
| **M4 — L4 Release (v0.4)** | +5 weeks | L4 DoD 전체 통과 |
| **M5 — L5 Release (v1.0)** | +7~9 weeks | L5 DoD 전체 통과 |

### 마일스톤 관리 원칙

- **Due Date 설정** (동기 부여)
- **레벨 시작 시 모든 Task를 해당 마일스톤 할당**
- **마일스톤 완료 = 태그 릴리즈 + 체크포인트 리뷰**
- 미완료 이슈는 다음 마일스톤으로 이관 또는 `wontfix`

---

## GitHub CLI 라벨 생성 스크립트

`scripts/setup-labels.sh`:

```bash
#!/bin/bash
# RevEng Studio GitHub Labels Setup
# Usage: ./setup-labels.sh <owner/repo>

REPO=$1
if [ -z "$REPO" ]; then
  echo "Usage: $0 <owner/repo>"
  exit 1
fi

# 기본 라벨 삭제 (선택)
gh label delete "good first issue" --repo "$REPO" --yes 2>/dev/null
gh label delete "help wanted" --repo "$REPO" --yes 2>/dev/null
gh label delete "question" --repo "$REPO" --yes 2>/dev/null
gh label delete "duplicate" --repo "$REPO" --yes 2>/dev/null
gh label delete "invalid" --repo "$REPO" --yes 2>/dev/null

# Type
gh label create "epic" --color "8B00FF" --description "Large feature unit containing multiple tasks" --repo "$REPO" --force
gh label create "task" --color "0E8A16" --description "Standard work unit" --repo "$REPO" --force
gh label create "bug" --color "D73A4A" --description "Bug fix" --repo "$REPO" --force
gh label create "spike" --color "FBCA04" --description "Exploratory investigation (timeboxed)" --repo "$REPO" --force
gh label create "docs" --color "1D76DB" --description "Documentation only" --repo "$REPO" --force
gh label create "chore" --color "C5DEF5" --description "Config, deps, build" --repo "$REPO" --force

# Level
gh label create "level:L1" --color "E99695" --description "Surface Scan" --repo "$REPO" --force
gh label create "level:L2" --color "F9D0C4" --description "Signature Extract" --repo "$REPO" --force
gh label create "level:L3" --color "FEF2C0" --description "Structure Map" --repo "$REPO" --force
gh label create "level:L4" --color "C2E0C6" --description "Behavior Analysis" --repo "$REPO" --force
gh label create "level:L5" --color "BFD4F2" --description "Document Synthesis" --repo "$REPO" --force

# Area
gh label create "area:core" --color "5319E7" --description "Core domain" --repo "$REPO" --force
gh label create "area:analysis" --color "5319E7" --description "Analysis engine" --repo "$REPO" --force
gh label create "area:cli" --color "006B75" --description "CLI frontend" --repo "$REPO" --force
gh label create "area:wpf" --color "006B75" --description "WPF GUI" --repo "$REPO" --force
gh label create "area:export" --color "006B75" --description "Export and generation" --repo "$REPO" --force
gh label create "area:infra" --color "B60205" --description "Infrastructure" --repo "$REPO" --force
gh label create "area:ci" --color "B60205" --description "CI/CD pipelines" --repo "$REPO" --force
gh label create "area:test" --color "0075CA" --description "Testing" --repo "$REPO" --force
gh label create "area:docs" --color "0075CA" --description "Documentation" --repo "$REPO" --force

# Priority
gh label create "priority:high" --color "B60205" --description "Urgent, 1-3 days" --repo "$REPO" --force
gh label create "priority:medium" --color "FBCA04" --description "Normal, 1-2 weeks" --repo "$REPO" --force
gh label create "priority:low" --color "CFD3D7" --description "Nice-to-have" --repo "$REPO" --force

# Status
gh label create "status:blocked" --color "000000" --description "Blocked by external dependency" --repo "$REPO" --force
gh label create "status:needs-discussion" --color "5319E7" --description "Requires decision" --repo "$REPO" --force
gh label create "wontfix" --color "FFFFFF" --description "Will not be implemented" --repo "$REPO" --force

echo "Labels created successfully for $REPO"
```

## 마일스톤 생성 스크립트

`scripts/setup-milestones.sh`:

```bash
#!/bin/bash
REPO=$1

gh api "repos/$REPO/milestones" -X POST \
  -f title="M1 — L1 Release (v0.1)" \
  -f description="Surface Scan — PE header extraction" \
  -f due_on="$(date -d '+3 days' -Iseconds)"

gh api "repos/$REPO/milestones" -X POST \
  -f title="M2 — L2 Release (v0.2)" \
  -f description="Signature Extract — C# decompilation, WPF GUI" \
  -f due_on="$(date -d '+12 days' -Iseconds)"

gh api "repos/$REPO/milestones" -X POST \
  -f title="M3 — L3 Release (v0.3)" \
  -f description="Structure Map — Call graph visualization" \
  -f due_on="$(date -d '+24 days' -Iseconds)"

gh api "repos/$REPO/milestones" -X POST \
  -f title="M4 — L4 Release (v0.4)" \
  -f description="Behavior Analysis — Ghidra integration" \
  -f due_on="$(date -d '+42 days' -Iseconds)"

gh api "repos/$REPO/milestones" -X POST \
  -f title="M5 — L5 Release (v1.0)" \
  -f description="Document Synthesis — Markdown/Doc generation" \
  -f due_on="$(date -d '+63 days' -Iseconds)"

echo "Milestones created for $REPO"
```
