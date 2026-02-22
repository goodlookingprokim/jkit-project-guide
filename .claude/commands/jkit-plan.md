# Jkit Plan — Project Planning

**Agent**: Use the `vibe-cto` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

Turn the discovered project idea into an actionable implementation plan.
VibeCTO creates the plan, delegating architecture design to arch-mentor.

## Input

`$ARGUMENTS` — Feature or project name to plan. If empty, plan the full project.

## Planning Steps

### Step 1: Requirements (TCREI Pattern)
Read `golden-rabbit-antigravity-v1/prompts/prompts.md` for prompt pattern reference.
Structure requirements using TCREI:

- **T**ask: What the feature/project does
- **C**ontext: User's skill level (beginner), tech stack, existing code
- **R**equirements: Specific features with acceptance criteria
- **E**xamples: Reference golden-rabbit code that matches
- **I**mprovements: Error handling, edge cases, security considerations

Present to user and confirm with AskUserQuestion.

### Step 2: Architecture Design
Delegate to `arch-mentor` via Task():
- Design folder structure based on Clean Architecture
- Reference the appropriate golden-rabbit project structure
- Define domain entities, use-cases, and repository interfaces

Explain the architecture to the user in simple terms:
"코드를 이렇게 나누는 이유는..."

### Step 3: Feature Breakdown & Order
Break the project into implementable features. Order by dependency:

```
Example order:
1. 프로젝트 초기화 (scaffolding, dependencies)
2. 도메인 엔티티 정의
3. 핵심 기능 A (UseCase + Test + Repository + UI)
4. 핵심 기능 B (UseCase + Test + Repository + UI)
5. 인증 연동
6. 결제/구독 (if SaaS)
7. 배포
```

Each feature should include:
- What it does (1 sentence)
- Which golden-rabbit reference to follow
- Which agents will be involved
- Estimated complexity (간단 / 보통 / 복잡)

### Step 4: Confirmation
Use AskUserQuestion:
"이 순서로 진행할까요? 먼저 구현하고 싶은 기능이 있으면 말씀해 주세요."

### Step 5: Transition
After confirmation:
"좋습니다! `/jkit-build [기능이름]`으로 첫 번째 기능 구현을 시작해 볼까요?"
