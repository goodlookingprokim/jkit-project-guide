#!/usr/bin/env bash
# AXYS Claude Code 어댑터 메인 스크립트
# 유니버설 에이전트/시나리오를 Claude Code 네이티브 포맷으로 변환합니다.
#
# 사용법:
#   ./adapter.sh --school-name "학교명" [--output-dir "출력경로"]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# common.sh 로드
source "$SCRIPT_DIR/../common.sh"

# ─── 인자 파싱 ────────────────────────────────────────────────
SCHOOL_NAME=""
OUTPUT_DIR="./output/claude-code"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --school-name)
            SCHOOL_NAME="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            log_error "알 수 없는 옵션: $1"
            exit 1
            ;;
    esac
done

if [ -z "$SCHOOL_NAME" ]; then
    log_error "학교명이 지정되지 않았습니다. --school-name 옵션을 사용하세요."
    exit 1
fi

# ─── 실행 시작 ────────────────────────────────────────────────
log_info "========================================="
log_info "AXYS Claude Code 어댑터"
log_info "학교명: ${SCHOOL_NAME}"
log_info "출력 경로: ${OUTPUT_DIR}"
log_info "========================================="

# 출력 디렉토리 생성
ensure_dir "$OUTPUT_DIR/.claude/agents"
ensure_dir "$OUTPUT_DIR/.claude/commands"

# Step 1: 에이전트 변환
log_info ""
log_info "[1/3] 에이전트 변환 중..."
AGENT_COUNT=$("$SCRIPT_DIR/generate-agents.sh" "$SCHOOL_NAME" "$OUTPUT_DIR" | tail -1)

# Step 2: 커맨드 변환
log_info ""
log_info "[2/3] 시나리오 커맨드 변환 중..."
COMMAND_COUNT=$("$SCRIPT_DIR/generate-commands.sh" "$SCHOOL_NAME" "$OUTPUT_DIR" | tail -1)

# Step 3: CLAUDE.md 생성
log_info ""
log_info "[3/3] CLAUDE.md 생성 중..."
"$SCRIPT_DIR/generate-claudemd.sh" "$SCHOOL_NAME" "$OUTPUT_DIR"

# ─── 결과 요약 ────────────────────────────────────────────────
log_info ""
log_info "========================================="
log_success "Claude Code 어댑터 변환 완료!"
log_info "========================================="
log_info "  에이전트: ${AGENT_COUNT}개 -> ${OUTPUT_DIR}/.claude/agents/"
log_info "  커맨드:   ${COMMAND_COUNT}개 -> ${OUTPUT_DIR}/.claude/commands/"
log_info "  설정:     CLAUDE.md -> ${OUTPUT_DIR}/CLAUDE.md"
log_info ""
log_info "사용법:"
log_info "  1. ${OUTPUT_DIR}/.claude/ 디렉토리를 프로젝트 루트에 복사하세요."
log_info "  2. ${OUTPUT_DIR}/CLAUDE.md 내용을 프로젝트 CLAUDE.md에 추가하세요."
log_info "  3. Claude Code에서 /axys-{시나리오} 커맨드로 시나리오를 실행하세요."
log_info "========================================="
