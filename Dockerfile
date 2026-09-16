# syntax=docker/dockerfile:1

FROM archlinux:base@sha256:204e91950fd364961088a01773eee9012243b7e965fed42b1d82d12416190782

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG MISE_VERSION=2026.9.7
ARG git_email=you@example.com

# NOTE: Disable pacman syscall filtering during package installation for amd64 emulation on Apple Silicon
#       https://github.com/apple/container/issues/1628
RUN sed -i '/^\[options\]$/a DisableSandboxSyscalls' /etc/pacman.conf \
    && pacman -Syu --noconfirm curl \
    && curl --proto '=https' --proto-redir '=https' \
        --fail --show-error --silent --location https://mise.run \
        | MISE_INSTALL_PATH=/usr/local/bin/mise sh \
    && pacman -Scc --noconfirm \
    && groupadd --gid 1000 sebastian \
    && useradd --create-home --gid sebastian --no-log-init --shell /bin/bash --uid 1000 sebastian

COPY --chown=sebastian:sebastian . /home/sebastian/.dotfiles
WORKDIR /home/sebastian/.dotfiles

RUN mise trust --all --quiet \
    && mise bootstrap packages apply --yes \
    && mise bootstrap files apply --yes \
    && usermod --shell /usr/bin/fish sebastian \
    && pacman -Scc --noconfirm \
    && sed -i '/^DisableSandboxSyscalls$/d' /etc/pacman.conf

ENV HOME=/home/sebastian
ENV PATH=/home/sebastian/.local/share/mise/shims:$PATH

USER 1000:1000

RUN mise trust --all --quiet \
    && mise --locked bootstrap --yes --skip packages,user,services,final-hook

CMD ["fish"]
