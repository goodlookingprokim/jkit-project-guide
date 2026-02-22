# Jkit Review — Code Review & Architecture Verification

**Agent**: Use the `arch-mentor` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

Review current codebase for architecture compliance, code quality,
and suggest improvements. Explain everything at beginner level.

## Input

`$ARGUMENTS` — Scope of review. Can be:
- A specific directory or file path
- A feature name
- Empty for full project review

## Review Steps

### Step 1: Architecture Compliance Check
Scan all source files and verify the dependency rule:

1. **Domain layer** (`src/core/domain/`):
   - Must NOT import from `infrastructure/`, `app/`, or external frameworks
   - Check all import statements

2. **Application layer** (`src/core/application/`):
   - Must NOT import from `infrastructure/` or `app/`
   - Use-cases must receive interfaces via constructor (DI)

3. **Infrastructure layer** (`src/infrastructure/`):
   - Must implement interfaces from `application/interfaces/`
   - External dependencies (Supabase, etc.) confined here

4. **Presentation layer** (`src/app/`, `src/components/`):
   - Must NOT import from `infrastructure/` directly
   - Business logic must go through Server Actions (Composition Root)

Report violations clearly:
```
⚠️ 의존성 규칙 위반 발견:
- src/components/NoteList.tsx가 src/infrastructure/에서 직접 import하고 있습니다
  → Server Action을 통해 데이터를 가져와야 합니다
```

### Step 2: Code Quality Review
Check for common issues:
- Code duplication
- Naming conventions (PascalCase components, camelCase functions)
- Missing error handling
- Unused imports or variables
- Smart UI anti-pattern (business logic in components)

### Step 3: Test Coverage Analysis
- Check which layers have tests
- Identify critical untested code
- Recommend testing priorities

### Step 4: Improvement Suggestions
For each issue found:
1. Explain WHAT the problem is (in simple terms)
2. Explain WHY it matters
3. Show HOW to fix it (with code example from golden-rabbit reference)

Use AskUserQuestion: "이 개선 사항들을 적용할까요?"

### Step 5: Summary
```
📊 코드 리뷰 결과:
- 아키텍처 준수: ✅ / ⚠️ (N개 위반)
- 코드 품질: 좋음 / 개선 필요
- 테스트 커버리지: N%
- 개선 제안: N개
```
