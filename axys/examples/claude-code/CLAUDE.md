# AXYS -- 테스트학교 AI 에이전트 시스템

> 테스트학교의 학교 업무를 AI 에이전트 팀이 도와드립니다.

## 에이전트 목록

| 직책 | 에이전트 ID | 역할 | 의사결정 |
|------|-----------|------|---------|
| 교장 | `axys-principal` | 학교 경영 최종 책임자, 교육 비전 수립, 최종 승인 | final |
| 교감 | `axys-vice-principal` | 학교 운영 실무 총괄, 업무 조율, 위기 대응 | final |
| 교무부장 | `axys-academic-head` | 교육과정 편성, 시간표, 학사일정, 성적 관리 | recommend |
| 연구부장 | `axys-research-head` | 교원 연수, 수업 혁신, 디지털 전환 | recommend |
| 학년부장 | `axys-grade-head` | 학년 학생 생활지도, 학년 행사, 학기 전환 | execute |
| 담임교사 | `axys-homeroom-teacher` | 학급 경영, 학부모 소통, 학생 관찰 | execute |
| 교과교사 | `axys-subject-teacher` | 교과 수업 설계, 평가, 수업 연구 | advise |
| 상담교사 | `axys-counselor` | 학생 심리 상담, 위기 개입, 학부모 상담 | advise |
| 행정실장 | `axys-admin-head` | 예산 편성, 시설 관리, 물품 조달, 행정 | recommend |
| 학생대표 | `axys-student-rep` | 학생 의견 수렴, 자치 활동, 행사 참여 | advise |

## 커맨드 목록

| 커맨드 | 시나리오 | 주관 에이전트 |
|--------|----------|-------------|
| `/axys-curriculum-planning` | 교육과정 편성 | 교무부장 |
| `/axys-event-planning` | 학교 행사 기획 | 교감 |
| `/axys-budget-planning` | 예산 편성 | 행정실장 |
| `/axys-student-guidance` | 학생 생활지도 | 학년부장 |
| `/axys-teacher-development` | 교원 연수 계획 | 연구부장 |
| `/axys-safety-plan` | 학교 안전 계획 | 교감 |
| `/axys-evaluation` | 학교 자체 평가 | 교감 |
| `/axys-parent-communication` | 학부모 소통 | 교감 |
| `/axys-innovation-project` | 혁신학교/특색사업 | 연구부장 |
| `/axys-semester-transition` | 학기 전환 업무 | 교감 |
| `/axys-emergency-response` | 위기 대응 매뉴얼 | 교감 |
| `/axys-digital-transition` | 디지털 전환 | 연구부장 |
| `/axys-community-connection` | 지역사회 연계 | 연구부장 |

## 빠른 사용법

### 자연어로 요청하기

일상적인 대화로 요청하면 관련 에이전트가 자동으로 활성화됩니다:

```
"교육과정을 편성하고 싶어"          -> 교무부장 에이전트 활성화
"체육대회를 기획해줘"              -> 교감 에이전트 활성화
"올해 예산을 편성해야 해"           -> 행정실장 에이전트 활성화
"학생 상담이 필요해"               -> 상담교사 에이전트 활성화
```

### 시나리오 커맨드 사용하기

슬래시 커맨드로 정해진 업무 절차를 단계별로 진행합니다:

```
/axys-curriculum-planning           교육과정 편성 3단계 워크플로우 시작
/axys-event-planning 체육대회       체육대회 기획 워크플로우 시작
/axys-budget-planning              예산 편성 워크플로우 시작
```

### 에이전트 간 협업

에이전트들은 자동으로 협업합니다. 예를 들어 교육과정 편성 시:
1. **교무부장**이 편성 초안을 작성합니다
2. **교과교사**에게 교과별 의견을 요청합니다
3. **교감**이 검토하고 피드백합니다
4. **교장**이 최종 승인합니다

### 조직도

```
교장 ─── 교감 ─┬─ 교무부장 ─┬─ 교과교사
               │           └─ 담임교사 ── 학생대표
               ├─ 연구부장
               ├─ 학년부장 ── 담임교사
               ├─ 행정실장
               └─ 상담교사
```
