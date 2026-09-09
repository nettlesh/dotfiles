#!/bin/sh
set -eu

cd "$(dirname "$0")"

command -v mise >/dev/null 2>&1 || curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

if [ -z "${GIT_EMAIL:-}" ] && [ -f mise.local.toml ]; then
    if saved_email=$(mise config get --file mise.local.toml vars.git_email); then
        GIT_EMAIL=$saved_email
    fi
fi

if [ -z "${GIT_EMAIL:-}" ]; then
    printf 'Git email: '
    IFS= read -r GIT_EMAIL
fi

if [ -z "$GIT_EMAIL" ]; then
    printf 'Git email is required\n' >&2
    exit 1
fi

export GIT_EMAIL
export git_email="$GIT_EMAIL"

mise trust --all --quiet

if [ "${1:-}" = "-E" ] && [ -n "${2:-}" ]; then
    profile=$2
    shift 2
    mise -E "$profile" bootstrap "$@"
else
    mise bootstrap "$@"
fi
