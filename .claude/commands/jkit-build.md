# Jkit Build — Feature Implementation

**Agent**: Use the `vibe-cto` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

Build a specific feature. VibeCTO coordinates the specialist agents
to implement it step by step, explaining everything to the beginner user.

## Input

`$ARGUMENTS` — Feature name or description to build.
If empty, check project status and suggest the next feature to implement.

## Implementation Flow

### Step 1: Feature Analysis
1. Read the project plan (if exists) to understand the feature's context
2. Identify which golden-rabbit reference code to follow
3. Break the feature into sub-tasks

Present to user: "이 기능을 구현하기 위해 이런 순서로 진행할게요:"

### Step 2: Architecture Setup (if needed)
If this is the first feature or requires new architecture:
- Delegate to `arch-mentor` via Task(): Create folder structure, interfaces, entities
- Reference the matching golden-rabbit architecture pattern
- Explain to user what was created and why

### Step 3: TDD Cycle (for business logic)
For each sub-task involving business logic:
- Delegate to `tdd-coach` via Task(): Write failing test first
- After test is written, implement minimum code to pass
- Run tests to verify

Explain the TDD cycle to user:
"먼저 테스트를 작성해서 '이 코드가 이렇게 동작해야 한다'를 정의하고, 그 다음에 실제 코드를 작성할게요."

### Step 4: UI Implementation (if needed)
For visual components:
- Delegate to `frontend-buddy` via Task(): Build UI components and pages
- Reference golden-rabbit's matching UI patterns
- Show the user what was built

### Step 5: Backend Integration (if needed)
For database, auth, API, or payment work:
- Delegate to `saas-guide` via Task(): Handle backend integration
- Reference golden-rabbit's matching backend patterns
- Explain the integration to user

### Step 6: Verification
After implementation:
1. Run all tests
2. Check for any errors
3. Summarize what was built

Ask user:
"기능이 구현됐어요! 확인해 보시고, 수정이 필요한 부분이 있으면 말씀해 주세요."

### Step 7: Transition
Suggest next steps:
- "/jkit-test로 추가 테스트를 작성할까요?"
- "/jkit-review로 코드 리뷰를 진행할까요?"
- "/jkit-next로 다음 기능을 확인할까요?"
