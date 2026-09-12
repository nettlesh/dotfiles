# syntax=docker/dockerfile:1

FROM archlinux:base@sha256:b944cc65c5f28665dfd5fdbf5ed2997c88f5bb4a0aefac7ee8a7ef01893e5ed9

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Use Git's suggested placeholder identity
ARG git_email=you@example.com

RUN pacman -Syu --noconfirm curl \
    && curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh \
    && pacman -Scc --noconfirm \
    && groupadd --gid 1000 sebastian \
    && useradd --create-home --gid sebastian --no-log-init --shell /bin/bash --uid 1000 sebastian

COPY --chown=sebastian:sebastian . /home/sebastian/.dotfiles
WORKDIR /home/sebastian/.dotfiles

RUN mise trust --all --quiet \
    && mise bootstrap packages apply --yes \
    && MISE_GLOBAL_CONFIG_FILE=/home/sebastian/.dotfiles/mise/config.toml \
        mise --locked install --system \
    && pacman -Scc --noconfirm \
    && usermod --shell /usr/bin/fish sebastian

ENV HOME="/home/sebastian"

USER sebastian

RUN mise trust --all --quiet \
    && mise --locked bootstrap --yes --skip packages,user

CMD ["fish"]
