#!/bin/bash

# NOTE: test this script by running:
#
# echo '{"session_id":"00000000-0000-0000-0000-000000000000","transcript_path":"/Users/petew/.claude/projects/-Users-petew-dotfiles/00000000-0000-0000-0000-000000000000.jsonl","cwd":"/Users/petew/dotfiles","model":{"id":"claude-sonnet-4-5-20250929","display_name":"Haiku 4.5"},"workspace":{"current_dir":"/Users/petew/dotfiles","project_dir":"/Users/petew/dotfiles"},"version":"2.0.76","output_style":{"name":"default"},"cost":{"total_cost_usd":0.70837435,"total_duration_ms":47655179,"total_api_duration_ms":198183,"total_lines_added":141,"total_lines_removed":1},"context_window":{"total_input_tokens":8429,"total_output_tokens":9054,"context_window_size":200000,"current_usage":{"input_tokens":8,"output_tokens":127,"cache_creation_input_tokens":31373,"cache_read_input_tokens":0}},"exceeds_200k_tokens":false}' | claude/statusline.sh
#

#########################
### Colors and styles ###
#########################

CYAN='\033[36m'
BG_CYAN='\033[46m'

GREEN='\033[32m'
BG_GREEN='\033[0;42m'

YELLOW='\033[33m'
BG_YELLOW='\033[0;43m'

RED='\033[31m'
BG_RED='\033[0;41m'

BLUE='\033[34m'
BG_BLUE='\033[44m'

LIGHT_BLUE='\033[94m'
BG_LIGHT_BLUE='\033[104m'

MEGENTA='\033[35m'
BG_MEGENTA='\033[45m'

DARK_GREY='\033[0;90m'
BG_DARK_GREY='\033[0;100m'

LIGHT_MEGANTA='\033[0;95m'
BG_LIGHT_MEGANTA='\033[0;105m'

LIGHT_GREY='\033[0;37m'
BG_LIGHT_GREY='\033[0;47m'

BOLD='\033[1m'

RESET='\033[0m'

########################
### Helper functions ###
########################

function fmt_cost {
    printf '$%.2f' "$1"
}

##############
### Inputs ###
##############

input=$(cat)
usage_session=$(npx ccusage@latest session --json)
usage_daily=$(npx ccusage@latest daily --json)
usage_weekly=$(npx ccusage@latest weekly --json)

##################
### Components ###
##################


# Build progress bar: printf creates spaces, tr replaces with blocks
BAR_WIDTH=20
CONTEXT_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Pick bar color based on context usage
if [ "$CONTEXT_PCT" -ge 90 ]; then
    BAR_COLOR="$RED"
    BAR_COLOR_BG="$BG_RED"
elif [ "$CONTEXT_PCT" -ge 70 ]; then
    BAR_COLOR="$YELLOW"
    BAR_COLOR_BG="$BG_YELLOW"
else
    BAR_COLOR="$GREEN"
    BAR_COLOR_BG="$BG_GREEN"
fi

FILLED=$((CONTEXT_PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
if [ "$FILLED" -eq "$BAR_WIDTH" ]; then
    FILLED=$((FILLED-2))
    BAR="${BAR_COLOR}${RESET}${BAR_COLOR_BG}$(printf "%${FILLED}s")${RESET}${BAR_COLOR}${RESET}"
elif [ "$EMPTY" -eq "$BAR_WIDTH" ]; then
    EMPTY=$((EMPTY-2))
    BAR="${DARK_GREY}${RESET}${BG_DARK_GREY}$(printf "%${EMPTY}s")${RESET}${DARK_GREY}${RESET}"
else
    FILLED=$((FILLED-1))
    BAR="${BAR_COLOR}${RESET}${BAR_COLOR_BG}$(printf "%${FILLED}s")${BG_DARK_GREY}$(printf "%${EMPTY}s")${RESET}${DARK_GREY}${RESET}"
fi

SESSION_COST=$(echo "$usage_session" | jq -r '.session[-1].totalCost // 0')
DAILY_COST=$(echo "$usage_daily" | jq -r '.daily[-1].totalCost // 0')
WEEKLY_COST=$(echo "$usage_weekly" | jq -r '.weekly[-1].totalCost // 0')

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')

COMPONENTS_LINE1=(
    "${BOLD}[${MODEL}]${RESET}"
    "${CYAN}  ${DIR##*/}${RESET}"
)

COMPONENTS_LINE2=(
    "Ctx: ${BAR_COLOR}${BAR}${RESET} $CONTEXT_PCT%"
    "| ${YELLOW}  $(fmt_cost "$SESSION_COST") session / $(fmt_cost "$DAILY_COST") daily / $(fmt_cost "$WEEKLY_COST") weekly${RESET}"
)

# Git components.
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    GIT_STATUS=""
    [ "$STAGED" -gt 0 ] && GIT_STATUS="${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}${YELLOW}~${MODIFIED}${RESET}"

    # Convert git SSH URL to HTTPS
    REMOTE=$(git remote get-url origin 2>/dev/null | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')

    if [ -n "$REMOTE" ]; then
        COMPONENTS_LINE1+=(
            "| ${BLUE} ${REMOTE}${RESET}"
        )
    fi

    COMPONENTS_LINE1+=("| ${MEGENTA} $BRANCH $GIT_STATUS${RESET}")
fi

echo -e "${COMPONENTS_LINE1[@]}"
echo -e "${COMPONENTS_LINE2[@]}"
