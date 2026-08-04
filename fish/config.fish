# Man pages through bat
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c

set -gx EDITOR nvim
set -gx VISUAL nvim

# ripgrep has no default config location
set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc

fish_add_path ~/.local/bin

status is-interactive; or exit

set -g fish_greeting
fish_vi_key_bindings

# Settings for the done plugin
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

# Functions

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    if test (count $argv) = 2; and test -d "$argv[1]"
        command cp -r (string trim --right --chars=/ $argv[1]) $argv[2]
    else
        command cp $argv
    end
end

function history
    builtin history --show-time='%F %T ' $argv
end

# Aliases

# Re-read fish's initialization file
alias reload 'source ~/.config/fish/config.fish'

# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias dot 'cd ~/.dotfiles'
alias dotfiles 'cd ~/.dotfiles'

# Listing, replacing ls with eza
alias ls 'eza -al --color=always --group-directories-first --icons=always' # Preferred listing
alias la 'eza -a --color=always --group-directories-first --icons=always' # All files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons=always' # Long format
alias lt 'eza -aT --color=always --group-directories-first --icons=always' # Tree listing
alias l. "eza -al --ignore-glob '[!.]*'" # Dotfiles only
alias tree 'eza --tree'

# Editing
alias n nvim
alias v nvim
alias vi nvim
alias vim nvim

# Searching
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'
alias grep 'grep --color=auto'

# Archives
alias tarnow 'tar -acf'
alias untar 'tar -zxvf'

# Processes by memory
# Functions rather than aliases, because alias appends $argv to the last stage of a pipe
function psmem
    ps auxf | sort -nr -k 4
end

function psmem10
    psmem | head -10
end

# Paste to termbin
alias tb 'nc termbin.com 9999'

# GNU coreutils, absent on macOS
if type -q dir
    alias dir 'dir --color=auto'
    alias vdir 'vdir --color=auto'
end

if type -q hwinfo
    alias hw 'hwinfo --short' # Hardware info
end

if type -q journalctl
    alias jctl 'journalctl -p 3 -xb' # Error messages from the current boot
end

if type -q wget
    alias wget 'wget -c' # Continue partial downloads
end

if type -q pacman
    alias fixpacman 'sudo rm /var/lib/pacman/db.lck'

    # Installed packages by size
    function big
        expac -H M '%m\t%n' | sort -h | nl
    end

    # Remove orphaned packages, which pacman errors on when there are none
    function cleanup
        set -l orphans (pacman -Qtdq)
        if test -n "$orphans"
            sudo pacman -Rns $orphans
        else
            echo "No orphaned packages found"
        end
    end

    # Count -git packages
    function gitpkg
        pacman -Q | grep -i '\-git' | wc -l
    end

    # Recently installed
    function rip
        expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl
    end

    # CachyOS ships its own mirror ranker
    if type -q cachyos-rate-mirrors
        alias mirror 'sudo cachyos-rate-mirrors'
        alias update 'sudo cachyos-rate-mirrors && sudo pacman -Syu'
    else
        alias update 'sudo pacman -Syu'
    end
end

# mise activates first because it puts fnox on PATH
mise activate fish | source

fnox activate fish | source
tv init fish | source
zoxide init fish | source

# Auto start herdr (last because exec replaces this shell and herdr needs mise to have activated)
# Ported from the ArchWiki: https://wiki.archlinux.org/title/Tmux#Start_tmux_on_every_shell_login
# NOTE: Evaluating whether named sessions are preferred over one shared session
if type -q herdr; and { test (uname) != Linux; or set -q DISPLAY }; and not set -q HERDR_ENV
    exec herdr
end
