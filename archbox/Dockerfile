ARG ARCH_RELEASE="${IMAGE_RELEASE:-latest}"

FROM quay.io/toolbx/archlinux-toolbox:${ARCH_RELEASE}

ARG GIST_PAT=${GIST_PAT}

COPY common /tmp/common

# Some stuff like man pages and locales are excluded, but I want them in here >:(
RUN sed -i "s|NoExtract.*||g" /etc/pacman.conf

# Add some pacman config stuff
RUN printf "[options]\nColor\nILoveCandy\nParallelDownloads = 5\n" > /etc/pacman.d/extra-options && \
  printf "# Extra config options\nInclude = /etc/pacman.d/extra-options" >> /etc/pacman.conf

# We need to reinstall glibc or else we don't have all locales we need
RUN pacman -Sy --noconfirm archlinux-keyring && \
  pacman -Sy --noconfirm glibc

# Setup base
RUN pacman -S --needed --noconfirm git base-devel go

# Setup builduser
# We need to add a home dir for makepkg cache
RUN useradd -m builduser && \
  passwd -d builduser && \
  mkdir -p /etc/sudoers.d && \
  printf 'builduser ALL=(ALL) ALL\n' > /etc/sudoers.d/builduser

# Install yay
RUN mkdir yay && \
  cd yay && \
  git clone https://aur.archlinux.org/yay.git . && \
  chown -R builduser:builduser . && \ 
  sudo -u builduser bash -c 'makepkg -si --noconfirm' && \
  rm -rf /yay

# Fix locale
RUN printf "en_US.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\n" >> /etc/locale.gen && \
  locale-gen

# Install extra packages
RUN curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GIST_PAT}"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://gist.github.com/TibiIius/672c9c9c6749bec37903378b717cb8dd/raw/" > /packages && \
  pacman --noconfirm -Sy $(<packages) && \
  rm /packages

# Cleanup package cache
RUN sudo -u builduser bash -c 'yay -Scc --noconfirm'

# Remove builduser again
RUN userdel -r builduser && \
  rm -f /etc/sudoers.d/builduser

# Configure OpenSSH server
RUN printf "Port 2222\nListenAddress localhost\nPermitEmptyPasswords yes\n" >> /etc/ssh/sshd_config && \
  /usr/sbin/ssh-keygen -A

# Add some symlinks to access host system stuff via `distrobox-host-exec`
RUN /tmp/common/symlinks.sh

# Setup Gist IDs for pug
RUN printf "GIST_NAT=672c9c9c6749bec37903378b717cb8dd\nGIST_AUR=c6ba136b6e6308a8254d08dae2b530db\n" > /etc/pug

# Remove tmp files
RUN rm -rf /tmp/*
