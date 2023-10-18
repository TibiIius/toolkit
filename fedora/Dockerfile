ARG FEDORA_IMAGE_MAJOR="${FEDORA_IMAGE_MAJOR:-latest}"

FROM registry.fedoraproject.org/fedora-toolbox:${FEDORA_IMAGE_MAJOR}

COPY common /tmp/common

RUN dnf install -y zsh neovim

# Symlinks for host access
RUN /tmp/common/symlinks.sh

# Remove tmp files
RUN rm -rf /tmp/*
