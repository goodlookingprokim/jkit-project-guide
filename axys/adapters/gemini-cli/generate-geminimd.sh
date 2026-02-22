#!/usr/bin/env bash
# AXYS Gemini CLI 어댑터: GEMINI.md 생성 스크립트
# 모든 에이전트와 시나리오를 하나의 GEMINI.md 문서로 통합합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADAPTER_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# common.sh 로드
source "$SCRIPT_DIR/../common.sh"

# ─── 인자 처리 ────────────────────────────────────────────────
SCHOOL_NAME="${1:-}"
OUTPUT_DIR="${2:-./output/gemini-cli}"

if [ -z "$SCHOOL_NAME" ]; then
    log_error "학교명이 지정되지 않았습니다."
    exit 1
fi

AGENTS_SOURCE_DIR="$ADAPTER_ROOT/agents"
SCENARIOS_SOURCE_DIR="$ADAPTER_ROOT/scenarios"
OUTPUT_FILE="$OUTPUT_DIR/GEMINI.md"

ensure_dir "$OUTPUT_DIR"

# ─── GEMINI.md 생성 ──────────────────────────────────────────

{
    echo "# AXYS - ${SCHOOL_NAME} AI 학교 운영 지원 시스템"
    echo ""
    echo "이 문서는 ${SCHOOL_NAME}의 AI 에이전트 팀 구성과 시나리오 워크플로우를 정의합니다."
    echo "Gemini CLI에서 \`@GEMINI.md\`로 참조하여 사용하세요."
    echo ""

    # ─── 에이전트 역할 정의 ───────────────────────────────────
    echo "---"
    echo ""
    echo "## 에이전트 역할 정의"
    echo ""

    for agent_file in "$AGENTS_SOURCE_DIR"/*.md; do
        basename_file=$(basename "$agent_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$agent_file" "id") || continue
        name_ko=$(get_yaml_field "$agent_file" "name_ko") || name_ko=""
        name_en=$(get_yaml_field "$agent_file" "name_en") || name_en=""
        role_category=$(get_yaml_field "$agent_file" "role_category") || role_category=""
        decision_authority=$(get_yaml_field "$agent_file" "decision_authority") || decision_authority=""
        reports_to=$(get_yaml_field "$agent_file" "reports_to" 2>/dev/null) || reports_to="없음"
        supervises_list=$(get_yaml_field "$agent_file" "supervises" 2>/dev/null | tr '\n' ', ' | sed 's/,$//' | sed 's/,$//') || supervises_list="없음"

        # 본문 추출 및 치환
        body=$(get_body_content "$agent_file")
        body=$(replace_school_name_in_string "$body" "$SCHOOL_NAME")

        echo "### ${name_ko} (${name_en}) [${id}]"
        echo ""
        echo "- **역할 범주**: ${role_category}"
        echo "- **의사결정 권한**: ${decision_authority}"
        echo "- **상위 보고**: ${reports_to}"
        echo "- **감독 대상**: ${supervises_list:-없음}"
        echo ""
        echo "$body"
        echo ""
    done

    # ─── 시나리오 워크플로우 ──────────────────────────────────
    echo "---"
    echo ""
    echo "## 시나리오 워크플로우"
    echo ""

    for scenario_file in "$SCENARIOS_SOURCE_DIR"/*.md; do
        [ ! -f "$scenario_file" ] && continue
        basename_file=$(basename "$scenario_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$scenario_file" "id") || continue
        name_ko=$(get_yaml_field "$scenario_file" "name_ko") || name_ko=""
        lead=$(get_yaml_field "$scenario_file" "lead") || lead=""
        participants_list=$(get_yaml_field "$scenario_file" "participants" 2>/dev/null | tr '\n' ', ' | sed 's/,$//') || participants_list=""
        estimated_duration=$(get_yaml_field "$scenario_file" "estimated_duration") || estimated_duration=""

        # 본문 추출 및 치환
        body=$(get_body_content "$scenario_file")
        body=$(replace_school_name_in_string "$body" "$SCHOOL_NAME")

        echo "### 시나리오: ${name_ko} [${id}]"
        echo ""
        echo "- **주관**: ${lead}"
        echo "- **참여자**: ${participants_list}"
        echo "- **예상 기간**: ${estimated_duration}"
        echo ""
        echo "$body"
        echo ""
    done

    # ─── 사용 안내 ────────────────────────────────────────────
    echo "---"
    echo ""
    echo "## 사용 안내"
    echo ""
    echo "### Gemini CLI에서 활용"
    echo "\`\`\`bash"
    echo "# 전체 시스템 참조"
    echo "gemini -p \"@GEMINI.md ${SCHOOL_NAME}의 교육과정을 편성해주세요.\""
    echo ""
    echo "# 특정 시나리오 실행"
    echo "gemini -p \"@GEMINI.md 학교평가 시나리오를 시작해주세요.\""
    echo "\`\`\`"

} > "$OUTPUT_FILE"

log_success "GEMINI.md 생성 완료: ${OUTPUT_FILE}"
