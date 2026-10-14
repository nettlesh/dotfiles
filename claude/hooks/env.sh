#!/bin/bash
# Persists the agent environment for Bash tool commands:
# https://code.claude.com/docs/en/hooks#persist-environment-variables
[ -n "$CLAUDE_ENV_FILE" ] || exit 0

before=$(export -p | sort)
# shellcheck source=/dev/null
. "$HOME/.bashrc"
comm -13 <(echo "$before") <(export -p | sort) >>"$CLAUDE_ENV_FILE"
