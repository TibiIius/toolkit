FROM quay.io/toolbx-images/archlinux-toolbox:latest

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
  git clone https://aur.archlinux.org/yay.git && \
  cd yay && \
  chown -R builduser:builduser . && \ 
  sudo -u builduser bash -c 'makepkg -si --noconfirm' && \
  rm -rf /yay

# Install extra packages
# TODO: Download list from pug gist instead of `packages` file
COPY packages /
RUN sudo -u builduser bash -c 'echo y | LANG=C yay --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" -S $(<packages)' && \
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
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
