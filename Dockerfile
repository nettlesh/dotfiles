# syntax=docker/dockerfile:1

FROM archlinux:base@sha256:63c7b061c0c001cb7ce4f8d11b63d351c23e7f97121bc5c8bd5d9f431e615d7d

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG MISE_VERSION=2026.9.12

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
