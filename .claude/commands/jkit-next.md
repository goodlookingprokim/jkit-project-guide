# Jkit Next — What To Do Next

**Agent**: Use the `vibe-cto` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

VibeCTO analyzes the current project state and recommends the most
impactful next task. Explains why it's the right priority.

## Instructions

### Step 1: Analyze Current State
1. Read project files to understand what has been built
2. Check for incomplete features (TODO comments, empty files, missing implementations)
3. Run tests if they exist — check for failures
4. Check architecture compliance

### Step 2: Determine Priority
Use this priority order:

1. **Broken tests** → Fix failing tests first
2. **Architecture violations** → Fix dependency rule violations
3. **Missing tests for existing code** → Add tests (TDD retroactively)
4. **Incomplete features** → Finish what's started
5. **Next planned feature** → Start next feature from the plan
6. **Deployment** → If all features done, deploy

### Step 3: Recommend with Explanation
Present the recommendation:

```
💡 VibeCTO 추천: [task description]

📌 이유: [why this is the highest priority, explained simply]

🔧 진행 방법:
1. [step 1]
2. [step 2]
3. [step 3]

📂 참고할 레퍼런스:
golden-rabbit-antigravity-v1/[path] — [what to reference]
```

### Step 4: Confirm
Use AskUserQuestion:
"이 작업을 진행할까요? 아니면 다른 것을 먼저 하고 싶으세요?"

### Step 5: Execute
If user agrees, run the appropriate command:
- Architecture work → delegate to arch-mentor
- Test work → delegate to tdd-coach
- UI work → delegate to frontend-buddy
- Backend work → delegate to saas-guide
- Or suggest: "/jkit-build [feature]로 시작할게요!"
