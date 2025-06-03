#!/bin/bash

sudo pacman -Syu --noconfirm --noprogressbar docker
sudo usermod -aG docker user

yay -Syu --noconfirm --noprogressbar --removemake mkbrr

git clone https://gitlab.com/passelecasque/propolis.git
(
    cd propolis || exit 1
    make build
    sudo install -D propolis /usr/local/bin/propolis
)
sudo rm -rf propolis

git clone https://github.com/casey/intermodal.git
(
    cd intermodal || exit 1
    sudo cargo install --path .
)
sudo rm -rf intermodal

pacman -Scc --noconfirm
sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/*