---
name: jkit-status
description: |
  Jkit Status — Project Progress. Show comprehensive project state overview.
  Triggers: status, progress, 현황, 진행 상황, project state
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
---

# Jkit Status — Project Progress

**Agent**: Use the `vibe-cto` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

Show a comprehensive overview of the current project state.
Analyze the codebase and present progress in a beginner-friendly format.

## Instructions

### Step 1: Project Detection
Check the workspace for project indicators:
- `package.json` — Project exists
- `src/` directory — Source code exists
- `src/core/domain/` — Clean Architecture applied
- `supabase/` — Database configured
- Test files (`*.test.ts`, `*.spec.ts`) — Tests exist

### Step 2: Display Status

If NO project exists:
```
📊 프로젝트 현황

아직 프로젝트가 시작되지 않았어요!
/jkit-start 로 새 프로젝트를 시작해 보세요.
```

If project EXISTS, analyze and display:
```
📊 프로젝트 현황
────────────────────────────

📁 프로젝트: [name from package.json]
🏗️ 아키텍처: Clean Architecture [적용됨/미적용]

📋 기능 현황:
  ✅ 완료: [list completed features based on code analysis]
  🔄 진행 중: [list in-progress features]
  ⏳ 미구현: [list planned but unimplemented features]

🧪 테스트:
  - 테스트 파일: N개
  - [run tests if possible and show pass/fail count]

🗄️ 데이터베이스:
  - 마이그레이션: N개
  - RLS 정책: [설정됨/미설정]

💡 추천: [next action based on current state]
```

### Step 3: Suggest Next Action
Based on analysis, suggest the most appropriate next command:
- No architecture → "/jkit-plan으로 구조를 설계해 볼까요?"
- Missing tests → "/jkit-test로 테스트를 작성해 볼까요?"
- Architecture violations → "/jkit-review로 코드를 점검해 볼까요?"
- Ready for next feature → "/jkit-next로 다음 할 일을 확인해 볼까요?"
