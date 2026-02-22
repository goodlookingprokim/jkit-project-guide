# AXYS 자교 적용 가이드

> 우리 학교에 맞게 AXYS를 커스터마이징하는 방법

## 학교명 설정 방법

### install.sh로 설정 (권장)

가장 간단한 방법입니다. 설치 스크립트 실행 시 `--school` 옵션으로 학교명을 지정하면 모든 파일에서 `{{SCHOOL_NAME}}`이 자동으로 치환됩니다.

```bash
./install.sh --school "서울디지털초등학교" --platform claude-code
```

### 수동으로 변경

이미 생성된 파일에서 학교명을 변경하려면 텍스트 편집기의 찾기/바꾸기 기능을 사용합니다.

- 찾기: `테스트학교` (또는 현재 학교명)
- 바꾸기: `서울디지털초등학교` (새 학교명)

---

## 에이전트 커스터마이징

### 기존 에이전트 수정 방법

`agents/` 폴더의 각 `.md` 파일을 편집하여 에이전트의 역할을 수정할 수 있습니다.

**예시: 교무부장의 역할에 방과후학교 관리 추가**

`agents/academic-head.md` 파일을 열고:

1. `## 핵심 역할` 섹션에 내용을 추가합니다:
```markdown
## 핵심 역할
교육과정 편성과 운영의 실무 책임자로서 학교 교육 활동의 중심축을 담당한다.
...
방과후학교 프로그램의 기획과 운영을 총괄하며, 강사 섭외와 프로그램 편성을 관리한다.
```

2. `## 의사결정 범위` 섹션에 항목을 추가합니다:
```markdown
- 방과후학교 프로그램 편성 및 강사 관리
```

3. 수정 후 `install.sh`를 다시 실행하면 변경 사항이 반영됩니다.

### 새 에이전트 추가 방법

학교에 특수한 역할이 필요한 경우 새 에이전트를 추가할 수 있습니다.

1. `agents/` 폴더에 새 파일을 생성합니다 (파일명은 영문 소문자와 하이픈만 사용):

```bash
# 예: 정보부장 에이전트 추가
touch agents/info-head.md
```

2. `agents/_schema.md`의 형식에 따라 내용을 작성합니다:

```markdown
---
id: info-head
name_ko: 정보부장
name_en: Information Technology Head
role_category: management
decision_authority: recommend
reports_to: vice-principal
supervises: []
memory_scope: permanent
tools_needed: [read, write, search, analyze]
context_access: [digital-transition]
---

# 정보부장 (Information Technology Head)

## 핵심 역할
학교 정보화 교육과 디지털 인프라 관리의 실무 책임자이다.
정보 교육과정을 기획하고 학교 네트워크와 기기를 관리하며,
교원의 에듀테크 역량 개발을 지원한다.

## 의사결정 범위
- 학교 정보화 기기 도입 및 교체 계획 수립
- 학교 네트워크 및 보안 정책 관리
- 정보 교육 프로그램 기획
- 소프트웨어 및 라이선스 관리

## 협업 패턴
- 행정실장과 정보화 예산 및 기기 구매를 협의한다
- 교과교사에게 에듀테크 활용 방법을 안내한다
- 연구부장과 디지털 전환 프로젝트를 공동으로 추진한다
- 교감에게 학교 정보화 현황을 보고한다

## {{SCHOOL_NAME}} 맞춤 행동 원칙
- 학교의 디지털 인프라 현황과 교원의 디지털 역량 수준을 반영한다
- 학교급별 정보 교육 목표와 방법의 차이를 고려한다
```

3. 새 에이전트를 관련 시나리오의 `participants`에 추가합니다.

4. `install.sh`를 다시 실행합니다.

### 에이전트 역할 조정 (소규모 학교)

소규모 학교에서는 한 명의 교사가 여러 역할을 겸하는 경우가 많습니다. 이 경우 에이전트를 통합할 수 있습니다.

**방법 1: 기존 에이전트의 역할 확장**

