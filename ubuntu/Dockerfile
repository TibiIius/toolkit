ARG IMAGE_RELEASE="${IMAGE_RELEASE:-latest}"

FROM quay.io/toolbx/ubuntu-toolbox:${IMAGE_RELEASE}

COPY common /tmp/common

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get remove --yes ubuntu-pro-client && \
  apt-get upgrade --yes && \
  apt-get install --yes zsh

# Enable deb sources
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list

# Symlinks for host access
RUN /tmp/common/symlinks.sh

# Remove tmp files
RUN rm -rf /tmp/*
