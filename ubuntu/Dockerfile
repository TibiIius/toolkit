ARG UBUNTU_RELEASE="${IMAGE_RELEASE:-latest}"

FROM quay.io/toolbx-images/ubuntu-toolbox:${UBUNTU_RELEASE}

COPY common /tmp/common

RUN DEBIAN_FRONTEND=noninteractive apt update && \
  apt upgrade --yes && \
  apt install --yes zsh neovim

# Symlinks for host access
RUN /tmp/common/symlinks.sh

# Remove tmp files
RUN rm -rf /tmp/*
