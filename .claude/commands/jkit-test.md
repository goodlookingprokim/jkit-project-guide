# Jkit Test — TDD Workflow

**Agent**: Use the `tdd-coach` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

Apply Test-Driven Development to the current project.
Write tests first, then implement, then refactor.

## Input

`$ARGUMENTS` — Scope of testing. Can be:
- A specific feature name (e.g., "login", "create-note")
- A specific file path
- "all" to run all tests
- Empty to analyze what needs testing

## Workflow

### If $ARGUMENTS is empty: Analyze Test Coverage
1. Scan the project for existing tests
2. Identify untested code (use-cases, entities, repositories)
3. Present a testing priority list:
   "다음 코드에 대한 테스트가 필요합니다:"
4. Ask which to test first

### If $ARGUMENTS specifies a feature: TDD Cycle

#### Phase 1: RED (실패하는 테스트 작성)
1. Read the golden-rabbit reference test pattern for the matching layer:
   - Domain entities → Read `golden-rabbit-antigravity-v1/10/ecommerce/src/core/domain/entities/Product.test.ts`
   - Use cases → Read `golden-rabbit-antigravity-v1/11/saas/src/core/application/use-cases/` matching spec
   - Repositories → Read `golden-rabbit-antigravity-v1/10/ecommerce/src/infrastructure/repositories/` matching test
2. Write a failing test based on the pattern
3. Run the test — confirm it fails
4. Explain to user: "이 테스트는 [기능]이 [이렇게] 동작해야 한다는 것을 정의합니다."

#### Phase 2: GREEN (최소한의 코드로 통과)
1. Write the minimum code to make the test pass
2. Run the test — confirm it passes
3. Explain: "테스트를 통과하기 위해 필요한 최소한의 코드만 작성했어요."

#### Phase 3: REFACTOR (코드 품질 개선)
1. Review the code for improvements
2. Apply Clean Architecture patterns
3. Run tests — confirm they still pass
4. Explain what was improved and why

### After TDD Cycle
Present results:
```
✅ TDD 사이클 완료!
- 작성된 테스트: N개
- 통과: N개
- 커버리지: N%
```

Suggest: "다음 기능의 테스트를 작성할까요? 아니면 /jkit-build로 돌아갈까요?"
