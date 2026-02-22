# AXYS 기술 아키텍처

## 개요

AXYS는 **3계층 아키텍처**를 통해 플랫폼 독립적인 에이전트 정의를 다양한 AI 플랫폼에 맞는 설정 파일로 변환합니다.

```
┌─────────────────────────────────────────────────────────┐
│                    유니버설 레이어                         │
│         agents/*.md    scenarios/*.md                    │
│        (YAML frontmatter + 마크다운 본문)                  │
└───────────────────────┬─────────────────────────────────┘
                        │ install.sh 파싱
                        ▼
┌─────────────────────────────────────────────────────────┐
│                    어댑터 레이어                           │
│   adapters/claude-code/   adapters/gemini-cli/          │
│   adapters/codex-cli/                                   │
│        (변환 로직, 템플릿, 매핑 규칙)                       │
└───────────────────────┬─────────────────────────────────┘
                        │ 플랫폼별 변환
                        ▼
┌─────────────────────────────────────────────────────────┐
│                     출력 레이어                            │
│   output/claude-code/    output/gemini-cli/              │
│   output/codex-cli/                                     │
│     (.claude/agents/*.yml, GEMINI.md, AGENTS.md)        │
└─────────────────────────────────────────────────────────┘
```

## 1. 유니버설 레이어

플랫폼에 종속되지 않는 표준화된 에이전트 및 시나리오 정의 계층입니다.

### 에이전트 정의 (`agents/*.md`)

각 에이전트는 YAML frontmatter와 마크다운 본문으로 구성됩니다.

```markdown
---
id: principal
name_ko: 교장
name_en: Principal
role_category: leadership
decision_authority: final
reports_to: null
supervises: [vice-principal]
memory_scope: permanent
tools_needed: [delegate, read, analyze]
context_access: [all]
---

# 교장 (Principal)

## 핵심 역할
학교 경영의 최종 의사결정자...
```

상세 스펙은 `agents/_schema.md`를 참조하세요.

### 시나리오 정의 (`scenarios/*.md`)

각 시나리오는 YAML frontmatter와 3단계 마크다운 본문으로 구성됩니다.

```markdown
---
id: curriculum-planning
name_ko: 교육과정 편성
lead: head-academic
participants: [principal, vice-principal, head-research, subject-teacher]
phase: planning
estimated_duration: 4주
outputs: [교육과정 편성표, 시간표 초안, 교과별 운영 계획]
triggers: [신학년도 시작 2개월 전, 교육청 지침 변경]
---
```

상세 스펙은 `scenarios/_schema.md`를 참조하세요.

## 2. 어댑터 레이어

유니버설 정의를 각 플랫폼의 네이티브 설정 형식으로 변환하는 계층입니다.

### Claude Code 어댑터 (`adapters/claude-code/`)

#### 변환 규칙 테이블

| 유니버설 필드 | Claude Code 출력 |
|-------------|-----------------|
| `id` | `name: axys-{id}` |
| `decision_authority: final` | `model: opus` |
| `decision_authority: recommend` | `model: sonnet` |
| `decision_authority: execute` | `model: sonnet` |
| `decision_authority: advise` | `model: haiku` |
| `memory_scope: permanent` | `memory: project` |
| `memory_scope: session` | `memory: session` |
| `tools_needed: [delegate]` | `tools: [Task(axys-{supervised})]` |
| `tools_needed: [read, write]` | `tools: [Read, Write, Edit, Glob, Grep]` |
| `tools_needed: [search]` | `tools: [Glob, Grep, WebSearch]` |
| `tools_needed: [analyze]` | `tools: [Read, Glob, Grep]` |
| 시나리오 `id` | 커맨드명: `axys-{id}` |

#### 출력 구조

```
output/claude-code/
├── .claude/
│   └── agents/
│       ├── axys-principal.yml
│       ├── axys-vice-principal.yml
│       ├── axys-head-academic.yml
│       └── ...
└── CLAUDE.md   # 슬래시 커맨드 정의 추가
```

