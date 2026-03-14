---
name: jkit
description: |
  Jkit — Main Hub. Show team introduction and all available commands.
  Triggers: jkit, 도움말, help, guide, team info
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Jkit — Main Hub

Display the Jkit team and all available commands to the user.
Respond entirely in **Korean**.

## Instructions

1. Show a warm welcome message introducing Jkit:

```
🚀 Jkit에 오신 것을 환영합니다!

Jkit은 VibeCTO와 전문가 에이전트 팀이 여러분의 프로젝트를 함께 만들어가는 동반자입니다.
무엇을 만들지 모르겠어도 괜찮아요. 대화를 통해 함께 찾아볼게요.
```

2. Introduce the team:

```
👥 여러분의 팀을 소개합니다:

🎯 VibeCTO (팀 리드)    — 아이디어 발견, 기술 방향 결정, 팀 조율
🧪 TDD Coach           — 테스트 먼저 작성, 코드 품질 보장
🏗️ Arch Mentor          — 클린 아키텍처 설계 및 검증
🎨 Frontend Buddy      — UI/UX 구현, 반응형 디자인
☁️ SaaS Guide           — DB, 인증, 결제, API, 배포
```

3. Show all available slash commands:

```
📋 사용 가능한 커맨드:

/jkit-start   → 프로젝트 시작! VibeCTO와 대화하며 아이디어를 구체화합니다
/jkit-plan    → 구체화된 아이디어를 실행 가능한 계획으로 변환합니다
/jkit-build   → 기능을 실제로 구현합니다 (전문가 팀이 함께합니다)
/jkit-test    → TDD 워크플로우로 테스트를 작성하고 검증합니다
/jkit-review  → 코드 리뷰와 아키텍처 검증을 진행합니다
/jkit-team    → Agent Team 모드로 병렬 작업을 시작합니다
/jkit-status  → 현재 프로젝트 진행 상황을 확인합니다
/jkit-next    → VibeCTO가 다음에 할 작업을 추천합니다
```

4. Check if there's an existing project in the workspace:
   - If project files exist (package.json, src/, etc.), show a brief status summary
   - If no project exists, suggest starting with `/jkit-start`

5. End with an inviting question:
```
💡 처음이시라면 /jkit-start 로 시작해 보세요!
   이미 아이디어가 있다면 바로 말씀해 주세요. 함께 만들어 볼게요.
```
