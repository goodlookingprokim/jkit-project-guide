#!/usr/bin/env bash
# AXYS 어댑터 공용 유틸리티 함수
# 모든 어댑터 스크립트에서 source하여 사용합니다.

# ─── 컬러 코드 ───────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ─── 로깅 함수 ───────────────────────────────────────────────

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

# ─── 디렉토리 유틸리티 ───────────────────────────────────────

# ensure_dir: 디렉토리가 없으면 생성
# 사용법: ensure_dir "/path/to/dir"
ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log_info "디렉토리 생성: $dir"
    fi
}

# ─── YAML Frontmatter 파싱 ───────────────────────────────────

# parse_yaml_frontmatter: 마크다운 파일에서 YAML frontmatter 추출
# --- 사이의 내용을 stdout으로 출력
# 사용법: parse_yaml_frontmatter "file.md"
parse_yaml_frontmatter() {
    local file="$1"
    if [ ! -f "$file" ]; then
        log_error "파일을 찾을 수 없음: $file"
        return 1
    fi
    # 첫 번째 --- 와 두 번째 --- 사이의 내용 추출
    sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$file"
}

# get_yaml_field: YAML에서 특정 필드의 값을 추출
# 단일 값과 배열 값 모두 지원
# 사용법: get_yaml_field "file.md" "id"          -> "principal"
#          get_yaml_field "file.md" "supervises"  -> "vice-principal"  (배열의 각 요소를 줄 단위로)
get_yaml_field() {
    local file="$1"
    local field="$2"
    local yaml
    yaml=$(parse_yaml_frontmatter "$file")

    # 해당 필드 라인 추출
    local line
    line=$(echo "$yaml" | grep "^${field}:" | head -1)

    if [ -z "$line" ]; then
        return 1
    fi

    local value
    value=$(echo "$line" | sed "s/^${field}:[[:space:]]*//" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

    # 배열 형식 [a, b, c] 처리
    if echo "$value" | grep -q '^\['; then
        # 대괄호 제거, 쉼표로 분리
        echo "$value" | sed 's/^\[//; s/\]$//' | tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
        return 0
    fi

    # null 값 처리
    if [ "$value" = "null" ] || [ "$value" = "~" ]; then
        return 1
    fi

    echo "$value"
}

# get_body_content: 마크다운 파일에서 frontmatter 이후의 본문만 추출
# 사용법: get_body_content "file.md"
get_body_content() {
    local file="$1"
    if [ ! -f "$file" ]; then
        log_error "파일을 찾을 수 없음: $file"
        return 1
    fi
    # 두 번째 --- 이후의 내용 추출
    awk 'BEGIN{c=0} /^---$/{c++; next} c>=2{print}' "$file"
}

# ─── 치환 함수 ────────────────────────────────────────────────

# replace_school_name: 파일 내 {{SCHOOL_NAME}}을 실제 학교명으로 치환
# 사용법: replace_school_name "input.md" "한빛초등학교"
# stdout으로 치환된 내용 출력
replace_school_name() {
    local file_or_text="$1"
    local school_name="$2"

    if [ -f "$file_or_text" ]; then
        sed "s/{{SCHOOL_NAME}}/${school_name}/g" "$file_or_text"
    else
        echo "$file_or_text" | sed "s/{{SCHOOL_NAME}}/${school_name}/g"
    fi
}

# replace_school_name_in_string: 문자열에서 {{SCHOOL_NAME}} 치환
# 사용법: result=$(replace_school_name_in_string "$text" "한빛초등학교")
replace_school_name_in_string() {
    local text="$1"
    local school_name="$2"
    echo "$text" | sed "s/{{SCHOOL_NAME}}/${school_name}/g"
}

# ─── 변환 규칙 헬퍼 ──────────────────────────────────────────

# map_decision_authority_to_model: decision_authority -> Claude Code model
map_decision_authority_to_model() {
    local authority="$1"
    case "$authority" in
        final)     echo "opus" ;;
        recommend) echo "sonnet" ;;
        execute)   echo "sonnet" ;;
        advise)    echo "haiku" ;;
        *)         echo "sonnet" ;;
    esac
}

# map_decision_authority_to_permission: decision_authority -> permissionMode
map_decision_authority_to_permission() {
    local authority="$1"
    case "$authority" in
        final) echo "bypassPermissions" ;;
        *)     echo "acceptEdits" ;;
    esac
}

# map_memory_scope: memory_scope -> Claude Code memory 필드
# permanent -> "memory: project", session -> (생략)
map_memory_scope() {
    local scope="$1"
    case "$scope" in
        permanent) echo "memory: project" ;;
        *)         echo "" ;;
    esac
}

# map_tools_needed: tools_needed 배열 + supervises 배열 -> Claude Code tools 목록
# 사용법: map_tools_needed "delegate,read,write" "vice-principal,academic-head"
map_tools_needed() {
    local tools_csv="$1"
    local supervises_csv="$2"
    local result=""

    # 쉼표 또는 개행으로 분리된 도구를 처리
    local tools
    tools=$(echo "$tools_csv" | tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

    while IFS= read -r tool; do
        [ -z "$tool" ] && continue
        case "$tool" in
            delegate)
                # supervises 목록의 각 에이전트에 대해 Task 도구 추가
                local sups
                sups=$(echo "$supervises_csv" | tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
                while IFS= read -r sup; do
                    [ -z "$sup" ] && continue
                    result="${result}  - Task(axys-${sup})\n"
                done <<< "$sups"
                ;;
            read)
                result="${result}  - Read\n  - Glob\n  - Grep\n"
                ;;
            write)
                result="${result}  - Write\n  - Edit\n"
                ;;
            search)
                result="${result}  - Grep\n  - Glob\n"
                ;;
            analyze)
                result="${result}  - Read\n  - Grep\n  - Glob\n"
                ;;
        esac
    done <<< "$tools"

    # 중복 제거 (순서 유지)
    echo -e "$result" | awk '!seen[$0]++' | sed '/^$/d'
}
