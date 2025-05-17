FROM archlinux:base

# Fixing weird keyring fuckery
RUN pacman-key --init
RUN pacman -Sy --noconfirm --noprogressbar archlinux-keyring && pacman -Su --noconfirm --noprogressbar

# Add user, group sudo
RUN pacman -Syu --noconfirm --noprogressbar base-devel && \
    groupadd --system sudo && useradd -m --groups sudo user && \
    sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Installing AUR manager
RUN sudo pacman -Syu --noconfirm --noprogressbar git
USER user
WORKDIR /tmp
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg --noconfirm --noprogressbar -si && \
    yay --afterclean --removemake --save

# Installing vapoursynth
RUN yay -Syu --noconfirm --noprogressbar --removemake vapoursynth-git

# Installing plugins
RUN sudo pacman -Syu --noconfirm --noprogressbar \
    base-devel cmake git ninja \
    less \
    nano nvim vim \
    boost-libs \
    python-{pip,distutils-extra,uv} ruff \
    ffmpeg \
    flac \
    mediainfo \
    mkvtoolnix-cli \
    opus opus-tools \
    x264 x265 \
    qt6-multimedia

RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-addgrain-git \
    vapoursynth-plugin-bm3d-git \
    vapoursynth-plugin-combmask-git \
    vapoursynth-plugin-d2vsource-git \
    vapoursynth-plugin-dctfilter-git \
    vapoursynth-plugin-deblock-git \
    vapoursynth-plugin-descale-git \
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
    vapoursynth-plugin-muvsfunc-git \
    vapoursynth-plugin-mvsfunc-git \
    vapoursynth-plugin-mvtools-git \
    vapoursynth-plugin-nnedi3-git \
    vapoursynth-plugin-sangnom-git \
    vapoursynth-plugin-retinex-git \
    vapoursynth-plugin-vsutil-git
RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-lvsfunc-git

COPY vapoursynth-plugin-adaptivegrain-git.patch .
RUN yay -G vapoursynth-plugin-adaptivegrain-git && \
    cd vapoursynth-plugin-adaptivegrain-git && \
    patch -p1 < ../vapoursynth-plugin-adaptivegrain-git.patch && \
    makepkg -si --noconfirm && \
    cd ..

RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-kagefunc-git 

COPY vapoursynth-plugin-znedi3-git.patch .
RUN yay -G vapoursynth-plugin-znedi3-git && \
    cd vapoursynth-plugin-znedi3-git && \
    makepkg -so --noconfirm && \
    patch -p0 < ../vapoursynth-plugin-znedi3-git.patch && \
    makepkg -si --noconfirm && \
    cd ..

RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-eedi3m-git 

COPY vapoursynth-plugin-resize2-git.patch .
RUN yay -G vapoursynth-plugin-resize2-git && \
    cd vapoursynth-plugin-resize2-git && \
    makepkg -so --noconfirm && \
    patch -p0 < ../vapoursynth-plugin-resize2-git.patch && \
    makepkg -si --noconfirm && \
    cd ..

COPY qtgmc.patch .
RUN yay -G qtgmc && \
    cd qtgmc && \
    patch -p1 < ../qtgmc.patch && \
    makepkg -si --noconfirm && \
    cd ..

RUN sudo pacman -S --noconfirm --noprogressbar python-ipykernel jupyterlab
#RUN sudo pip3 install yuuno --pre

RUN python -m venv venv && \
    venv/bin/python -m pip install -U wheel setuptools pip && \
    venv/bin/python -m pip install ipykernel && \
    venv/bin/python -m ipykernel install --user --name=vapoursynth --display-name="Vapoursynth"

RUN venv/bin/python -m pip install \
    vsengine vsjetpack vspreview vsutil

RUN venv/bin/python -m pip install \
    av \
    numpy scipy pandas matplotlib scikit-image \
    requests \
    jinja2 \
    deew \
    guessit


USER user
WORKDIR /home/user
ENTRYPOINT [ "jupyter", "lab", "--LabApp.token=''", "--allow-root", "--ip=0.0.0.0", "--port=8889"]
