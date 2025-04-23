ARG IMAGE_RELEASE="${IMAGE_RELEASE:-latest}"

FROM quay.io/fedora/fedora-toolbox:${IMAGE_RELEASE}

COPY common /tmp/common
COPY fedora/base_packages /tmp/base_packages

RUN dnf install -y $(</tmp/base_packages)

# Symlinks for host access
RUN /tmp/common/symlinks.sh

# Remove tmp files
RUN rm -rf /tmp/*