### Gemini CLI 어댑터 (`adapters/gemini-cli/`)

유니버설 에이전트와 시나리오를 `GEMINI.md` 파일의 지시문으로 변환합니다.

#### 출력 구조

```
output/gemini-cli/
└── GEMINI.md   # 에이전트 역할 및 시나리오 지시문
```

### Codex CLI 어댑터 (`adapters/codex-cli/`)

유니버설 정의를 `AGENTS.md` 형식으로 변환합니다.

#### 출력 구조

```
output/codex-cli/
└── AGENTS.md   # 에이전트 정의 및 시나리오 워크플로우
```

## 3. 출력 레이어

어댑터가 생성한 최종 설정 파일이 저장되는 계층입니다. `output/` 디렉토리는 `.gitignore`에 포함되어 버전 관리 대상이 아닙니다.

## install.sh 실행 흐름

```
사용자 실행
    │
    ▼
./install.sh --school "한빛초등학교" --platform claude-code
    │
    ├─ 1. 인자 파싱
    │     --school → SCHOOL_NAME="한빛초등학교"
    │     --platform → TARGET_PLATFORM="claude-code"
    │
    ├─ 2. 유니버설 파일 로드
    │     agents/*.md 읽기 → YAML frontmatter 파싱
    │     scenarios/*.md 읽기 → YAML frontmatter 파싱
    │
    ├─ 3. {{SCHOOL_NAME}} 치환
    │     모든 파일의 {{SCHOOL_NAME}} → "한빛초등학교" 치환
    │
    ├─ 4. 어댑터 실행
    │     adapters/{TARGET_PLATFORM}/ 의 변환 로직 실행
    │     유니버설 필드 → 플랫폼 네이티브 필드 매핑
    │
    ├─ 5. 출력 파일 생성
    │     output/{TARGET_PLATFORM}/ 에 설정 파일 생성
    │
    └─ 6. 완료 보고
          생성된 파일 목록 출력
          사용 안내 메시지
```

## {{SCHOOL_NAME}} 치환 메커니즘

모든 유니버설 에이전트와 시나리오 파일에는 `{{SCHOOL_NAME}}` 플레이스홀더가 포함되어 있습니다.

### 치환 시점

`install.sh` 실행 시 `--school` 옵션으로 전달된 값이 모든 파일에서 일괄 치환됩니다.

### 치환 대상

- 에이전트 파일의 `## {{SCHOOL_NAME}} 맞춤 행동 원칙` 섹션
- 시나리오 파일의 학교명 참조 부분
- 출력 설정 파일의 시스템 프롬프트 내 학교명

### 치환 방식

```bash
# install.sh 내부 로직 (의사 코드)
SCHOOL_NAME="$1"

for file in agents/*.md scenarios/*.md; do
    sed "s/{{SCHOOL_NAME}}/${SCHOOL_NAME}/g" "$file" > "tmp_${file}"
done
```

### 예시

| 치환 전 | 치환 후 (--school "한빛초등학교") |
|--------|-------------------------------|
| `## {{SCHOOL_NAME}} 맞춤 행동 원칙` | `## 한빛초등학교 맞춤 행동 원칙` |
| `{{SCHOOL_NAME}}의 교육 비전에 따라` | `한빛초등학교의 교육 비전에 따라` |

## 확장 가이드

### 새로운 플랫폼 어댑터 추가

1. `adapters/{new-platform}/` 디렉토리 생성
2. 변환 스크립트 작성 (유니버설 → 플랫폼 네이티브)
3. `install.sh`에 새 플랫폼 옵션 등록
4. `output/{new-platform}/` 출력 경로 설정

### 유니버설 필드 확장

`agents/_schema.md` 또는 `scenarios/_schema.md`를 수정하여 새로운 필드를 추가한 뒤, 각 어댑터의 변환 규칙에 해당 필드의 매핑 로직을 추가합니다.
