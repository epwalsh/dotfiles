#!/bin/bash

CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'
BAR_WIDTH=20

input=$(cat)

# Extract fields with jq, "// 0" provides fallback for null
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0' | cut -d. -f1)
COST_FMT=$(printf '$%.2f' "$COST")

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then
    BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then
    BAR_COLOR="$YELLOW"
else
    BAR_COLOR="$GREEN"
fi

# Build progress bar: printf creates spaces, tr replaces with blocks
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
if [ "$FILLED" -eq "$BAR_WIDTH" ]; then
    FILLED=$((FILLED-2))
    BAR="$(printf "%${FILLED}s" | tr ' ' '')"
elif [ "$EMPTY" -eq "$BAR_WIDTH" ]; then
    EMPTY=$((EMPTY-2))
    BAR="$(printf "%${EMPTY}s" | tr ' ' '')"
else
    FILLED=$((FILLED-1))
    BAR="$(printf "%${FILLED}s" | tr ' ' '')$(printf "%${EMPTY}s" | tr ' ' '')"
fi

COMPONENTS_LINE1=(
    "${CYAN}[${MODEL}]${RESET}"
    "  ${DIR##*/}"
)

COMPONENTS_LINE2=(
    "${BAR_COLOR}${BAR}${RESET} $PCT%"
    "|   ${YELLOW}${COST_FMT}${RESET}"
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
            "|  ${REMOTE}"
        )
    fi

    COMPONENTS_LINE1+=("|  $BRANCH $GIT_STATUS")
fi

echo -e "${COMPONENTS_LINE1[@]}"
echo -e "${COMPONENTS_LINE2[@]}"
