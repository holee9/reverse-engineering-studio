# 16. Pull Request Template

## 파일 위치
`.github/pull_request_template.md`

## 템플릿 내용

```markdown
## Summary
<!-- 이 PR이 무엇을 하는지 1~2줄로 -->

## Related Issue
Closes #

## Changes
<!-- 주요 변경사항 bullet list -->
-
-

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Refactor (no functional change)
- [ ] Documentation
- [ ] Chore / Infrastructure

## Definition of Done
<!-- 원본 이슈의 DoD를 복사하여 체크 -->
- [ ]
- [ ]
- [ ]

## Testing
<!-- 어떻게 검증했는가 -->
- [ ] Unit tests added/updated
- [ ] All tests pass locally (`dotnet test`)
- [ ] CI passing

## Checklist
- [ ] Self-reviewed the code
- [ ] Comments added for non-obvious logic
- [ ] Updated relevant documentation
- [ ] No new warnings introduced
- [ ] No commented-out code left behind
- [ ] Ready to squash-merge

## Screenshots (if applicable)
<!-- GUI 변경 시 Before/After 스크린샷 -->

## Notes for Reviewer (Future Self)
<!-- 미래의 내가 복기할 때 도움될 맥락 -->
```

---

## PR 작성 가이드

### 제목 규약
커밋 메시지와 동일한 Conventional Commits 형식:
```
<type>(<scope>): <subject>
```

예시:
- `feat(core): add DllTypeDetector`
- `fix(cli): handle missing file gracefully`
- `refactor(analysis): extract IMetadataExtractor interface`

### Summary 작성 팁
- "무엇을"이 아니라 "왜"에 집중
- 이슈 본문 반복하지 말 것 (링크로 충분)
- 1~3문장 이내

**좋은 예**:
> ILSpy 통합의 기반이 될 `IManagedAnalyzer` 인터페이스와 기본 구현을 추가합니다. L2 TypeExtractor 작업에 필요한 선행 작업입니다.

**나쁜 예**:
> 코드를 추가했습니다. 테스트도 했습니다.

### Changes 리스트
- 파일별이 아닌 **의미 단위**로 작성
- 구현 세부사항이 아닌 **외부 관찰 가능 변화**

### Self-Review 규칙
PR 생성 후 merge 전 반드시:
1. Files Changed 탭에서 모든 변경사항 재검토
2. 코멘트 달 부분에 스스로 코멘트 (의도 설명)
3. `git diff main...HEAD` 로컬에서도 한 번 더 확인

---

## Merge 전 최종 체크

### 자동 확인 (CI가 처리)
- 빌드 통과
- 테스트 통과
- 포맷 검증 통과

### 수동 확인
- [ ] PR 설명이 이슈를 Close하는지 (`Closes #N`)
- [ ] DoD 체크리스트 모두 통과
- [ ] 불필요한 파일 포함되지 않음 (`.vs/`, `bin/`, `obj/`, 개인 설정 등)
- [ ] 커밋 메시지가 의미 있는 단위로 정리됨
- [ ] Squash merge 선택 (일반적인 경우)

---

## Merge 전략

### Squash and merge (기본)
- feature 브랜치의 여러 커밋을 1개로 합침
- main 히스토리 깨끗하게 유지
- **99%의 경우 이걸 사용**

### Rebase and merge (예외)
- 커밋이 이미 매우 잘 정리된 경우
- 각 커밋이 독립적으로 의미 있을 때

### Merge commit (금지)
- 사용하지 않음
- main 히스토리 오염
