#!/usr/bin/env bash
# AXYS Claude Code 어댑터: CLAUDE.md 생성 스크립트
# 에이전트 목록과 커맨드 목록을 종합하여 프로젝트 CLAUDE.md 섹션을 생성합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADAPTER_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# common.sh 로드
source "$SCRIPT_DIR/../common.sh"

# ─── 인자 처리 ────────────────────────────────────────────────
SCHOOL_NAME="${1:-}"
OUTPUT_DIR="${2:-./output/claude-code}"

if [ -z "$SCHOOL_NAME" ]; then
    log_error "학교명이 지정되지 않았습니다."
    exit 1
fi

AGENTS_SOURCE_DIR="$ADAPTER_ROOT/agents"
SCENARIOS_SOURCE_DIR="$ADAPTER_ROOT/scenarios"
OUTPUT_FILE="$OUTPUT_DIR/CLAUDE.md"

# ─── CLAUDE.md 생성 ──────────────────────────────────────────

{
    cat << 'HEADER'
# AXYS - AI 학교 운영 지원 시스템

HEADER

    echo "## 학교 정보"
    echo "- **학교명**: ${SCHOOL_NAME}"
    echo ""

    echo "## AXYS 소개"
    echo "AXYS는 학교 운영의 핵심 업무를 AI 에이전트 팀이 지원하는 시스템입니다."
    echo "각 에이전트는 학교 조직의 실제 역할을 반영하며, 시나리오 기반으로 협력합니다."
    echo ""

    # ─── 에이전트 목록 ────────────────────────────────────────
    echo "## 사용 가능한 에이전트"
    echo ""
    echo "| 에이전트 | 역할 | 권한 | 모델 |"
    echo "|---------|------|------|------|"

    for agent_file in "$AGENTS_SOURCE_DIR"/*.md; do
        basename_file=$(basename "$agent_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$agent_file" "id") || continue
        name_ko=$(get_yaml_field "$agent_file" "name_ko") || name_ko=""
        name_en=$(get_yaml_field "$agent_file" "name_en") || name_en=""
        decision_authority=$(get_yaml_field "$agent_file" "decision_authority") || decision_authority="execute"
        model=$(map_decision_authority_to_model "$decision_authority")

        echo "| \`axys-${id}\` | ${name_ko} (${name_en}) | ${decision_authority} | ${model} |"
    done

    echo ""

    # ─── 시나리오 커맨드 목록 ─────────────────────────────────
    echo "## 사용 가능한 시나리오 커맨드"
    echo ""
    echo "| 커맨드 | 시나리오 | 주관 에이전트 |"
    echo "|--------|---------|-------------|"

    for scenario_file in "$SCENARIOS_SOURCE_DIR"/*.md; do
        [ ! -f "$scenario_file" ] && continue
        basename_file=$(basename "$scenario_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$scenario_file" "id") || continue
        name_ko=$(get_yaml_field "$scenario_file" "name_ko") || name_ko=""
        lead=$(get_yaml_field "$scenario_file" "lead") || lead=""

        echo "| \`/axys-${id}\` | ${name_ko} | axys-${lead} |"
    done

    echo ""

    # ─── 빠른 사용법 ─────────────────────────────────────────
    cat << 'USAGE'
## 빠른 사용법

### 시나리오 실행
시나리오를 실행하려면 해당 커맨드를 사용하세요:
```
/axys-curriculum-planning
/axys-school-evaluation
```

### 특정 에이전트에게 직접 요청
특정 에이전트에게 직접 작업을 요청할 수도 있습니다:
```
axys-principal 에이전트에게 학교 교육 비전에 대해 자문을 요청합니다.
```

### 참고 사항
- 모든 에이전트는 한국어로 응답합니다.
- 에이전트 간 협업은 시나리오 커맨드를 통해 자동으로 이루어집니다.
- 각 에이전트는 자신의 역할 범위 내에서 의사결정을 수행합니다.
USAGE

} > "$OUTPUT_FILE"

log_success "CLAUDE.md 생성 완료: ${OUTPUT_FILE}"
