FROM archlinux:latest

RUN yes | pacman -Syyu && \

  # Prepare user that will build AUR packages
  useradd -u 99 -m -d /opt/builder builder && \
  pacman -S sudo && \
  echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \

  # Prepare paru
  yes | pacman -S --needed base-devel git && \
  sudo -u builder git clone https://aur.archlinux.org/paru.git /opt/builder/paru && \
  yes '' | sudo -u builder sh -c "cd /opt/builder/paru && makepkg -si" && \
  rm -rf /opt/builder/* && \
  sed -i 's/\[options\]/&\nSkipReview\nRemoveMake\nCleanAfter/' /etc/paru.conf
