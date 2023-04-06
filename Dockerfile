FROM quay.io/toolbx-images/archlinux-toolbox:latest

ARG GIST_PAT=${GIST_PAT}

# Setup base
RUN pacman -Sy --noconfirm archlinux-keyring && \
  pacman -S --needed --noconfirm git base-devel go

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

# Add some pacman config stuff
RUN printf "[options]\nColor\nILoveCandy\nParallelDownloads = 5\n" > /etc/pacman.d/extra-options && \
  printf "# Extra config options\nInclude = /etc/pacman.d/extra-options" >> /etc/pacman.conf

# Add some symlinks to access host system stuff via `distrobox-host-exec`
RUN  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/buildah

# Setup Gist IDs for pug
RUN printf "GIST_ID=672c9c9c6749bec37903378b717cb8dd\nGIST_AUR=c6ba136b6e6308a8254d08dae2b530db\n" > /etc/pug

# Set system language locale
ENV LANG=en_US.UTF-8
