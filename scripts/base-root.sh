#!/bin/bash

# Initialize keyring
pacman-key --init
pacman -Sy --noconfirm --noprogressbar archlinux-keyring
pacman -Su --noconfirm --noprogressbar

# Add user, group sudo
pacman -Syu --noconfirm --noprogressbar --needed base-devel git openssh
echo "$DOCKER_GID"
groupadd --system sudo
useradd -m --groups sudo user
sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
echo 'source venv/bin/activate && cd projects' >> /home/user/.bashrc
systemctl enable sshd

pacman -Scc --noconfirm
sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/*