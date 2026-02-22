#!/usr/bin/env bash
# AXYS Claude Code 어댑터: 시나리오 → 커맨드 변환 스크립트
# scenarios/*.md 파일을 .claude/commands/axys-{id}.md 형식으로 변환합니다.

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

SCENARIOS_SOURCE_DIR="$ADAPTER_ROOT/scenarios"
COMMANDS_OUTPUT_DIR="$OUTPUT_DIR/.claude/commands"

ensure_dir "$COMMANDS_OUTPUT_DIR"

# ─── 시나리오에서 Phase 내용 추출 ─────────────────────────────

# extract_section: 마크다운 본문에서 특정 ## 섹션 내용 추출
extract_section() {
    local body="$1"
    local section_name="$2"
    echo "$body" | awk -v sect="$section_name" '
        $0 ~ "^## " sect { found=1; next }
        found && /^## / { found=0 }
        found { print }
    ' | sed '/^$/{ N; /^\n$/d; }'
}

# extract_phase: Phase N 섹션 추출
extract_phase() {
    local body="$1"
    local phase_num="$2"
    echo "$body" | awk -v pn="Phase ${phase_num}" '
        $0 ~ "^## " pn { found=1; next }
        found && /^## / { found=0 }
        found { print }
    ' | sed '1{ /^$/d; }; ${ /^$/d; }'
}

# ─── 시나리오 변환 ────────────────────────────────────────────
COMMAND_COUNT=0

for scenario_file in "$SCENARIOS_SOURCE_DIR"/*.md; do
    [ ! -f "$scenario_file" ] && continue

    # _로 시작하는 파일(스키마 등) 건너뛰기
    basename_file=$(basename "$scenario_file")
    if echo "$basename_file" | grep -q '^_'; then
        continue
    fi

    # YAML frontmatter에서 필드 추출
    id=$(get_yaml_field "$scenario_file" "id") || continue
    name_ko=$(get_yaml_field "$scenario_file" "name_ko") || name_ko=""
    lead=$(get_yaml_field "$scenario_file" "lead") || lead=""

    # participants 추출
    participants_list=$(get_yaml_field "$scenario_file" "participants" 2>/dev/null | tr '\n' ',' | sed 's/,$//') || participants_list=""

    # 본문 추출
    body=$(get_body_content "$scenario_file")

    # Purpose 섹션 추출
    purpose_content=$(extract_section "$body" "Purpose")

    # Phase 1, 2, 3 추출
    phase1_content=$(extract_phase "$body" "1")
    phase2_content=$(extract_phase "$body" "2")
    phase3_content=$(extract_phase "$body" "3")

    # Phase 2에 에이전트 위임 지시 추가
    # participants에서 각 에이전트에 대해 Task(axys-{id}) 위임 코멘트 추가
    delegation_note=""
    if [ -n "$participants_list" ]; then
        delegation_note="\n> **Agent Team 위임 지시**: 각 참여 에이전트에 대해 Task()를 사용하여 작업을 위임하세요.\n"
        IFS=',' read -ra parts <<< "$participants_list"
        for p in "${parts[@]}"; do
            p=$(echo "$p" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
            [ -z "$p" ] && continue
            delegation_note="${delegation_note}> - \`Task(axys-${p})\`로 ${p} 역할의 작업을 위임\n"
        done
    fi

    # {{SCHOOL_NAME}} 치환
    purpose_content=$(replace_school_name_in_string "$purpose_content" "$SCHOOL_NAME")
    phase1_content=$(replace_school_name_in_string "$phase1_content" "$SCHOOL_NAME")
    phase2_content=$(replace_school_name_in_string "$phase2_content" "$SCHOOL_NAME")
    phase3_content=$(replace_school_name_in_string "$phase3_content" "$SCHOOL_NAME")

    # 출력 파일 생성
    command_name="axys-${id}"
    output_file="$COMMANDS_OUTPUT_DIR/${command_name}.md"

    {
        echo "# ${name_ko} 시나리오"
        echo ""
        echo "**Agent**: Use the \`axys-${lead}\` agent for this command."
        echo "**Language**: Respond in **Korean** for all user-facing messages."
        echo ""
        echo "## Purpose"
        echo "$purpose_content"
        echo ""
        echo "## Input"
        echo "\`\$ARGUMENTS\` -- ${name_ko} 시나리오에 필요한 추가 정보나 지시사항."
        echo ""
        echo "## Implementation Flow"
        echo ""
        echo "### Step 1: 킥오프"
        echo "$phase1_content"
        echo ""
        echo "### Step 2: 역할별 작업"
        echo "$phase2_content"
        if [ -n "$delegation_note" ]; then
            echo ""
            echo -e "$delegation_note"
        fi
        echo ""
        echo "### Step 3: 통합 검증"
        echo "$phase3_content"
    } > "$output_file"

    COMMAND_COUNT=$((COMMAND_COUNT + 1))
    log_success "커맨드 변환 완료: /${command_name} (${name_ko})"
done

log_info "총 ${COMMAND_COUNT}개 커맨드 변환 완료 -> ${COMMANDS_OUTPUT_DIR}"
echo "$COMMAND_COUNT"
