# Jkit - VibeCTO & Agent Team Project Companion (v1.1.0)

## What is Jkit?

Jkit is a **CTO-led agent team** that helps beginner developers build real projects from scratch.
Instead of learning theory first, you work **with** a team: VibeCTO leads, specialized agents handle implementation.

**Your team:**
- 🎯 **VibeCTO** (Lead) — Discovers your idea, plans architecture, orchestrates the team
- 🧪 **TDD Coach** — Writes tests first, ensures code quality through Red-Green-Refactor
- 🏗️ **Arch Mentor** — Designs Clean Architecture, verifies dependency rules
- 🎨 **Frontend Buddy** — Builds UI with Next.js, Tailwind CSS, shadcn/ui
- ☁️ **SaaS Guide** — Handles Supabase, payments, APIs, deployment

## Plugin Structure (v1.1.0)

```
jkit-project-guide/
├── commands/           # 9 slash commands (plugin root)
│   ├── jkit.md
│   ├── jkit-start.md
│   ├── jkit-plan.md
│   ├── jkit-build.md
│   ├── jkit-test.md
│   ├── jkit-review.md
│   ├── jkit-team.md
│   ├── jkit-status.md
│   └── jkit-next.md
├── agents/             # 5 specialist agents (plugin root)
│   ├── vibe-cto.md
│   ├── tdd-coach.md
│   ├── arch-mentor.md
│   ├── frontend-buddy.md
│   └── saas-guide.md
├── hooks/              # Session initialization
│   ├── hooks.json
│   └── session-start.js
├── .claude-plugin/     # Plugin metadata
│   ├── plugin.json
│   └── marketplace.json
├── CLAUDE.md           # This file
├── bkit-claude-code/   # bkit submodule (One Family integration)
└── axys/               # AXYS system
```

## Quick Reference — Slash Commands

| Command | Purpose |
|---------|---------|
| `/jkit` | Show this guide and team introduction |
| `/jkit-start` | **Start here.** VibeCTO discovers your idea through conversation |
| `/jkit-plan` | Turn your idea into an actionable project plan |
| `/jkit-build` | Start or continue building features |
| `/jkit-test` | Apply TDD workflow (Red-Green-Refactor) |
| `/jkit-review` | Code review + architecture verification |
| `/jkit-team` | Activate Agent Team mode for parallel work |
| `/jkit-status` | Check project progress |
| `/jkit-next` | Get VibeCTO's recommendation for what to do next |

## bkit One Family Integration

When bkit is installed alongside jkit, they work as "One Family":
- **jkit** provides beginner-friendly guided workflows with VibeCTO team
- **bkit** provides PDCA pipeline, gap analysis, quality tools, and advanced automation
- Both share Agent Teams infrastructure
- Use `/pdca` commands alongside `/jkit` commands for full development workflow
- Session hooks detect each other and provide integrated onboarding

## Hooks System (v1.1.0)

jkit uses Claude Code's hooks system for session initialization:
- **SessionStart hook** (`hooks/session-start.js`): Detects project state, bkit integration, and provides onboarding
- bkit's hooks handle PreToolUse, PostToolUse, Stop, and other lifecycle events
- No duplication — jkit only registers SessionStart, bkit handles the rest

## Knowledge Base — Golden Rabbit Reference Projects

All agents reference real production code from `golden-rabbit-antigravity-v1/`:

| Path | Pattern | When Referenced |
|------|---------|----------------|
| `prompts/prompts.md` | TCREI prompt writing patterns | Planning, requirement gathering |
| `4/tdd/` | TDD with Jest, useTodos.test.ts | Test writing, TDD cycles |
| `5/clean architecture/` | Clean Architecture folders, DI, dependency rules | Architecture design |
| `7/saas-landing-page/` | Landing page components (Hero, Pricing, CTA) | Marketing pages |
| `8/blog/` | Supabase Auth, Blog CRUD, RLS, migrations | Auth, basic CRUD |
| `9/chat/` | RAG pipeline, Pinecone, LangChain, realtime | AI chatbot features |
| `10/ecommerce/` | Full Clean Architecture (Entity→UseCase→Repo) | Large-scale projects |
| `11/saas/` | Subscription payments, Toss Payments, billing cron | SaaS, payments |

## Core Principles (All agents follow these)

### Clean Architecture — Dependency Rule
```
Dependencies MUST point inward only.

[Presentation] → [Application] → [Domain]
[Infrastructure] → [Application] → [Domain]

Domain depends on NOTHING.
Application depends ONLY on Domain.
Infrastructure implements Application interfaces.
Presentation calls Application use-cases.
```

Folder structure:
```
src/
├── core/
│   ├── domain/entities/       # Pure business objects (no dependencies)
│   └── application/
│       ├── use-cases/         # Business logic (depends on domain only)
│       ├── interfaces/        # Repository ports (no implementation)
│       └── dtos/              # Data transfer objects
├── infrastructure/
│   └── repositories/          # Implements interfaces (Supabase, etc.)
├── app/                       # Next.js pages, Server Actions (Composition Root)
└── components/                # UI components
```

### TDD — Red-Green-Refactor
```
1. RED:      Write a failing test FIRST
2. GREEN:    Write minimum code to pass
3. REFACTOR: Improve code quality (tests stay green)

NEVER write implementation code without a test.
```

### TCREI Prompt Pattern
When formulating requirements:
```
T - Task:         What needs to be done
C - Context:      Current state, constraints
R - Requirements: Specific implementation details
E - Examples:     Reference code or expected behavior
I - Improvements: Edge cases, error handling, optimization
```

## Agent Teams

For parallel execution, set environment variable:
```
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

Use `/jkit-team start` to activate. VibeCTO orchestrates:
- **Small projects**: VibeCTO + TDD Coach + Frontend Buddy (3 agents)
- **Large projects**: VibeCTO + all 4 specialists (5 agents)

## Tech Stack (Default)

| Layer | Technology |
|-------|-----------|
| Framework | Next.js (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS + shadcn/ui |
| Backend/DB | Supabase (Auth, DB, RLS, Storage) |
| Payments | Toss Payments |
| Deployment | Vercel |
| Testing | Vitest / Jest |
