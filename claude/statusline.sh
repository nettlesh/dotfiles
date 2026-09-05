#!/bin/sh
# Claude Code status line: https://code.claude.com/docs/en/statusline
# Line 1 delegates to starship's own modules so it tracks starship.toml
# Line 2 shows what /context and /usage would otherwise have to be run for
# Renders vim.mode itself, so settings.json sets hideVimModeIndicator

set -eu

esc=$(printf '\033')
reset="${esc}[0m"
dim="${esc}[2m"

# Green under 50%, yellow under 80%, red at or above
usage_color() {
    if [ "$1" -ge 80 ]; then
        printf '%s[1;31m' "$esc"
    elif [ "$1" -ge 50 ]; then
        printf '%s[1;33m' "$esc"
    else
        printf '%s[1;32m' "$esc"
    fi
}

vim_color() {
    case "$1" in
    INSERT) printf '%s[1;32m' "$esc" ;;
    VISUAL*) printf '%s[1;33m' "$esc" ;;
    *) printf '%s[1;34m' "$esc" ;;
    esac
}

progress_bar() {
    filled=$((($1 + 5) / 10))
    [ "$filled" -le 10 ] || filled=10
    cell=0
    while [ "$cell" -lt 10 ]; do
        if [ "$cell" -lt "$filled" ]; then
            printf '▓'
        else
            printf '░'
        fi
        cell=$((cell + 1))
    done
}

time_until() {
    remaining=$(($1 - $(date +%s)))
    [ "$remaining" -gt 0 ] || return 1
    if [ "$remaining" -ge 86400 ]; then
        printf '%dd%dh' $((remaining / 86400)) $((remaining % 86400 / 3600))
    elif [ "$remaining" -ge 3600 ]; then
        printf '%dh%dm' $((remaining / 3600)) $((remaining % 3600 / 60))
    else
        printf '%dm' $((remaining / 60))
    fi
}

format_limit() {
    [ -n "$2" ] || return 1
    percent=$(printf '%.0f' "$2")
    text="$1 ${percent}%"
    if [ -n "$3" ] && left=$(time_until "$(printf '%.0f' "$3")"); then
        text="$text ($left)"
    fi
    printf '%s%s%s' "$(usage_color "$percent")" "$text" "$reset"
}

input=$(cat)

# rate_limits is absent for non-subscribers and before the first API response,
# and each window is dropped once it resets. The unit separator keeps empty
# fields intact; a tab would collapse runs of them, since IFS whitespace folds
IFS=$(printf '\037') read -r cwd model effort vim_mode context cost \
    five_percent five_at week_percent week_at <<EOF || true
$(
        printf '%s' "$input" | jq -r '[
        .workspace.current_dir // .cwd // "",
        .model.display_name // "",
        .effort.level // "",
        .vim.mode // "",
        .context_window.used_percentage // "",
        .cost.total_cost_usd // "",
        .rate_limits.five_hour.used_percentage // "",
        .rate_limits.five_hour.resets_at // "",
        .rate_limits.seven_day.used_percentage // "",
        .rate_limits.seven_day.resets_at // ""
    ] | map(tostring) | join("\u001f")'
    )
EOF

location=""
if [ -n "$vim_mode" ]; then
    location="$(vim_color "$vim_mode")${vim_mode}${reset} "
fi
if [ -n "$cwd" ] && cd "$cwd" 2>/dev/null; then
    location="${location}$(starship module directory)$(starship module git_branch)$(starship module git_status)"
fi
if [ -n "$model" ]; then
    if [ -n "$effort" ]; then
        model="$model $effort"
    fi
    separator=""
    if [ -n "$location" ]; then
        separator="· "
    fi
    location="${location}${dim}${separator}${model}${reset}"
fi

usage=""
if [ -n "$context" ]; then
    percent=$(printf '%.0f' "$context")
    usage="$(usage_color "$percent")$(progress_bar "$percent")${reset} ${percent}% ctx"
fi

limits=$(format_limit 5h "$five_percent" "$five_at" || true)
week=$(format_limit 7d "$week_percent" "$week_at" || true)
if [ -n "$week" ]; then
    limits="${limits:+$limits ${dim}·${reset} }$week"
fi
if [ -n "$limits" ]; then
    usage="${usage:+$usage ${dim}│${reset} }$limits"
fi
if [ -n "$cost" ]; then
    usage="${usage:+$usage ${dim}│${reset} }${dim}\$$(printf '%.2f' "$cost")${reset}"
fi

[ -n "$location" ] && printf '%s\n' "$location"
[ -n "$usage" ] && printf '%s\n' "$usage"

exit 0