예를 들어, 교무부장이 연구부장 역할도 겸하는 경우:

```markdown
---
id: academic-head
name_ko: 교무연구부장
name_en: Academic & Research Head
role_category: management
decision_authority: recommend
reports_to: vice-principal
supervises: [homeroom-teacher, subject-teacher]
memory_scope: permanent
tools_needed: [read, write, search, analyze]
context_access: [curriculum-planning, evaluation, semester-transition, teacher-development, innovation-project, digital-transition]
---

# 교무연구부장 (Academic & Research Head)

## 핵심 역할
교육과정 편성과 운영, 교원 연수 기획과 혁신 프로젝트를 통합적으로 관리한다.
...
```

**방법 2: 불필요한 에이전트 파일 삭제**

사용하지 않는 에이전트의 `.md` 파일을 삭제하면 변환 시 해당 에이전트가 생성되지 않습니다. 단, 다른 에이전트의 `reports_to`나 `supervises`에서 해당 에이전트를 참조하고 있다면 함께 수정해야 합니다.

---

## 시나리오 커스터마이징

### 기존 시나리오 수정

`scenarios/` 폴더의 각 `.md` 파일을 편집하여 시나리오의 절차를 수정할 수 있습니다.

**예시: 교육과정 편성 시나리오에 학부모 의견 수렴 단계 추가**

`scenarios/curriculum-planning.md` 파일의 Phase 2에 학부모 의견 수렴 절차를 추가합니다:

```markdown
## Phase 2: 역할별 작업

### 담임교사(homeroom-teacher)의 역할 (추가)
- 학부모 대상 교육과정 의견 조사를 실시한다
- 학부모의 요구와 기대를 취합하여 교무부장에게 전달한다
- **산출물**: 학부모 의견 조사 결과 보고서
```

### 새 시나리오 추가

학교 고유의 업무 시나리오를 추가할 수 있습니다.

1. `scenarios/` 폴더에 새 파일을 생성합니다:

```bash
touch scenarios/after-school-program.md
```

2. `scenarios/_schema.md`의 형식에 따라 작성합니다:

```markdown
---
id: after-school-program
name_ko: 방과후학교 운영
lead: academic-head
participants: [vice-principal, homeroom-teacher, admin-head]
phase: execution
estimated_duration: 4-weeks
outputs: [방과후학교 운영 계획서, 강좌 편성표, 강사 계약서]
triggers: [학기 시작 전, 방과후학교 운영 개선 필요 시]
---

# 방과후학교 운영 시나리오

## Purpose
{{SCHOOL_NAME}}의 방과후학교 프로그램을 기획하고 운영하는 업무이다.
...

## Phase 1: 킥오프
...

## Phase 2: 역할별 작업
...

## Phase 3: 통합 검증
...
```

3. `install.sh`를 다시 실행하면 새 시나리오가 커맨드로 등록됩니다.

---

## 학교 특성별 권장 설정

### 소규모 학교 (6학급 이하)

교직원이 적어 한 사람이 여러 업무를 겸하는 경우가 많습니다.

**권장 에이전트 구성 (5~6명):**

| 에이전트 | 통합 역할 |
|---------|----------|
| 교장 | 그대로 유지 |
| 교감 | 교감 + 학년부장 역할 통합 |
| 교무연구부장 | 교무부장 + 연구부장 역할 통합 |
| 담임교사 | 그대로 유지 |
| 행정실장 | 행정실장 + 안전 담당 통합 |
| 상담교사 | 필요 시 유지 (배치교가 아닌 경우 삭제) |

**적용 방법:**

1. `agents/research-head.md` 삭제
2. `agents/grade-head.md` 삭제
3. `agents/academic-head.md`의 역할에 연구부장 업무 추가
4. `agents/vice-principal.md`의 역할에 학년 관리 업무 추가
5. 각 시나리오의 `lead`와 `participants`를 수정

**권장 시나리오 (핵심 업무만):**
- curriculum-planning (교육과정 편성)
- budget-planning (예산 편성)
- semester-transition (학기 전환)
- emergency-response (위기 대응)

