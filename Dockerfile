# syntax=docker/dockerfile:1@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32

FROM archlinux:base@sha256:82b1b08faae9d61e3e7e13d562f4d09114d939105b0d59ff34140f3bd418593a

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
