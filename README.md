# dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

My dotfiles for Linux and macOS,
managed by [mise](https://github.com/jdx/mise) and compliant with the
[XDG Base Directory spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).
One command takes a fresh machine to a working environment.

An opinionated bootstrap.

## Features

| Category       |                         Source                          |                                       Config                                       |
| -------------- | :-----------------------------------------------------: | :--------------------------------------------------------------------------------: |
| Terminal       |    [Alacritty](https://github.com/alacritty/alacritty)   |  [alacritty.toml](https://github.com/nettlesh/dotfiles/blob/main/alacritty/alacritty.toml)  |
| Shell          | [Fish](https://github.com/fish-shell/fish-shell)         |     [config.fish](https://github.com/nettlesh/dotfiles/blob/main/fish/config.fish)          |
| Plugin Manager |    [Fisher](https://github.com/jorgebucaran/fisher)      |    [fish_plugins](https://github.com/nettlesh/dotfiles/blob/main/fish/fish_plugins)         |
| Prompt         |       [Pure](https://github.com/pure-fish/pure)          |    [fish_plugins](https://github.com/nettlesh/dotfiles/blob/main/fish/fish_plugins)         |
| Multiplexer    |            [Herdr](https://herdr.dev)                    |     [config.toml](https://github.com/nettlesh/dotfiles/blob/main/herdr/config.toml)         |
| Editor         | [Neovim](https://github.com/neovim/neovim)/[LazyVim](https://github.com/LazyVim/LazyVim) | [nvim](https://github.com/nettlesh/dotfiles/tree/main/nvim) |
| Tool Manager   |          [mise](https://github.com/jdx/mise)             |        [mise.toml](https://github.com/nettlesh/dotfiles/blob/main/mise.toml)               |
| Version Control|            [Git](https://git-scm.com)                    |           [config](https://github.com/nettlesh/dotfiles/blob/main/git/config)              |
| Search         |   [ripgrep](https://github.com/BurntSushi/ripgrep)       |        [ripgreprc](https://github.com/nettlesh/dotfiles/blob/main/ripgrep/ripgreprc)       |
| Fuzzy Finder   | [Television](https://github.com/alexpasmantier/television) |                                        ---                                        |

and some other stuff worth mentioning:

- [bat](https://github.com/sharkdp/bat)
- [delta](https://github.com/dandavison/delta)
- [eza](https://github.com/eza-community/eza)
- [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [fd](https://github.com/sharkdp/fd)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

## Installation

### Prerequisites

`git` and `curl`.
`install.sh` acquires mise, and mise installs everything else
(even system packages via `pacman` on Arch and `brew` on macOS).

### Steps

```sh
git clone https://github.com/nettlesh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

On first run you will be prompted for a git email and name.
To skip the prompt, set them beforehand:

```sh
GIT_EMAIL=you@example.com GIT_NAME="Your Name" ./install.sh
```

Either way they are written to `mise.local.toml`,
which is gitignored and never leaves your machine.

Arguments are forwarded to `mise bootstrap`,
so `./install.sh --dry-run` previews the run
and `./install.sh --only dotfiles` restricts it.

mise refuses to replace config files it does not manage,
so on a machine that already has an Alacritty or Fish config
(like CachyOS) the run stops and names them.
Confirm the list is what you expect,
then re-run with `./install.sh --force-dotfiles`.

## What this does

- Installs mise to `~/.local/bin/mise`
- Marks this repo as trusted, so mise will read its config without prompting
- Installs system packages, then the tools in
  [mise/config.toml](https://github.com/nettlesh/dotfiles/blob/main/mise/config.toml)
- Symlinks configs into `~/.config`,
  replacing existing Alacritty and Fish configs
  when `--force-dotfiles` is passed
- Sets Fish as the login shell

## Notes

### Changing git config by hand

`~/.config/git/config` is rendered from a template rather than symlinked,
because the git identity is injected from machine-local values.
So `git config --global ...` writes to the rendered file
and is overwritten on the next apply.
To keep such a change, capture it back into the repo:

```sh
mise bootstrap dotfiles add ~/.config/git/config
```

Every other config in this repo is symlinked and stays live-editable.
