# Jkit - VibeCTO와 에이전트 팀이 함께하는 프로젝트 동반자
## 문제 정의
초보 개발자는 **무엇을 만들지부터 막막하다**. 기술 선택, 아키텍처, 테스트, 배포까지 혼자 결정하기 어렵다. Jkit은 전문 CTO가 이끄는 에이전트 팀이 사용자와 대화하며 아이디어 발견부터 프로젝트 완성까지 함께 작업하는 시스템이다.
## 핵심 철학
**"학습 커리큘럼이 아니라, 프로젝트를 함께 만드는 팀"**
* VibeCTO가 대화를 통해 사용자의 아이디어를 구체화
* 프로젝트 방향에 따라 필요한 전문가(에이전트)를 투입
* golden-rabbit 리포의 실전 코드를 패턴/레퍼런스로 활용
* 사용자가 이해할 수 있도록 매 결정마다 "왜"를 설명
## 참조 소스 (Knowledge Base)
* **Golden-Rabbit** (`golden-rabbit-antigravity-v1/`): 실전 패턴 레퍼런스
    * `prompts/prompts.md`: TCREI 프롬프트 작성 패턴
    * `4/tdd/`: TDD Red-Green-Refactor 패턴, jest 설정, useTodos.test.ts
    * `5/clean architecture/`: Clean Architecture 폴더 구조, 의존성 규칙, DI 패턴
    * `7/saas-landing-page/`: SaaS 랜딩 페이지 컴포넌트 패턴
    * `8/blog/`: Supabase Auth + 블로그 CRUD 패턴
    * `9/chat/`: RAG + Pinecone + 실시간 채팅 패턴
    * `10/ecommerce/`: Clean Architecture 기반 대규모 프로젝트 (Entity, UseCase, Repository 전체 구현)
    * `11/saas/`: 구독 결제 SaaS 전체 구현 (Toss Payments, 정기결제, 도메인 엔티티, UseCase 테스트)
* **Bkit** (`bkit-claude-code/`): 에이전트/커맨드 구조 패턴 참조
## 디렉토리 구조 (v1.1.0 — bkit 호환 플러그인 구조)
```
AntigravityDevProjectGuide/
├── CLAUDE.md                          # 프로젝트 컨텍스트 + Jkit 팀 소개
├── commands/                          # 슬래시 커맨드 (플러그인 루트)
│   ├── jkit.md                        # /jkit - 메인 진입점 (사용법 + 팀 소개)
│   ├── jkit-start.md                  # /jkit-start - 프로젝트 시작 대화
│   ├── jkit-plan.md                   # /jkit-plan - 프로젝트 계획 수립
│   ├── jkit-build.md                  # /jkit-build - 구현 시작/계속
│   ├── jkit-test.md                   # /jkit-test - TDD 워크플로우 적용
│   ├── jkit-review.md                 # /jkit-review - 코드 리뷰 + 아키텍처 검증
│   ├── jkit-team.md                   # /jkit-team - Agent Team 모드
│   ├── jkit-status.md                 # /jkit-status - 프로젝트 현황
│   └── jkit-next.md                   # /jkit-next - 다음 할 일 제안
├── agents/                            # 전문 에이전트 팀 (플러그인 루트)
│   ├── vibe-cto.md                    # VibeCTO (리드, opus)
│   ├── tdd-coach.md                   # TDD 코치 (sonnet)
│   ├── arch-mentor.md                 # 아키텍처 멘토 (sonnet)
│   ├── frontend-buddy.md              # 프론트엔드 버디 (sonnet)
│   └── saas-guide.md                  # SaaS/백엔드 가이드 (sonnet)
├── hooks/                             # 세션 초기화 훅
│   ├── hooks.json                     # 훅 설정 (SessionStart only)
│   └── session-start.js               # 세션 시작 스크립트 (bkit 연동 포함)
├── .claude-plugin/                    # 플러그인 메타데이터
│   ├── plugin.json                    # 플러그인 정보 (v1.1.0)
│   └── marketplace.json               # 마켓플레이스 정보 (v1.1.0)
├── golden-rabbit-antigravity-v1/      # Knowledge Base
├── bkit-claude-code/                  # bkit submodule (One Family 통합)
└── axys/                              # AXYS 시스템
```

> **v1.1.0 변경사항**: `.claude/commands/` → `commands/`, `.claude/agents/` → `agents/`로 플러그인 루트에 배치.
> 각 command에 YAML frontmatter(`user-invocable: true`, `allowed-tools`) 추가.
> hooks/ 디렉토리 신설하여 세션 초기화 및 bkit "One Family" 연동 구현.
## 슬래시 커맨드 상세 설계
### /jkit (메인 진입점)
사용자가 `/jkit`을 입력하면 Jkit 팀을 소개하고 사용 가능한 모든 커맨드를 안내한다.
* VibeCTO와 4명의 전문가 팀 소개
* 커맨드별 역할과 언제 사용하는지 안내
* 현재 프로젝트 상태가 있으면 요약 표시
* "무엇을 만들고 싶으세요?"로 대화 시작 유도
### /jkit-start {{project_description}} (프로젝트 시작 대화)
**가장 핵심적인 커맨드.** VibeCTO가 사용자와 대화하며 프로젝트를 구체화한다.
* 사용자의 아이디어가 모호하면 AskUserQuestion으로 구체화 질문
    * "어떤 문제를 해결하고 싶으세요?"
    * "주요 사용자는 누구인가요?"
    * "꼭 있어야 하는 핵심 기능 3가지는?"
