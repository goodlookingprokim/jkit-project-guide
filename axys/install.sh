#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# AXYS Installer
# AI 학교 운영 지원 시스템 설치 스크립트
#
# 유니버설 에이전트/시나리오를 선택한 CLI 플랫폼에 맞게 변환합니다.
#
# 사용법:
#   ./install.sh [--school-name "학교명"] [--cli claude-code|gemini-cli|codex-cli|all]
#   ./install.sh --help
#
# 옵션:
#   --school-name  학교명 (미입력 시 대화형으로 입력 받음)
#   --cli          대상 CLI 플랫폼 (미지정 시 감지된 CLI 모두에 대해 실행)
#   --output-dir   출력 기본 경로 (기본값: ./output)
#   --help         도움말 출력
# ═══════════════════════════════════════════════════════════════

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# common.sh 로드
source "$SCRIPT_DIR/adapters/common.sh"

# ─── 도움말 ───────────────────────────────────────────────────
show_help() {
    cat << 'EOF'
AXYS Installer - AI 학교 운영 지원 시스템

사용법:
  ./install.sh [옵션]

옵션:
  --school-name "학교명"    학교명 설정 (미입력 시 대화형으로 입력)
  --cli PLATFORM            대상 플랫폼 선택
                            - claude-code : Claude Code 어댑터
                            - gemini-cli  : Gemini CLI 어댑터
                            - codex-cli   : Codex CLI 어댑터
                            - all         : 모든 플랫폼
  --output-dir PATH         출력 기본 경로 (기본값: ./output)
  --help                    이 도움말 출력

예시:
  ./install.sh --school-name "한빛초등학교" --cli claude-code
  ./install.sh --school-name "서울중학교" --cli all
  ./install.sh  # 대화형 모드

CLI 자동 감지:
  --cli를 지정하지 않으면 시스템에 설치된 CLI를 자동으로 감지합니다.
  - claude (Claude Code CLI)
  - gemini (Gemini CLI)
  - codex  (Codex CLI)
EOF
}

# ─── CLI 감지 ─────────────────────────────────────────────────
detect_available_clis() {
    local detected=()

    if command -v claude &>/dev/null; then
        detected+=("claude-code")
    fi

    if command -v gemini &>/dev/null; then
        detected+=("gemini-cli")
    fi

    if command -v codex &>/dev/null; then
        detected+=("codex-cli")
    fi

    echo "${detected[@]}"
}

# ─── 인자 파싱 ────────────────────────────────────────────────
SCHOOL_NAME=""
TARGET_CLI=""
OUTPUT_BASE_DIR="$SCRIPT_DIR/output"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --school-name)
            SCHOOL_NAME="$2"
            shift 2
            ;;
        --cli)
            TARGET_CLI="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_BASE_DIR="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            log_error "알 수 없는 옵션: $1"
            echo "도움말: ./install.sh --help"
            exit 1
            ;;
    esac
done

# ─── 학교명 입력 ──────────────────────────────────────────────
if [ -z "$SCHOOL_NAME" ]; then
    echo ""
    echo "AXYS - AI 학교 운영 지원 시스템 설치"
    echo "====================================="
    echo ""
    read -rp "학교명을 입력하세요: " SCHOOL_NAME
    echo ""

    if [ -z "$SCHOOL_NAME" ]; then
        log_error "학교명이 입력되지 않았습니다."
        exit 1
    fi
fi

# ─── 대상 CLI 결정 ────────────────────────────────────────────
declare -a TARGET_CLIS

if [ -z "$TARGET_CLI" ]; then
    # 자동 감지
    log_info "설치된 CLI를 감지하는 중..."
    detected=$(detect_available_clis)

    if [ -z "$detected" ]; then
        log_warn "감지된 CLI가 없습니다. 모든 플랫폼에 대해 변환합니다."
        TARGET_CLIS=("claude-code" "gemini-cli" "codex-cli")
    else
        IFS=' ' read -ra TARGET_CLIS <<< "$detected"
        log_info "감지된 CLI: ${TARGET_CLIS[*]}"
    fi
elif [ "$TARGET_CLI" = "all" ]; then
    TARGET_CLIS=("claude-code" "gemini-cli" "codex-cli")
else
    TARGET_CLIS=("$TARGET_CLI")
fi

# ─── 설치 시작 ────────────────────────────────────────────────
echo ""
log_info "=================================================="
log_info "AXYS 설치 시작"
log_info "=================================================="
log_info "학교명: ${SCHOOL_NAME}"
log_info "대상 CLI: ${TARGET_CLIS[*]}"
log_info "출력 경로: ${OUTPUT_BASE_DIR}"
log_info "=================================================="
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0
RESULTS=()

for cli in "${TARGET_CLIS[@]}"; do
    ADAPTER_SCRIPT="$SCRIPT_DIR/adapters/${cli}/adapter.sh"
    OUTPUT_DIR="${OUTPUT_BASE_DIR}/${cli}"

    if [ ! -f "$ADAPTER_SCRIPT" ]; then
        log_error "어댑터를 찾을 수 없음: ${ADAPTER_SCRIPT}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        RESULTS+=("  FAIL  ${cli}")
        continue
    fi

    log_info "--------------------------------------------------"
    log_info "${cli} 어댑터 실행 중..."
    log_info "--------------------------------------------------"

    if bash "$ADAPTER_SCRIPT" --school-name "$SCHOOL_NAME" --output-dir "$OUTPUT_DIR"; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        RESULTS+=("  OK    ${cli} -> ${OUTPUT_DIR}")
    else
        log_warn "${cli} 어댑터 실행 중 오류가 발생했습니다. 계속 진행합니다."
        FAIL_COUNT=$((FAIL_COUNT + 1))
        RESULTS+=("  FAIL  ${cli}")
    fi

    echo ""
done

# ─── 최종 결과 요약 ───────────────────────────────────────────
echo ""
log_info "=================================================="
log_info "AXYS 설치 결과 요약"
log_info "=================================================="
log_info "학교명: ${SCHOOL_NAME}"
log_info "성공: ${SUCCESS_COUNT}개 / 실패: ${FAIL_COUNT}개"
echo ""

for r in "${RESULTS[@]}"; do
    echo "  $r"
done

echo ""

if [ "$SUCCESS_COUNT" -gt 0 ]; then
    log_success "설치가 완료되었습니다!"
    echo ""
    log_info "다음 단계:"

    for cli in "${TARGET_CLIS[@]}"; do
        case "$cli" in
            claude-code)
                echo "  [Claude Code]"
                echo "    1. ${OUTPUT_BASE_DIR}/${cli}/.claude/ 를 프로젝트 루트에 복사"
                echo "    2. ${OUTPUT_BASE_DIR}/${cli}/CLAUDE.md 내용을 프로젝트 CLAUDE.md에 추가"
                echo "    3. Claude Code에서 /axys-{시나리오} 커맨드로 실행"
                echo ""
                ;;
            gemini-cli)
                echo "  [Gemini CLI]"
                echo "    1. ${OUTPUT_BASE_DIR}/${cli}/GEMINI.md 를 프로젝트에 복사"
                echo "    2. gemini -p \"@GEMINI.md {요청}\" 으로 실행"
                echo ""
                ;;
            codex-cli)
                echo "  [Codex CLI]"
                echo "    1. ${OUTPUT_BASE_DIR}/${cli}/AGENTS.md 를 프로젝트 루트에 복사"
                echo "    2. Codex CLI 실행 시 자동 참조"
                echo ""
                ;;
        esac
    done
else
    log_error "모든 어댑터 실행이 실패했습니다."
    exit 1
fi

log_info "=================================================="
