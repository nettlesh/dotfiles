# NOTE: Compatibility shell for AI coding agents
eval "$("$HOME/.local/bin/mise" env --shell zsh)"

# Reassert host tool order after mise restores inherited PATH entries
typeset -U path
if [[ $OSTYPE == darwin* ]]; then
    path=("$HOME/.local/bin" "$HOME/.docker/bin" /opt/homebrew/bin $path)
else
    path=("$HOME/.local/bin" $path)
fi