### 중규모 학교 (7~24학급)

기본 설정을 그대로 사용하기에 가장 적합한 규모입니다.

**권장 에이전트 구성: 기본 10명 그대로 사용**

**추가 고려 사항:**
- 학년부장이 여러 명인 경우 `grade-head`를 학년별로 복제할 수 있습니다
  - 예: `grade-head-lower` (저학년부장), `grade-head-upper` (고학년부장)
- 교과교사가 교과별로 구분되어야 하는 경우 교과별 에이전트를 추가할 수 있습니다

**권장 시나리오: 13개 전체 사용**

### 대규모 학교 (25학급 이상)

조직이 크고 분업이 명확하므로 에이전트를 더 세분화하는 것이 효과적입니다.

**추가 에이전트 예시:**

| 추가 에이전트 | 역할 |
|-------------|------|
| 생활지도부장 | 학생 생활지도 전담 (학년부장과 분리) |
| 진로상담부장 | 진로/진학 지도 전담 |
| 정보부장 | 학교 정보화 전담 |
| 학년별 부장 | 1학년부장, 2학년부장, 3학년부장 등 분리 |
| 특수교사 | 특수학급 운영 (통합교육 학교의 경우) |

**추가 시나리오 예시:**
- `career-guidance` (진로 지도 프로그램)
- `school-promotion` (학교 홍보/입학 설명회)
- `inter-school-collaboration` (학교 간 교류 프로그램)

### 특수학교/대안학교

일반 학교와 조직 구조가 다를 수 있으므로 에이전트를 학교 실정에 맞게 재구성합니다.

**특수학교 추가 에이전트 예시:**
- `special-education-coordinator` (특수교육 코디네이터)
- `therapist` (치료사 - 물리치료, 작업치료 등)
- `job-training-teacher` (직업전환 교사)

**대안학교 수정 예시:**
- 교장 에이전트를 "학교장"이나 "대표교사"로 수정
- 교과교사를 "프로젝트 퍼실리테이터"로 수정
- 시나리오를 학교 고유의 프로젝트 기반 학습 절차로 변경

---

## 변환 후 파일 수정 방법

`install.sh`로 생성된 출력 파일을 직접 수정할 수도 있습니다.

### Claude Code 출력 파일 수정

**에이전트 파일 수정** (`.claude/agents/axys-*.md`):

```markdown
---
name: axys-academic-head
description: |
  교무부장 (Academic Affairs Head) - 교육과정과 학사 운영 총괄

  Triggers: 교육과정, 시간표, 학사일정, 성적, 수업
permissionMode: acceptEdits
memory: project
model: sonnet
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Task(axys-homeroom-teacher)
  - Task(axys-subject-teacher)
---
```

수정 가능한 항목:
- `description`: 에이전트 설명과 트리거 키워드
- `model`: 사용할 AI 모델 (opus, sonnet, haiku)
- `tools`: 에이전트가 사용할 도구 목록

**커맨드 파일 수정** (`.claude/commands/axys-*.md`):

커맨드 파일의 워크플로우 절차를 직접 편집하여 업무 흐름을 조정할 수 있습니다.

### Gemini CLI / Codex CLI 출력 파일 수정

`GEMINI.md` 또는 `AGENTS.md`를 텍스트 편집기로 열어 직접 수정합니다. 에이전트 역할 설명이나 시나리오 절차를 자유롭게 변경할 수 있습니다.

### 수정 시 주의사항

- 유니버설 원본 파일(`agents/`, `scenarios/`)을 수정한 후 `install.sh`를 다시 실행하면 **출력 파일이 새로 생성**됩니다. 출력 파일에 직접 수정한 내용은 덮어쓰기됩니다.
- 지속적으로 유지해야 하는 변경은 유니버설 원본 파일에서 수정하는 것을 권장합니다.
- 출력 파일만 수정하는 경우, 향후 `install.sh` 재실행 시 변경 사항이 사라질 수 있으므로 별도로 백업해 두세요.
