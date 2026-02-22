#!/usr/bin/env bash
# AXYS Codex CLI 어댑터: AGENTS.md 생성 스크립트
# Codex CLI의 AGENTS.md 형식으로 에이전트/시나리오 정보를 통합합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADAPTER_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# common.sh 로드
source "$SCRIPT_DIR/../common.sh"

# ─── 인자 처리 ────────────────────────────────────────────────
SCHOOL_NAME="${1:-}"
OUTPUT_DIR="${2:-./output/codex-cli}"

if [ -z "$SCHOOL_NAME" ]; then
    log_error "학교명이 지정되지 않았습니다."
    exit 1
fi

AGENTS_SOURCE_DIR="$ADAPTER_ROOT/agents"
SCENARIOS_SOURCE_DIR="$ADAPTER_ROOT/scenarios"
OUTPUT_FILE="$OUTPUT_DIR/AGENTS.md"

ensure_dir "$OUTPUT_DIR"

# ─── AGENTS.md 생성 ──────────────────────────────────────────

{
    echo "# AXYS Agents - ${SCHOOL_NAME}"
    echo ""
    echo "이 문서는 ${SCHOOL_NAME}의 AI 에이전트 팀 구성을 Codex CLI 형식으로 정의합니다."
    echo ""

    # ─── 조직도 요약 ──────────────────────────────────────────
    echo "## 조직도"
    echo ""
    echo "| 에이전트 | 역할 | 상위 보고 | 의사결정 권한 |"
    echo "|---------|------|----------|-------------|"

    for agent_file in "$AGENTS_SOURCE_DIR"/*.md; do
        basename_file=$(basename "$agent_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$agent_file" "id") || continue
        name_ko=$(get_yaml_field "$agent_file" "name_ko") || name_ko=""
        reports_to=$(get_yaml_field "$agent_file" "reports_to" 2>/dev/null) || reports_to="-"
        decision_authority=$(get_yaml_field "$agent_file" "decision_authority") || decision_authority=""

        [ -z "$reports_to" ] && reports_to="-"
        echo "| \`${id}\` | ${name_ko} | ${reports_to} | ${decision_authority} |"
    done

    echo ""

    # ─── 에이전트 상세 ────────────────────────────────────────
    echo "## 에이전트 상세"
    echo ""

    for agent_file in "$AGENTS_SOURCE_DIR"/*.md; do
        basename_file=$(basename "$agent_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$agent_file" "id") || continue
        name_ko=$(get_yaml_field "$agent_file" "name_ko") || name_ko=""
        name_en=$(get_yaml_field "$agent_file" "name_en") || name_en=""
        decision_authority=$(get_yaml_field "$agent_file" "decision_authority") || decision_authority=""

        # 본문 추출 및 치환
        body=$(get_body_content "$agent_file")
        body=$(replace_school_name_in_string "$body" "$SCHOOL_NAME")

        echo "### ${name_ko} (${name_en})"
        echo "- **ID**: \`${id}\`"
        echo "- **의사결정 권한**: ${decision_authority}"
        echo ""
        echo "$body"
        echo ""
    done

    # ─── 시나리오 워크플로우 ──────────────────────────────────
    echo "## 시나리오 워크플로우"
    echo ""

    for scenario_file in "$SCENARIOS_SOURCE_DIR"/*.md; do
        [ ! -f "$scenario_file" ] && continue
        basename_file=$(basename "$scenario_file")
        echo "$basename_file" | grep -q '^_' && continue

        id=$(get_yaml_field "$scenario_file" "id") || continue
        name_ko=$(get_yaml_field "$scenario_file" "name_ko") || name_ko=""
        lead=$(get_yaml_field "$scenario_file" "lead") || lead=""

        # 본문 추출 및 치환
        body=$(get_body_content "$scenario_file")
        body=$(replace_school_name_in_string "$body" "$SCHOOL_NAME")

        echo "### ${name_ko}"
        echo "- **주관**: ${lead}"
        echo ""
        echo "$body"
        echo ""
    done

} > "$OUTPUT_FILE"

log_success "AGENTS.md 생성 완료: ${OUTPUT_FILE}"
