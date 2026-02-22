# AXYS - AI School Agent System

> AI로 학교 업무를 혁신하는 멀티 플랫폼 에이전트 시스템

## 주요 특징

- **유니버설 에이전트 포맷**: 플랫폼에 종속되지 않는 표준화된 에이전트 정의 형식
- **멀티 플랫폼 지원**: Claude Code, Gemini CLI, Codex CLI 등 다양한 AI 플랫폼 자동 변환
- **학교 맞춤 시나리오**: 교육과정 편성, 학교 평가, 행사 운영 등 실제 학교 업무 13개 시나리오 내장

## 빠른 시작

```bash
# 1. 저장소 클론
git clone https://github.com/your-org/axys.git
cd axys

# 2. 설치 스크립트 실행 (학교명 지정)
./install.sh --school "한빛초등학교" --platform claude-code

# 3. 생성된 설정 파일 확인
ls output/claude-code/
```

### 지원 플랫폼

| 플랫폼 | 어댑터 | 출력 파일 |
|--------|--------|----------|
| Claude Code | `adapters/claude-code/` | `.claude/agents/*.yml`, `CLAUDE.md` 슬래시 커맨드 |
| Gemini CLI | `adapters/gemini-cli/` | `GEMINI.md` |
| Codex CLI | `adapters/codex-cli/` | `AGENTS.md` |

## 디렉토리 구조

```
axys/
├── README.md                    # 이 파일
├── LICENSE                      # MIT 라이선스
├── ARCHITECTURE.md              # 기술 아키텍처 문서
├── .gitignore
├── install.sh                   # 설치 및 변환 스크립트
├── agents/                      # 유니버설 에이전트 정의
│   ├── _schema.md               # 에이전트 포맷 스펙
│   ├── principal.md             # 교장
│   ├── vice-principal.md        # 교감
│   ├── head-academic.md         # 교무부장
│   ├── head-research.md         # 연구부장
│   ├── head-grade.md            # 학년부장
│   ├── homeroom-teacher.md      # 담임교사
│   ├── subject-teacher.md       # 교과교사
│   ├── counselor.md             # 상담교사
│   ├── admin-director.md        # 행정실장
│   └── student-representative.md # 학생대표
├── scenarios/                   # 유니버설 시나리오 정의
│   ├── _schema.md               # 시나리오 포맷 스펙
│   ├── curriculum-planning.md   # 교육과정 편성
│   ├── school-evaluation.md     # 학교 평가
│   ├── budget-planning.md       # 예산 편성
│   ├── event-management.md      # 학교 행사 운영
│   ├── student-guidance.md      # 학생 생활지도
│   ├── teacher-training.md      # 교원 연수 계획
│   ├── facility-management.md   # 시설 관리
│   ├── parent-communication.md  # 학부모 소통
│   ├── emergency-response.md    # 위기 대응
│   ├── grading-assessment.md    # 성적 평가
│   ├── class-assignment.md      # 학급 편성
│   ├── new-semester-prep.md     # 신학기 준비
│   └── graduation-ceremony.md   # 졸업식 준비
├── adapters/                    # 플랫폼별 변환 어댑터
│   ├── claude-code/
│   ├── gemini-cli/
│   └── codex-cli/
├── examples/                    # 사용 예시
└── docs/                        # 추가 문서
```

## 에이전트 목록

| ID | 직책 (한국어) | 직책 (영어) | 역할 범주 | 의사결정 권한 |
|----|-------------|-----------|----------|-------------|
| `principal` | 교장 | Principal | leadership | final |
| `vice-principal` | 교감 | Vice Principal | leadership | recommend |
| `head-academic` | 교무부장 | Head of Academic Affairs | management | recommend |
| `head-research` | 연구부장 | Head of Research | management | recommend |
| `head-grade` | 학년부장 | Head of Grade Level | management | recommend |
| `homeroom-teacher` | 담임교사 | Homeroom Teacher | teaching | execute |
| `subject-teacher` | 교과교사 | Subject Teacher | teaching | execute |
| `counselor` | 상담교사 | School Counselor | support | advise |
| `admin-director` | 행정실장 | Administrative Director | support | recommend |
| `student-representative` | 학생대표 | Student Representative | student | advise |

## 시나리오 목록

| # | ID | 시나리오명 | 주관 에이전트 | 단계 |
|---|-----|----------|-------------|------|
| 1 | `curriculum-planning` | 교육과정 편성 | head-academic | planning |
| 2 | `school-evaluation` | 학교 평가 | vice-principal | evaluation |
| 3 | `budget-planning` | 예산 편성 | admin-director | planning |
| 4 | `event-management` | 학교 행사 운영 | head-academic | execution |
| 5 | `student-guidance` | 학생 생활지도 | counselor | execution |
| 6 | `teacher-training` | 교원 연수 계획 | head-research | planning |
| 7 | `facility-management` | 시설 관리 | admin-director | execution |
| 8 | `parent-communication` | 학부모 소통 | homeroom-teacher | execution |
| 9 | `emergency-response` | 위기 대응 | vice-principal | emergency |
| 10 | `grading-assessment` | 성적 평가 | subject-teacher | evaluation |
| 11 | `class-assignment` | 학급 편성 | head-grade | planning |
| 12 | `new-semester-prep` | 신학기 준비 | head-academic | planning |
| 13 | `graduation-ceremony` | 졸업식 준비 | head-academic | execution |

## 커스터마이징

### 학교명 변경

모든 에이전트와 시나리오 파일에는 `{{SCHOOL_NAME}}` 플레이스홀더가 포함되어 있습니다.
`install.sh` 실행 시 `--school` 옵션으로 학교명을 지정하면 자동으로 치환됩니다.

```bash
./install.sh --school "서울디지털초등학교" --platform claude-code
```

### 에이전트 추가

`agents/_schema.md`의 포맷 스펙을 참고하여 새로운 에이전트 파일을 추가할 수 있습니다.

### 시나리오 추가

`scenarios/_schema.md`의 포맷 스펙을 참고하여 학교 고유의 시나리오를 정의할 수 있습니다.

## 라이선스

MIT License - 자세한 내용은 [LICENSE](./LICENSE) 파일을 참조하세요.
