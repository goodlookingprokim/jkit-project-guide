#!/usr/bin/env bash
# AXYS Claude Code 어댑터: 에이전트 변환 스크립트
# agents/*.md 파일을 .claude/agents/axys-{id}.md 형식으로 변환합니다.

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
AGENTS_OUTPUT_DIR="$OUTPUT_DIR/.claude/agents"

ensure_dir "$AGENTS_OUTPUT_DIR"

# ─── 에이전트 변환 ────────────────────────────────────────────
AGENT_COUNT=0

for agent_file in "$AGENTS_SOURCE_DIR"/*.md; do
    # _로 시작하는 파일(스키마 등) 건너뛰기
    basename_file=$(basename "$agent_file")
    if echo "$basename_file" | grep -q '^_'; then
        continue
    fi

    # YAML frontmatter에서 필드 추출
    id=$(get_yaml_field "$agent_file" "id") || continue
    name_ko=$(get_yaml_field "$agent_file" "name_ko") || name_ko=""
    name_en=$(get_yaml_field "$agent_file" "name_en") || name_en=""
    decision_authority=$(get_yaml_field "$agent_file" "decision_authority") || decision_authority="execute"
    memory_scope=$(get_yaml_field "$agent_file" "memory_scope") || memory_scope="session"

    # tools_needed 추출 (쉼표 구분 문자열로)
    tools_csv=$(get_yaml_field "$agent_file" "tools_needed" | tr '\n' ',' | sed 's/,$//')

    # supervises 추출 (쉼표 구분 문자열로)
    supervises_csv=$(get_yaml_field "$agent_file" "supervises" 2>/dev/null | tr '\n' ',' | sed 's/,$//') || supervises_csv=""

    # 본문 추출
    body=$(get_body_content "$agent_file")

    # 핵심 역할 첫 문장 추출 (description용)
    first_sentence=$(echo "$body" | sed -n '/^## 핵심 역할/,/^## /{/^## 핵심 역할/d; /^## /d; p;}' | sed '/^$/d' | head -1 | sed 's/[[:space:]]*$//')

    # Claude Code 필드 변환
    AGENT_NAME="axys-${id}"
    MODEL=$(map_decision_authority_to_model "$decision_authority")
    PERMISSION_MODE=$(map_decision_authority_to_permission "$decision_authority")
    MEMORY_LINE=$(map_memory_scope "$memory_scope")
    TOOLS_LIST=$(map_tools_needed "$tools_csv" "$supervises_csv")

    # description 구성
    DESCRIPTION="${name_ko} (${name_en}) - ${first_sentence}"

    # 본문에서 {{SCHOOL_NAME}} 치환
    body=$(replace_school_name_in_string "$body" "$SCHOOL_NAME")

    # 출력 파일 생성
    output_file="$AGENTS_OUTPUT_DIR/${AGENT_NAME}.md"

    {
        echo "---"
        echo "name: ${AGENT_NAME}"
        echo "description: |"
        echo "  ${DESCRIPTION}"
        echo "permissionMode: ${PERMISSION_MODE}"
        if [ -n "$MEMORY_LINE" ]; then
            echo "$MEMORY_LINE"
        fi
        echo "model: ${MODEL}"
        echo "tools:"
        echo "$TOOLS_LIST"
        echo "---"
        echo ""
        echo "$body"
    } > "$output_file"

    AGENT_COUNT=$((AGENT_COUNT + 1))
    log_success "에이전트 변환 완료: ${AGENT_NAME} (${name_ko})"
done

log_info "총 ${AGENT_COUNT}개 에이전트 변환 완료 -> ${AGENTS_OUTPUT_DIR}"
echo "$AGENT_COUNT"