* golden-rabbit의 유사 프로젝트를 레퍼런스로 제시
    * 블로그 류 → 8/blog 패턴 참조
    * 쇼핑몰/대시보드 → 10/ecommerce 패턴 참조
    * SaaS/구독 서비스 → 11/saas 패턴 참조
    * AI 챗봇/RAG → 9/chat 패턴 참조
* 대화 결과를 바탕으로 기술 스택 추천 및 프로젝트 구조 제안
* AskUserQuestion으로 최종 확인 후 /jkit-plan으로 연결
### /jkit-plan {{feature}} (프로젝트 계획 수립)
VibeCTO가 구체화된 아이디어를 실행 가능한 계획으로 변환한다.
* TCREI 프롬프트 패턴으로 요구사항 정리 (golden-rabbit/prompts 참조)
* Clean Architecture 기반 폴더 구조 설계 (golden-rabbit/5, 10, 11 참조)
* 기능별 구현 순서 결정 (의존성 고려)
* 각 기능의 테스트 전략 수립 (TDD 적용 범위 결정)
* AskUserQuestion으로 계획 확인: "이 순서로 진행할까요?"
### /jkit-build {{feature}} (구현 시작/계속)
실제 코드 작성을 시작한다. VibeCTO가 필요한 전문가를 투입한다.
* 구현할 기능에 따라 적절한 에이전트 위임
    * UI/페이지 → frontend-buddy
    * 비즈니스 로직/아키텍처 → arch-mentor
    * 테스트 코드 → tdd-coach
    * DB/API/결제 → saas-guide
* golden-rabbit의 해당 패턴 코드를 레퍼런스로 제공
* 구현 중 초보자가 이해 못 하는 부분은 AskUserQuestion으로 확인
* 단계별 완료 후 자동으로 /jkit-test 제안
### /jkit-test {{scope}} (TDD 워크플로우)
tdd-coach가 주도하여 테스트를 작성하고 검증한다.
* Red-Green-Refactor 사이클 적용
    * Phase 1 (Red): 실패하는 테스트 먼저 작성
    * Phase 2 (Green): 테스트 통과하는 최소 코드
    * Phase 3 (Refactor): 코드 품질 개선
* golden-rabbit의 테스트 패턴 참조
    * UseCase 단위 테스트: 11/saas/src/core/application/use-cases/
    * Repository 통합 테스트: 10/ecommerce/src/infrastructure/repositories/
    * 도메인 엔티티 테스트: 10/ecommerce/src/core/domain/entities/
* 테스트 실행 후 결과 설명, 실패 시 원인과 해결 방법 안내
### /jkit-review (코드 리뷰 + 아키텍처 검증)
arch-mentor가 주도하여 코드 품질을 점검한다.
* Clean Architecture 의존성 규칙 위반 검사
    * Domain → 외부 의존성 없는지
    * Application → Domain만 참조하는지
    * Infrastructure → 인터페이스 구현하는지
* SOLID 원칙 준수 여부
* 코드 중복, 네이밍, 구조 개선 제안
* AskUserQuestion으로 개선 사항 설명 및 동의 확인
### /jkit-team [start|status|cleanup] (Agent Team 모드)
Agent Teams를 활용한 병렬 작업 모드.
* start: VibeCTO가 프로젝트 상황에 맞는 팀 구성
    * 소규모: VibeCTO + tdd-coach + frontend-buddy (3명)
    * 대규모: VibeCTO + 전체 4명 (5명)
* status: 각 에이전트의 현재 작업 상태 표시
* cleanup: 팀 세션 종료
### /jkit-status (프로젝트 현황)
* 프로젝트 개요 (무엇을 만들고 있는지)
* 완료된 기능 / 진행 중 기능 / 남은 기능
* 테스트 커버리지 현황
* 아키텍처 준수 현황
### /jkit-next (다음 할 일 제안)
VibeCTO가 현재 프로젝트 상태를 분석하고 다음 작업을 제안한다.
* 코드베이스 분석 → 미완성 부분 탐지
* 우선순위 기반 다음 작업 제안
* AskUserQuestion으로 확인: "다음에 이것을 작업할까요?"
## 에이전트 상세 설계
### vibe-cto.md (VibeCTO - 리드)
* **model**: opus
* **역할**: 프로젝트 전체 오케스트레이션. 사용자와 대화하여 아이디어를 구체화하고, 기술 방향을 결정하고, 적절한 팀원에게 작업을 위임한다.
* **핵심 행동 원칙**:
    * 항상 AskUserQuestion으로 사용자의 의도를 먼저 파악
    * 매 결정마다 "왜 이렇게 하는지" 초보자 눈높이로 설명
    * golden-rabbit의 유사 프로젝트를 레퍼런스로 제시
    * 복잡한 작업은 팀원에게 위임하되 결과를 사용자에게 설명
