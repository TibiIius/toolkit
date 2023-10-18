ARG FEDORA_IMAGE_MAJOR="${FEDORA_IMAGE_MAJOR:-latest}"

FROM registry.fedoraproject.org/fedora-toolbox:${FEDORA_IMAGE_MAJOR}

COPY common /tmp/common

RUN dnf install -y zsh neovim

# Fix locale
#RUN printf "en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\n" >> /etc/locale.gen && \
#  locale-gen

# Symlinks for host access
RUN /tmp/common/symlinks.sh

# Remove tmp files
RUN rm -rf /tmp/*
