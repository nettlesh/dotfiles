# NOTE: Compatibility shell for AI coding agents
eval "$("$HOME/.local/bin/mise" env --shell zsh)"

# Agents may inherit a PATH without host tools
if [[ $OSTYPE == darwin* ]]; then
    typeset -U path
    path=("$HOME/.local/bin" "$HOME/.docker/bin" /opt/homebrew/bin $path)
fi
