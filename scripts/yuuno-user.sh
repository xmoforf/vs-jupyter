#!/bin/bash

sudo pacman -Syu --noconfirm --noprogressbar npm yarn
sudo npm install -g lerna@6

(
    cd /home/user || exit 1
    source venv/bin/activate
    python -m pip install git+https://github.com/xmoforf/yuuno.git
)

pacman -Scc --noconfirm
sudo rm -rf /tmp/* /var/tmp/*