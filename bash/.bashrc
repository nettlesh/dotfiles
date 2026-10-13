# NOTE: Compatibility shell for AI coding agents
eval "$("$HOME/.local/bin/mise" env --shell bash)"

# Agents may inherit a PATH without host tools
if [[ $OSTYPE == darwin* ]]; then
  PATH="$HOME/.local/bin:$HOME/.docker/bin:/opt/homebrew/bin:$PATH"
fi
