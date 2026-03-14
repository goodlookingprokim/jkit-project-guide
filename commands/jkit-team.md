---
name: jkit-team
description: |
  Jkit Team — Agent Team Mode. Activate parallel work with specialist agents.
  Triggers: team, 팀, parallel, agent team, 병렬 작업, coordinate
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

# Jkit Team — Agent Team Mode

**Agent**: Use the `vibe-cto` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

Activate Agent Teams for parallel work on the project.
VibeCTO orchestrates multiple specialist agents working simultaneously.

## Input

`$ARGUMENTS` — Action: `start`, `status`, or `cleanup`.
Default: `start` if empty.

## Actions

### start — Activate Team Mode

1. Check if Agent Teams is available (environment variable `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
2. If not available, explain how to enable it
3. Analyze current project to determine team size:

**Small project** (few features, early stage):
```
👥 소규모 팀 구성 (3명):
🎯 VibeCTO      — 전체 조율, 아키텍처 결정
🧪 TDD Coach    — 테스트 작성
🎨 Frontend Buddy — UI 구현
```

**Large project** (many features, complex):
```
👥 대규모 팀 구성 (5명):
🎯 VibeCTO       — 전체 조율, 아키텍처 결정
🧪 TDD Coach     — 테스트 작성
🏗️ Arch Mentor    — 아키텍처 설계/검증
🎨 Frontend Buddy — UI 구현
☁️ SaaS Guide     — 백엔드/DB/결제
```

4. Ask user to confirm: "이 팀 구성으로 진행할까요?"
5. Start distributing tasks to teammates

### status — Show Team Status

Display current state of each agent:
```
📊 팀 현황:
🎯 VibeCTO       — 전체 조율 중
🧪 TDD Coach     — [기능명] 테스트 작성 중
🎨 Frontend Buddy — [페이지명] UI 구현 중
🏗️ Arch Mentor    — 대기 중
☁️ SaaS Guide     — [기능명] API 구현 중
```

### cleanup — End Team Session

1. Stop all active teammate tasks
2. Summarize what each agent accomplished
3. Return to single-session mode
4. Display: "팀 세션이 종료되었습니다. 단일 세션 모드로 돌아갑니다."
