# Jkit - CTO-Led Agent Team Project Guide

Jkit은 **CTO 주도 에이전트 팀**과 함께 실제 프로젝트를 처음부터 만드는 Claude Code 프로젝트 가이드입니다.
이론을 먼저 배우는 대신, 팀과 함께 일하며 배웁니다.

## Your Team

| Agent | Role |
|-------|------|
| **VibeCTO** (Lead) | 아이디어 발굴, 아키텍처 설계, 팀 조율 |
| **TDD Coach** | 테스트 우선 작성, Red-Green-Refactor |
| **Arch Mentor** | Clean Architecture 설계, 의존성 규칙 검증 |
| **Frontend Buddy** | Next.js + Tailwind CSS + shadcn/ui UI 구현 |
| **SaaS Guide** | Supabase, 결제, API, 배포 |

## Installation

```bash
git clone --recursive https://github.com/goodlookingprokim/jkit-project-guide.git
cd jkit-project-guide
```

> `--recursive` 플래그는 bkit-claude-code submodule을 함께 받기 위해 필요합니다.

## Usage

Claude Code에서 프로젝트 디렉토리를 열고 슬래시 커맨드를 사용합니다:

```
/jkit-start   # VibeCTO와 아이디어 발견 대화 시작
/jkit-plan    # 아이디어를 실행 가능한 프로젝트 계획으로 전환
/jkit-build   # 기능 구현 시작 또는 계속
/jkit-test    # TDD 워크플로우 (Red-Green-Refactor)
/jkit-review  # 코드 리뷰 + 아키텍처 검증
/jkit-team    # Agent Team 모드 활성화 (병렬 작업)
/jkit-status  # 프로젝트 진행 상황 확인
/jkit-next    # VibeCTO의 다음 작업 추천
/jkit         # 메인 허브 (가이드 표시)
```

## Tech Stack (Default)

| Layer | Technology |
|-------|-----------|
| Framework | Next.js (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS + shadcn/ui |
| Backend/DB | Supabase |
| Testing | Vitest / Jest |
| Deployment | Vercel |

## Core Principles

### Clean Architecture
의존성은 반드시 안쪽으로만 향합니다: Presentation → Application → Domain

### TDD (Red-Green-Refactor)
1. RED: 실패하는 테스트를 먼저 작성
2. GREEN: 테스트를 통과하는 최소한의 코드 작성
3. REFACTOR: 테스트를 유지하며 코드 품질 개선

## Agent Teams

병렬 실행을 위해 Agent Teams 기능을 활용합니다:

```bash
# 환경 변수 설정
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

`/jkit-team start`로 활성화하면 VibeCTO가 팀을 조율합니다.

## Credits

- **[Bkit](https://github.com/popup-studio-ai/bkit-claude-code)** - AI-Native 개발 프레임워크 (submodule로 포함)
- **"안티그래비티 완벽 가이드"** (코드팩토리 최지호 저, 골든래빗) - Clean Architecture, TDD 참조 패턴 (코드 미포함, 도서 참조)
- **Claude Code Agent Teams** - Anthropic의 멀티 에이전트 기능 활용

## License

This project is for educational purposes. See individual components for their respective licenses.
