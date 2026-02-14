ARG IMAGE_RELEASE="${IMAGE_RELEASE:-latest}"

FROM quay.io/toolbx/ubuntu-toolbox:${IMAGE_RELEASE}

COPY common /tmp/common

# Symlinks for host access
RUN /tmp/common/symlinks.sh && \
	rm -rf /tmp/*

# Enable deb sources
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list

# hadolint ignore=DL3008
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get remove --yes ubuntu-pro-client && \
	apt-get upgrade --yes && \
	apt-get install --no-install-recommends --yes zsh clang gcc mold file && \
	rm -rf /var/lib/apt/lists && apt-get clean

