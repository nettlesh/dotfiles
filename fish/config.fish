# Env vars
set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc # ripgrep has no default config location
set -gx TEALDEER_CONFIG_DIR ~/.config/tealdeer

set -gx MANPAGER "sh -c 'col -bx | bat -plman'" # Use bat for man pages
set -gx MANROFFOPT -c

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx EZA_ICONS_AUTO 1
set -gx FZF_CTRL_T_OPTS "--walker-skip .git,node_modules,.venv,__pycache__,.ruff_cache,.pytest_cache,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# PATH
# Locate host tools before mise activation
if test (uname) = Darwin
    fish_add_path --path --move /opt/homebrew/bin
    fish_add_path --path --move ~/.docker/bin
end

fish_add_path --path --move ~/.local/bin

status is-interactive; or exit

set -g fish_greeting # Remove greeting
fish_vi_key_bindings
set -g fish_cursor_default block blink

# Aliases
alias reload 'source ~/.config/fish/config.fish'
alias dotfiles 'cd ~/.dotfiles'

alias ls 'eza --group-directories-first'
alias l 'eza -l --group-directories-first'
alias la 'eza -a --group-directories-first'
alias ll 'eza -al --group-directories-first'
alias tree 'eza -T --group-directories-first'

alias cat='bat --paging=never' # Use bat instead

alias n nvim
alias v nvim
alias vi nvim
alias vim nvim

# CLIs
mise activate fish | source # mise activates first
fnox activate fish | source
if command -q op
    op completion fish | source
end
fzf --fish | source
zoxide init fish | source

# Prompt
function starship_transient_prompt_func
    starship module character
end

starship init fish | source
enable_transience
