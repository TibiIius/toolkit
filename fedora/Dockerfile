ARG FEDORA_IMAGE_MAJOR="${FEDORA_IMAGE_MAJOR:-latest}"

FROM registry.fedoraproject.org/fedora-toolbox:${FEDORA_IMAGE_MAJOR}

COPY common /tmp/common
COPY fedora/base_packages /tmp/base_packages

RUN dnf install -y $(</tmp/base_packages) && \
  dnf builddep -y python3

# Symlinks for host access
RUN /tmp/common/symlinks.sh

# Remove tmp files
RUN rm -rf /tmp/*
