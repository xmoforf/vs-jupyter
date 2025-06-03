#!/bin/bash

# Installing vapoursynth and plugins
yay -Syu --noconfirm --noprogressbar vapoursynth-git
sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/*
sudo pacman -Scc --noconfirm

# Installing packages
sudo pacman -Syu --noconfirm --noprogressbar \
    cmake ninja \
    less \
    nano nvim vim \
    boost-libs \
    python-{pip,distutils-extra,uv} ruff \
    ffmpeg \
    flac \
    go \
    mediainfo \
    mkvtoolnix-cli \
    opus opus-tools \
    lame \
    rust \
    sox \
    x264 x265 \
    qt6-multimedia

yay -Syu --noconfirm --noprogressbar --removemake \
    vapoursynth-plugin-addgrain-git \
    vapoursynth-plugin-bm3d-git \
    vapoursynth-plugin-combmask-git \
    vapoursynth-plugin-d2vsource-git \
    vapoursynth-plugin-dctfilter-git \
    vapoursynth-plugin-deblock-git \
    vapoursynth-plugin-descale-jet-git \
    vapoursynth-plugin-dfttest-git \
    vapoursynth-plugin-dither-git \
    vapoursynth-plugin-edgefixer-git \
    vapoursynth-plugin-edi_rpow2-git \
    vapoursynth-plugin-fft3dfilter-git \
    vapoursynth-plugin-fmtconv-git \
    vapoursynth-plugin-fvsfunc-git \
    vapoursynth-plugin-havsfunc-git \
    vapoursynth-plugin-knlmeanscl-git \
    vapoursynth-plugin-lsmashsource-git \
    vapoursynth-plugin-lvsfunc-git \
    vapoursynth-plugin-muvsfunc-git \
    vapoursynth-plugin-mvsfunc-git \
    vapoursynth-plugin-mvtools-git \
    vapoursynth-plugin-nnedi3-git \
    vapoursynth-plugin-sangnom-git \
    vapoursynth-plugin-retinex-git \
    vapoursynth-plugin-vsutil-git

yay -G vapoursynth-plugin-adaptivegrain-git
(
    cd vapoursynth-plugin-adaptivegrain-git || exit 1
    patch -p1 < ../vapoursynth-plugin-adaptivegrain-git.patch
    makepkg -si --noconfirm
)
rm -rf vapoursynth-plugin-adaptivegrain-git

yay -Syu --noconfirm --noprogressbar vapoursynth-plugin-kagefunc-git

yay -G vapoursynth-plugin-znedi3-git
(
    cd vapoursynth-plugin-znedi3-git || exit 1
    makepkg -so --noconfirm
    patch -p0 < ../vapoursynth-plugin-znedi3-git.patch
    makepkg -si --noconfirm
)
rm -rf vapoursynth-plugin-znedi3-git

yay -Syu --noconfirm --noprogressbar vapoursynth-plugin-eedi3m-git

yay -G vapoursynth-plugin-resize2-git
(
    cd vapoursynth-plugin-resize2-git || exit 1
    makepkg -si --noconfirm
)
rm -rf vapoursynth-plugin-resize2-git

yay -G qtgmc
(
    cd qtgmc || exit 1
    patch -p1 < ../qtgmc.patch
    makepkg -si --noconfirm
)
rm -rf qtgmc

sudo pacman -Syu --noconfirm --noprogressbar python-hatchling 
yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-awsmfunc-git \
    vapoursynth-plugin-rekt-git \
    vapoursynth-plugin-vsmuxtools \
    vapoursynth-plugin-vodesfunc-git
    
(
    cd /home/user || exit 1
    python -m venv venv
    venv/bin/python -m pip install \
        git+https://github.com/vapoursynth/vapoursynth.git \
        vsengine vsjetpack vspreview vsutil \
        git+https://github.com/xmoforf/vscompare.git \
        av \
        numpy scipy pandas matplotlib scikit-image \
        requests \
        jinja2 \
        deew \
        guessit \
        seaborn matplotlib plotly bokeh altair ggplot
)

pacman -Scc --noconfirm
sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/*