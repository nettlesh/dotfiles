# dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

My dotfiles for CachyOS and macOS,
managed by [mise](https://github.com/jdx/mise) and compliant with the
[XDG Base Directory spec](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).
One command takes a fresh machine to a working environment.

An opinionated bootstrap.

## Features

| Category        |                            Source                            |                                      Config                                       |
| --------------- | :----------------------------------------------------------: | :-------------------------------------------------------------------------------: |
| Terminal        |           [Ghostty](https://github.com/ghostty-org/ghostty)           | [config.ghostty](https://github.com/nettlesh/dotfiles/blob/main/ghostty/config.ghostty) |
| Shell           |            [fish](https://github.com/fish-shell/fish-shell)            | [config.fish](https://github.com/nettlesh/dotfiles/blob/main/fish/config.fish)    |
| Plugin Manager  |          [Fisher](https://github.com/jorgebucaran/fisher)          | [fish_plugins](https://github.com/nettlesh/dotfiles/blob/main/fish/fish_plugins) |
| Prompt          |                   [Starship](https://starship.rs)                   | [starship.toml](https://github.com/nettlesh/dotfiles/blob/main/starship/starship.toml)    |
| Multiplexer     |                   [herdr](https://herdr.dev)                    | [config.toml](https://github.com/nettlesh/dotfiles/blob/main/herdr/config.toml)   |
| Editor          | [Neovim](https://github.com/neovim/neovim)/[MiniMax](https://github.com/nvim-mini/MiniMax) | [nvim](https://github.com/nettlesh/dotfiles/tree/main/nvim) |
| Tool Manager    |                [mise](https://github.com/jdx/mise)                | [mise.toml](https://github.com/nettlesh/dotfiles/blob/main/mise.toml)             |
| Version Control |                   [Git](https://git-scm.com)                    | [config.tmpl](https://github.com/nettlesh/dotfiles/blob/main/git/config.tmpl)     |
| Search          |          [ripgrep](https://github.com/BurntSushi/ripgrep)          | [ripgreprc](https://github.com/nettlesh/dotfiles/blob/main/ripgrep/ripgreprc)     |
| Fuzzy Finder    |                 [fzf](https://github.com/junegunn/fzf)                 | [config.fish](https://github.com/nettlesh/dotfiles/blob/main/fish/config.fish)    |

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
(even system packages via `pacman` on CachyOS and `brew` on macOS).

### Steps

```sh
git clone https://github.com/nettlesh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh -E personal # CachyOS desktop
./install.sh -E work     # Managed macOS desktop
```

Run `./install.sh` without an environment for a restricted host.

On first run you will be prompted for a git email.
To skip the prompt, set it beforehand:

```sh
GIT_EMAIL=you@example.com ./install.sh -E personal
```

Either way it is written to `mise.local.toml`,
which is gitignored and never leaves your machine.

Arguments are forwarded to `mise bootstrap`,
so `./install.sh -E personal --dry-run` previews the run
and `./install.sh -E personal --only dotfiles` restricts it.

If mise is already installed,
it can clone and bootstrap the repository directly:

```sh
GIT_EMAIL=you@example.com mise -E personal bootstrap \
  --from https://github.com/nettlesh/dotfiles.git \
  --from-dir "$HOME/.dotfiles"
```

mise refuses to replace config files it does not manage,
so on a machine that already has a Ghostty or fish
(like CachyOS) the run stops and names them.
Confirm the list is what you expect,
then re-run with `./install.sh -E personal --force-dotfiles`.

## What this does

- Installs mise to `~/.local/bin/mise`
- Marks this repo as trusted, so mise will read its config without prompting
- Installs system packages, then the tools in
  [mise/config.toml](https://github.com/nettlesh/dotfiles/blob/main/mise/config.toml)
- Adds desktop applications and private identity integration when the
  `personal` or `work` environment is selected
- Applies configs under `~/.config`, replacing existing managed configs
  when `--force-dotfiles` is passed
- Sets fish as the login shell

Check the state associated with a machine by selecting the same environment:

```sh
mise -E personal run check
mise -E work run check
mise run check # Restricted baseline
```

## Notes

### Changing git config by hand

`~/.config/git/config` is rendered from a template rather than symlinked,
because the Git identity is injected from machine-local values.
So `git config --global ...` writes to the rendered file
and is overwritten on the next apply.
To keep such a change, capture it back into the repo:

```sh
mise bootstrap dotfiles add ~/.config/git/config
```

Most other configs in this repo are symlinked and stay live-editable.
Profile-specific Git and SSH files are templates because their paths
and principals differ by platform or machine identity.
