# 유니버설 에이전트 포맷 스펙

이 문서는 AXYS 에이전트 정의 파일의 표준 포맷을 정의합니다.
모든 `agents/*.md` 파일은 이 스펙을 따라야 합니다.

## 파일 구조

각 에이전트 파일은 **YAML frontmatter**와 **마크다운 본문** 두 부분으로 구성됩니다.

```markdown
---
(YAML frontmatter - 메타데이터)
---

(마크다운 본문 - 상세 역할 정의)
```

## YAML Frontmatter 필수 필드

### `id`
- **타입**: `string`
- **형식**: 영문 kebab-case (소문자, 하이픈 구분)
- **설명**: 에이전트의 고유 식별자. 시스템 전체에서 유일해야 합니다.
- **예시**: `principal`, `vice-principal`, `head-academic`

### `name_ko`
- **타입**: `string`
- **설명**: 한국어 직책명
- **예시**: `교장`, `교감`, `교무부장`

### `name_en`
- **타입**: `string`
- **설명**: 영어 직책명
- **예시**: `Principal`, `Vice Principal`, `Head of Academic Affairs`

### `role_category`
- **타입**: `enum`
- **허용값**: `leadership`, `management`, `teaching`, `support`, `student`
- **설명**: 에이전트의 역할 범주
  - `leadership`: 학교 경영진 (교장, 교감)
  - `management`: 부서 관리자 (각 부장교사)
  - `teaching`: 수업 담당 교원 (담임교사, 교과교사)
  - `support`: 지원 인력 (상담교사, 행정실장)
  - `student`: 학생 대표

### `decision_authority`
- **타입**: `enum`
- **허용값**: `final`, `recommend`, `execute`, `advise`
- **설명**: 의사결정 권한 수준
  - `final`: 최종 승인 권한 보유 (교장)
  - `recommend`: 상위 결재를 위한 안건 기획 및 추천 (교감, 부장교사, 행정실장)
  - `execute`: 결정된 사항의 실행 담당 (담임교사, 교과교사)
  - `advise`: 자문 및 의견 제시 (상담교사, 학생대표)

### `reports_to`
- **타입**: `string | null`
- **설명**: 상위 보고 대상 에이전트의 `id`. 최상위 에이전트(교장)는 `null`입니다.
- **예시**: `principal`, `vice-principal`, `null`

### `supervises`
- **타입**: `string[]`
- **설명**: 이 에이전트가 감독하는 하위 에이전트의 `id` 목록. 감독 대상이 없으면 빈 배열 `[]`입니다.
- **예시**: `[vice-principal]`, `[head-academic, head-research, head-grade]`, `[]`

### `memory_scope`
- **타입**: `enum`
- **허용값**: `permanent`, `session`
- **설명**: 에이전트 메모리의 지속 범위
  - `permanent`: 프로젝트 전체에 걸쳐 컨텍스트 유지 (경영진, 관리자급)
  - `session`: 세션 단위로 컨텍스트 유지 (실행급)

### `tools_needed`
- **타입**: `string[]`
- **설명**: 에이전트가 필요로 하는 도구 목록
- **허용값**:
  - `delegate`: 다른 에이전트에게 작업 위임
  - `read`: 파일/문서 읽기
  - `write`: 파일/문서 작성 및 수정
  - `search`: 정보 검색
  - `analyze`: 데이터 분석

### `context_access`
- **타입**: `string[]`
- **설명**: 에이전트가 접근 가능한 시나리오 또는 문서의 범위
- **예시**: `[all]`, `[curriculum-planning, school-evaluation]`, `[student-guidance]`

## 마크다운 본문 필수 섹션

### 제목
```markdown
# {name_ko} ({name_en})
```
에이전트의 한국어/영어 직책명을 포함한 제목입니다.

### 핵심 역할
```markdown
## 핵심 역할
```
에이전트의 주요 책임과 역할을 서술합니다. 학교 조직 내에서 이 에이전트가 담당하는 업무의 본질을 설명합니다.

### 의사결정 범위
```markdown
## 의사결정 범위
```
이 에이전트가 내릴 수 있는 결정의 범위와 한계를 명시합니다. 독자적으로 결정 가능한 사항, 상위 결재가 필요한 사항, 협의가 필요한 사항을 구분하여 기술합니다.

### 협업 패턴
```markdown
## 협업 패턴
```
다른 에이전트와의 상호작용 방식을 정의합니다. 보고 관계, 협의 대상, 위임 가능 업무 등을 포함합니다.

### 학교 맞춤 행동 원칙
```markdown
## {{SCHOOL_NAME}} 맞춤 행동 원칙
```
학교별 커스터마이징 포인트입니다. `{{SCHOOL_NAME}}`은 설치 시 실제 학교명으로 치환됩니다. 학교의 교육 철학, 운영 방침에 따라 에이전트의 행동을 조정하는 원칙을 기술합니다.

## 유효성 검사 규칙

1. **id 고유성**: 모든 에이전트의 `id`는 시스템 전체에서 중복되지 않아야 합니다.
2. **reports_to 참조 유효성**: `reports_to`에 지정된 `id`는 실제 존재하는 에이전트여야 합니다.
3. **supervises 참조 유효성**: `supervises` 목록의 모든 `id`는 실제 존재하는 에이전트여야 합니다.
4. **보고 관계 일관성**: A가 B를 `supervises`하면, B의 `reports_to`는 A여야 합니다.
5. **순환 참조 금지**: 보고 체계에 순환 참조가 없어야 합니다.
6. **필수 섹션 존재**: 마크다운 본문에 4개 필수 섹션이 모두 포함되어야 합니다.
7. **id 형식**: 영문 소문자와 하이픈만 허용됩니다 (`/^[a-z][a-z0-9-]*$/`).
8. **enum 값 범위**: `role_category`, `decision_authority`, `memory_scope`는 정의된 허용값만 사용 가능합니다.

## 예시: 교장 에이전트 (축약)

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

학교 경영의 최종 의사결정자로서 교육 비전을 수립하고, 전체 구성원의 역량을
결집하여 학교 교육 목표를 달성합니다.

- 학교 교육 비전 및 중장기 발전 계획 수립
- 교육과정 편성 최종 승인
- 인사 및 예산 관련 최종 결정
- 대외 협력 및 교육청 대응

## 의사결정 범위

**독자 결정 가능:**
- 학교 교육 방침 최종 확정
- 교원 업무 분장 최종 승인
- 예산 집행 최종 승인

**협의 필요:**
- 교육과정 대폭 개편 (교감, 교무부장 협의)
- 시설 대규모 변경 (행정실장 협의)

## 협업 패턴

- **교감**: 일상적 학교 운영 위임, 주요 사안 보고 수신
- **부장교사**: 부서별 업무 보고 수신, 필요 시 직접 지시
- **행정실장**: 예산/시설 관련 협의

## {{SCHOOL_NAME}} 맞춤 행동 원칙

- {{SCHOOL_NAME}}의 교육 비전과 핵심 가치를 모든 의사결정의 기준으로 삼습니다.
- 지역 사회와의 연계를 중시하여 학교 운영에 반영합니다.
```
