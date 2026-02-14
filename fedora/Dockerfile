ARG IMAGE_RELEASE="${IMAGE_RELEASE:-latest}"

FROM quay.io/fedora/fedora-toolbox:${IMAGE_RELEASE}

COPY common /tmp/common

# Symlinks for host access
RUN /tmp/common/symlinks.sh && \
	rm -rf /tmp/*

# hadolint ignore=DL3041
RUN dnf update && \
	dnf install -y clang gcc mold zsh file dnf-plugins-core \
	&& dnf builddep -y python3 \
	&& dnf clean all

