#!/bin/bash

# Installing AUR manager
git clone https://aur.archlinux.org/yay.git
(
    cd yay || exit 1
    makepkg --noconfirm --noprogressbar -si
    yay --afterclean --removemake --save
)

rm -rf yay

pacman -Scc --noconfirm
sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/*