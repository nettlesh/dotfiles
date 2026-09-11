<!-- The centered banner uses HTML and precedes the title -->
<!-- rumdl-disable MD033 -->
<!-- rumdl-disable MD041 -->

<p align="center">
  <img src="dotfiles.png" alt="A black hole bending light beside the word dotfiles" width="100%">
</p>

<h1 align="center">dotfiles</h1>

<!-- rumdl-enable MD041 -->

<p align="center">
  <a href="https://github.com/nettlesh/dotfiles/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nettlesh/dotfiles/ci.yml?branch=main&amp;style=for-the-badge&amp;label=build" alt="Build status"></a>
  <a href="https://github.com/nettlesh/dotfiles/releases"><img src="https://img.shields.io/badge/version-unreleased-555555?style=for-the-badge" alt="Version: unreleased"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-555555?style=for-the-badge" alt="License: MIT"></a>
</p>

<p align="center"><b>A black hole for my free time.</b></p>

<!-- rumdl-enable MD033 -->

## Overview

My dotfiles for CachyOS and macOS, managed by [mise](https://mise.jdx.dev).
Most configuration lives under `~/.config`.

These are _my_ dotfiles,
so don't expect everything to work out of the box on your machine.
There's a lot of cool stuff here
(in my opinion), so feel free to clone, fork, and edit to your heart's content.

## Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
  - [Requirements](#requirements)
  - [Machine settings](#machine-settings)
  - [Bootstrap](#bootstrap)
    - [Direct mise setup](#direct-mise-setup)
    - [Using install.sh](#using-installsh)
    - [Restore from history](#restore-from-history)
  - [Partial setup and dry runs](#partial-setup-and-dry-runs)
  - [Verify installation](#verify-installation)
- [Container](#container)
  - [Pull and run from GHCR](#pull-and-run-from-ghcr)
  - [Build and run locally](#build-and-run-locally)
- [Private history](#private-history)
  - [Connect a private repository](#connect-a-private-repository)
  - [After syncing](#after-syncing)
- [Configuration](#configuration)
  - [Git](#git)
  - [Shell and agent integrations](#shell-and-agent-integrations)
  - [Source checks](#source-checks)

## Features

| Category | Source | Config |
| --- | :---: | :---: |
| Terminal | [Ghostty](https://github.com/ghostty-org/ghostty) | [config.ghostty](ghostty/config.ghostty) |
| Shell | [fish](https://github.com/fish-shell/fish-shell) | [config.fish](fish/config.fish) |
| Plugin Manager | [Fisher](https://github.com/jorgebucaran/fisher) | [fish_plugins](fish/fish_plugins) |
| Prompt | [Starship](https://starship.rs) | [starship.toml](starship/starship.toml) |
| Multiplexer | [herdr](https://herdr.dev) | [config.toml](herdr/config.toml) |
| Editor | [Neovim](https://github.com/neovim/neovim) | [nvim](nvim) |
| Tool Manager | [mise](https://github.com/jdx/mise) | [config.toml](mise/config.toml) |
| Version Control | [Git](https://git-scm.com) | [config](git/config) |
| Diff Viewer | [delta](https://github.com/dandavison/delta) | [delta](git/delta) |
| File Viewer | [bat](https://github.com/sharkdp/bat) | [config](bat/config) |
| Search | [ripgrep](https://github.com/BurntSushi/ripgrep) | [ripgreprc](ripgrep/ripgreprc) |
| TL;DR | [tealdeer](https://github.com/tealdeer-rs/tealdeer) | [config.toml](tealdeer/config.toml) |
| SSH | [OpenSSH](https://www.openssh.com) | [config.tmpl](ssh/config.tmpl), [allowed_signers.tmpl](ssh/allowed_signers.tmpl) |
| Secrets | [fnox](https://github.com/jdx/fnox) | [config.toml](fnox/config.toml) |
| Git Hooks | [hk](https://github.com/jdx/hk) | [config.pkl](hk/config.pkl) |
| arch btw | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | [config.jsonc](fastfetch/config.jsonc) |

A few other tools I use:

- [1Password](https://1password.com)
- [eza](https://github.com/eza-community/eza)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

## Installation

Bootstrap installs system packages and mise tools, links the configuration,
fills in Git and SSH templates, sets fish as the login shell,
and starts the local history watcher.
Your machine settings select the desktop apps and account setup.

To try the environment without installing it on your machine,
use the [container](#container) instead.

### Requirements

Git and curl.
The config-based Git hooks require Git 2.54 or newer.
[Install mise](https://mise.jdx.dev/getting-started.html) to use it directly;
`install.sh` installs it if needed.

### Machine settings

Set this machine's environments in `~/.config/mise/miserc.toml`.
Keep `~/.config/mise` as a regular directory
so it can hold your local settings alongside the shared files.

For my work MacBook:

```toml
env = ["desktop", "work"]
```

For my personal CachyOS desktop:

```toml
env = ["desktop", "personal", "cachyos"]
```

Headless machines don't need any of these environments.
`desktop` adds graphical apps, Fastmail, and 1Password.
`personal` and `work` both set up my two 1Password accounts,
but choose different defaults for `FNOX_PROFILE` and `OP_ACCOUNT`.
`cachyos` adds packages from the CachyOS repositories
and removes some bundled packages that this setup replaces.

This file stays on the machine and applies to mise in other projects too.
Use `-E` to
[choose environments for one command](https://mise.jdx.dev/configuration/environments.html)
without changing the saved choice.
The repo's `.miserc.toml` selects the Linux
or macOS configuration automatically.

Shared mise files are linked individually with `symlink-each`.
That leaves `~/.config/mise` as a regular directory,
with room for your own `miserc.toml` and `config.local.toml`.

### Bootstrap

Choose one of the methods below.
If you have shared history to restore,
use [Restore from history](#restore-from-history)
before running a normal bootstrap.
You don't need to sign in to 1Password just to apply the dotfiles;
the `personal` and `work` setup tasks ask you to sign in when needed.

#### Direct mise setup

Clone and bootstrap with mise:

```sh
git_email=you@example.com mise bootstrap \
  --from https://github.com/nettlesh/dotfiles.git \
  --from-dir "$HOME/.dotfiles"
```

[`--from`](https://mise.jdx.dev/bootstrap.html#starting-from-a-repository)
uses the public repo's `mise.toml` and source files.
`--adopt` restores [shared history](#restore-from-history).

For an existing checkout:

```sh
cd ~/.dotfiles
mise trust
git_email=you@example.com mise bootstrap
```

The dotfiles step saves your email in `mise.local.toml`, which Git ignores.
Later runs reuse it.
A dry run doesn't save the email.

#### Using install.sh

Clone the repo and run the installer:

```sh
git clone https://github.com/nettlesh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script prompts for your email unless one is saved.
To supply it directly:

```sh
GIT_EMAIL=you@example.com ./install.sh
```

The script passes `GIT_EMAIL` to mise as `git_email`,
marks the configuration as trusted, and runs `mise bootstrap`.

#### Restore from history

Install Git and mise, then clone the public repo.
Restore your history before running the normal setup
so the watcher doesn't start a separate history first.

```sh
git clone https://github.com/nettlesh/dotfiles.git ~/.dotfiles
cd ~
mise x gh -- gh auth login --hostname github.com --git-protocol https --web
GIT_CONFIG_GLOBAL="$HOME/.gitconfig" mise x gh -- gh auth setup-git --hostname github.com
mise bootstrap --adopt https://github.com/YOUR-USER/dotfiles-history.git --only dotfiles
```

This uses mise's
[history adoption workflow](https://mise.jdx.dev/bootstrap/setup.html#set-up-another-machine)
to restore tracked files to their original paths under your home directory.
Review any reported conflicts before continuing.

Choose the [machine settings](#machine-settings),
then bootstrap from the restored checkout:

```sh
cd ~/.dotfiles
mise trust
git_email=you@example.com mise bootstrap
```

Or use `./install.sh` for the email prompt.
This repo tracks the source of the global mise configuration at
`~/.dotfiles/mise/config.toml`, rather than its link under `~/.config/mise`.
Running setup from the checkout creates that link and installs the tools
and services.

If the machine already has its own history,
inspect it before adopting another. mise doesn't automatically merge unrelated
histories; keep the existing history and follow its recovery guidance.

### Partial setup and dry runs

From `~/.dotfiles`, preview changes or apply only dotfiles:

```sh
mise bootstrap --dry-run
mise bootstrap --only dotfiles
```

On the first run, supply `git_email=you@example.com` as above.
The installer accepts the same options:

```sh
./install.sh --dry-run
./install.sh --only dotfiles
```

The installer's dry run still installs mise if needed
and trusts the configuration before passing `--dry-run` to bootstrap.

If existing files conflict with this setup, mise reports them and stops.
Review those paths before allowing replacements with `--force-dotfiles`.
See the [bootstrap reference](https://mise.jdx.dev/cli/bootstrap.html)
for the available options.

### Verify installation

Check for missing setup:

```sh
mise bootstrap status --missing
mise bootstrap dotfiles status --missing
```

Your saved environments apply to these commands too.

## Container

Run the Arch Linux environment in a container without installing the dotfiles on
your host.
You'll need Docker.

### Pull and run from GHCR

The [release workflow](.github/workflows/release.yml) is configured to publish
versioned images to `ghcr.io/nettlesh/dotfiles`, but publishing is currently
disabled.
Once an image is published, replace `VERSION` with its release version:

```sh
docker pull ghcr.io/nettlesh/dotfiles:VERSION
docker run --rm -it ghcr.io/nettlesh/dotfiles:VERSION
```

See GitHub's
[Container registry guide](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
for registry access and pulling images.

### Build and run locally

From a checkout of this repo:

```sh
docker build -t dotfiles .
docker run --rm -it dotfiles
```

The image uses a placeholder Git email.
To build it with your own:

```sh
docker build --build-arg git_email=you@example.com -t dotfiles .
```

Or override it when starting a container, using either the local or GHCR image:

```sh
docker run --rm -it \
  -e GIT_AUTHOR_EMAIL=you@example.com \
  -e GIT_COMMITTER_EMAIL=you@example.com \
  dotfiles
```

## Private history

The history watcher saves edits to the tracked files under `~/.dotfiles`,
including changes you haven't committed to the public repo.
These saves, called checkpoints, live in a separate Git history.
Full setup starts the watcher after installing the tools it needs.

You can keep that history local or share it through your own private repository.
Normal setup doesn't connect one for you.

### Connect a private repository

After setup, sign in to GitHub and configure its Git credential helper:

```sh
mise x gh -- gh auth login --hostname github.com --git-protocol https --web
GIT_CONFIG_GLOBAL="$HOME/.gitconfig" mise x gh -- gh auth setup-git --hostname github.com
```

Review tracked files and saved versions:

```sh
mise bootstrap dotfiles paths
mise bootstrap dotfiles history show --files
```

Create an empty private repository, then connect it using your own URL:

```sh
mise bootstrap dotfiles origin set https://github.com/YOUR-USER/dotfiles-history.git --sync sync
mise bootstrap dotfiles status
```

Review earlier checkpoints as well as the current files:
all saved versions are shared.
The watcher will push your saves
and apply changes from your other machines automatically.
The repository connection and Git credentials stay local to this machine.
See the [mise history guide](https://mise.jdx.dev/history.html)
for manual syncing and conflict recovery.

### After syncing

Incoming changes can edit files in your public checkout.
Review and commit them to the public repo when you're ready.
History sync doesn't commit or push that repo, install packages,
or regenerate files from templates.
Run `mise bootstrap` from `~/.dotfiles`
when a restored configuration needs those steps,
or `mise bootstrap dotfiles apply` for dotfiles alone.

Your local Git email, account credentials,
and private keys aren't included in this history.
Set those up separately on each machine.

## Configuration

Most shared files are symlinked,
so editing them changes the source in this repo.

### Git

For shared Git settings,
edit `git/config` or use `git config --file ~/.dotfiles/git/config ...`.
`git config --global` can write to the separate `~/.gitconfig`,
where the GitHub credential helper is configured.

Your Git identity is generated at `~/.config/git/identity` from a template
and your local email.
Change those inputs instead of copying the generated file into the repo.
Desktop signing settings live in `~/.config/git/1password`;
keep signing enabled only in that include.

delta's settings and the `cuttlefish` theme live in `git/delta`,
included from `git/config`.
Its colours are ANSI names, so they follow the terminal palette.

### Shell and agent integrations

fish adds the system tool directories to PATH so it can find mise
before activation. mise also sets up PATH
for commands it launches in other shells.

Shared agent skills live in `agents/skills` and are linked into the Claude Code
and Codex skill directories.
The herdr integration scripts and registrations are kept in this repo;
setup doesn't run the herdr integration installer.

### Source checks

For source checks, `mise run check` runs the linters
and `mise run fix` applies their automatic fixes.
CI also builds the Arch container and runs the baseline setup on macOS.
