#!/usr/bin/env bash
# AXYS Gemini CLI 어댑터 메인 스크립트
# 유니버설 에이전트/시나리오를 GEMINI.md 형식으로 변환합니다.
#
# 사용법:
#   ./adapter.sh --school-name "학교명" [--output-dir "출력경로"]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# common.sh 로드
source "$SCRIPT_DIR/../common.sh"

# ─── 인자 파싱 ────────────────────────────────────────────────
SCHOOL_NAME=""
OUTPUT_DIR="./output/gemini-cli"

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
log_info "AXYS Gemini CLI 어댑터"
log_info "학교명: ${SCHOOL_NAME}"
log_info "출력 경로: ${OUTPUT_DIR}"
log_info "========================================="

ensure_dir "$OUTPUT_DIR"

# GEMINI.md 생성
log_info ""
log_info "[1/1] GEMINI.md 생성 중..."
"$SCRIPT_DIR/generate-geminimd.sh" "$SCHOOL_NAME" "$OUTPUT_DIR"

# ─── 결과 요약 ────────────────────────────────────────────────
log_info ""
log_info "========================================="
log_success "Gemini CLI 어댑터 변환 완료!"
log_info "========================================="
log_info "  출력: ${OUTPUT_DIR}/GEMINI.md"
log_info ""
log_info "사용법:"
log_info "  gemini -p \"@${OUTPUT_DIR}/GEMINI.md 교육과정을 편성해주세요.\""
log_info "========================================="
