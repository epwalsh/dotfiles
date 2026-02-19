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

bar_width=20
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Pick bar color based on context usage
if [ "$context_pct" -ge 90 ]; then
    bar_color="$RED"
    bar_color_bg="$BG_RED"
elif [ "$context_pct" -ge 70 ]; then
    bar_color="$YELLOW"
    bar_color_bg="$BG_YELLOW"
else
    bar_color="$GREEN"
    bar_color_bg="$BG_GREEN"
fi

filled=$((context_pct * bar_width / 100))
empty=$((bar_width - filled))
bar=""
if [ "$filled" -eq "$bar_width" ]; then
    filled=$((filled-2))
    bar="${bar_color}${RESET}${bar_color_bg}$(printf "%${filled}s")${RESET}${bar_color}${RESET}"
elif [ "$empty" -eq "$bar_width" ]; then
    empty=$((empty-2))
    bar="${DARK_GREY}${RESET}${BG_DARK_GREY}$(printf "%${empty}s")${RESET}${DARK_GREY}${RESET}"
else
    filled=$((filled-1))
    bar="${bar_color}${RESET}${bar_color_bg}$(printf "%${filled}s")${BG_DARK_GREY}$(printf "%${empty}s")${RESET}${DARK_GREY}${RESET}"
fi

session_cost=$(echo "$usage_session" | jq -r '.session[-1].totalCost // 0')
daily_cost=$(echo "$usage_daily" | jq -r '.daily[-1].totalCost // 0')
weekly_cost=$(echo "$usage_weekly" | jq -r '.weekly[-1].totalCost // 0')

model=$(echo "$input" | jq -r '.model.display_name')
dir=$(echo "$input" | jq -r '.workspace.current_dir')

components_line1=(
    "${BOLD}[${model}]${RESET}"
    "${CYAN}  ${dir##*/}${RESET}"
)

components_line2=(
    "Ctx: ${bar_color}${bar}${RESET} $context_pct%"
    "| ${YELLOW}  $(fmt_cost "$session_cost") session / $(fmt_cost "$daily_cost") daily / $(fmt_cost "$weekly_cost") weekly${RESET}"
)

# Git components.
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    git_status=""
    [ "$staged" -gt 0 ] && git_status="${GREEN}+${staged}${RESET}"
    [ "$modified" -gt 0 ] && git_status="${git_status}${YELLOW}~${modified}${RESET}"

    # Convert git SSH URL to HTTPS
    remote=$(git remote get-url origin 2>/dev/null | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')

    if [ -n "$remote" ]; then
        components_line1+=(
            "| ${BLUE} ${remote}${RESET}"
        )
    fi

    components_line1+=("| ${MEGENTA} $branch $git_status${RESET}")
fi

echo -e "${components_line1[@]}"
echo -e "${components_line2[@]}"
