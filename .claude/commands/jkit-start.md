# Jkit Start — Project Discovery

**Agent**: Use the `vibe-cto` agent for this command.
**Language**: Respond in **Korean** for all user-facing messages.

## Purpose

This is the **most important command** in Jkit.
The user may have no idea what to build, or may have a vague concept.
VibeCTO discovers and shapes the project idea through conversation.

## Input

The user may provide: `$ARGUMENTS`
- If provided, use it as the starting point for the conversation
- If empty, start with open-ended discovery questions

## Conversation Flow

### Phase 1: Idea Discovery
If the user's idea is unclear, ask step-by-step (use AskUserQuestion):

1. "어떤 문제를 해결하고 싶으세요? 또는 어떤 것에 관심이 있으세요?"
2. "주요 사용자는 누구인가요? (본인? 특정 그룹? 모든 사람?)"
3. "꼭 있어야 하는 핵심 기능 3가지는 뭘까요?"

Do NOT ask all questions at once. One question at a time, building on the previous answer.

### Phase 2: Reference Matching
Based on the user's answers, read and reference the matching golden-rabbit project:

| User's Idea | Reference Project | Path |
|-------------|-------------------|------|
| Blog, content platform | Blog | `golden-rabbit-antigravity-v1/8/blog/` |
| Shopping, admin dashboard | E-commerce | `golden-rabbit-antigravity-v1/10/ecommerce/` |
| SaaS, subscription service | CloudNote SaaS | `golden-rabbit-antigravity-v1/11/saas/` |
| AI chatbot, Q&A, search | RAG Chat | `golden-rabbit-antigravity-v1/9/chat/` |
| Landing/marketing page | SaaS Landing | `golden-rabbit-antigravity-v1/7/saas-landing-page/` |

**Actually READ** the reference project's key files (README, package.json, main page)
and explain to the user: "우리가 만들려는 것과 비슷한 레퍼런스 프로젝트가 있어요. 이걸 참고해서 진행할게요."

### Phase 3: Tech Stack & Architecture
Based on the project type, recommend:
- Tech stack (default: Next.js + TypeScript + Tailwind + Supabase)
- Architecture pattern (Clean Architecture — read from `golden-rabbit-antigravity-v1/5/clean architecture/rules/architecture.md`)
- Key features to implement first

Explain WHY each choice is made, in beginner-friendly terms.

### Phase 4: Confirmation
Use AskUserQuestion to confirm:
"이렇게 진행할까요? 수정하고 싶은 부분이 있으면 말씀해 주세요."

### Phase 5: Transition
After confirmation:
1. Summarize the project definition
2. Suggest: "이제 `/jkit-plan`을 실행해서 구체적인 계획을 세울게요!"