* **tools**: Task(tdd-coach), Task(arch-mentor), Task(frontend-buddy), Task(saas-guide), Read, Write, Edit, Bash, Glob, Grep, TodoWrite, WebSearch, AskUserQuestion
* **Knowledge Base 활용**: 프로젝트 유형에 따라 golden-rabbit의 적절한 프로젝트를 매칭
### tdd-coach.md (TDD 코치)
* **model**: sonnet
* **역할**: 테스트 작성과 TDD 사이클 진행. 코드를 작성하기 전에 반드시 테스트를 먼저 작성하도록 유도한다.
* **Knowledge Base 활용**:
    * golden-rabbit/4/tdd: TDD 기본 패턴 (jest, useTodos.test.ts)
    * golden-rabbit/11/saas: UseCase 단위 테스트 (.spec.ts 파일들)
    * golden-rabbit/10/ecommerce: Repository 통합 테스트, Entity 테스트
* **핵심 원칙**: "테스트 없는 코드는 작성하지 않는다"
### arch-mentor.md (아키텍처 멘토)
* **model**: sonnet
* **역할**: Clean Architecture 원칙에 따라 코드 구조를 설계하고 검증한다.
* **Knowledge Base 활용**:
    * golden-rabbit/5/clean architecture: 기본 폴더 구조, 의존성 규칙
    * golden-rabbit/10/ecommerce: 대규모 프로젝트의 core/application/interfaces, use-cases, entities
    * golden-rabbit/11/saas: SaaS 프로젝트의 DI 패턴, Composition Root (actions.ts)
* **핵심 원칙**: "의존성은 안쪽으로만. Domain은 아무것도 의존하지 않는다."
### frontend-buddy.md (프론트엔드 버디)
* **model**: sonnet
* **역할**: UI 구현, 컴포넌트 설계, 페이지 라우팅, 반응형 디자인 가이드
* **Knowledge Base 활용**:
    * golden-rabbit/7/saas-landing-page: 랜딩 페이지 컴포넌트 (Hero, Features, Pricing, CTA)
    * golden-rabbit/8/blog: 인증 UI, 게시물 카드, 네비게이션
    * golden-rabbit/11/saas: SaaS 대시보드, 결제 위젯, 사이드바
    * golden-rabbit/10/ecommerce: 관리자 대시보드, 데이터 테이블, 차트
* **기술 스택**: Next.js App Router, Tailwind CSS, shadcn/ui, lucide-react
### saas-guide.md (SaaS/백엔드 가이드)
* **model**: sonnet
* **역할**: 백엔드 연동, DB 설계, API 구현, 인증, 결제 시스템, 배포
* **Knowledge Base 활용**:
    * golden-rabbit/8/blog: Supabase 기본 설정, Auth, RLS, 마이그레이션
    * golden-rabbit/9/chat: RAG 파이프라인, Pinecone 벡터 DB, LangChain
    * golden-rabbit/10/ecommerce: Supabase Repository 구현 패턴, seed 데이터
    * golden-rabbit/11/saas: Toss Payments 연동, 구독 결제, 정기결제 cron, 도메인 엔티티 (Subscription, Payment)
* **기술 스택**: Supabase (Auth, DB, RLS, Storage), Toss Payments, Vercel 배포
## CLAUDE.md 설계
* Jkit 소개: VibeCTO + 에이전트 팀이 프로젝트를 함께 만드는 동반자
* 슬래시 커맨드 퀵 레퍼런스
* Knowledge Base 경로 맵 (golden-rabbit 프로젝트별 용도)
* Clean Architecture 의존성 규칙 (모든 에이전트가 따르는 원칙)
* TDD Red-Green-Refactor 원칙
* Agent Teams 사용법
## 구현 순서 (v1.1.0 업데이트)
1. CLAUDE.md 생성 (v1.1.0 플러그인 구조 반영)
2. commands/ 디렉토리에 9개 커맨드 생성 (YAML frontmatter 포함)
3. agents/ 디렉토리에 5개 에이전트 생성 (기존 frontmatter 유지)
4. hooks/ 디렉토리 생성 (hooks.json + session-start.js)
5. .claude-plugin/ 메타데이터 업데이트 (v1.1.0)
6. bkit session-start.js에 jkit 감지 로직 추가 (One Family)
7. 동작 검증

> ~~v1.0.0에서는 `.claude/` 하위에 배치했으나, Claude Code 플러그인 시스템이 플러그인 루트의 `commands/`, `agents/`를 스캔하기 때문에 마켓플레이스 설치 후 slash commands가 보이지 않는 문제가 있었음. v1.1.0에서 bkit과 동일한 구조로 전환하여 해결.~~
