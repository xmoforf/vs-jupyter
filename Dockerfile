FROM archlinux:base

# Fixing weird keyring fuckery
RUN pacman-key --init
RUN pacman -Sy --noconfirm --noprogressbar archlinux-keyring && pacman -Su --noconfirm --noprogressbar

# Add user, group sudo
RUN pacman -Syu --noconfirm --noprogressbar --needed base-devel git && \
    echo $DOCKER_GID && \
    groupadd --system sudo && \
    useradd -m --groups sudo user && \
    sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    pacman -Scc --noconfirm && rm -rf /tmp/* /var/tmp/*

USER user
WORKDIR /tmp

# Installing AUR manager
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg --noconfirm --noprogressbar -si && \
    yay --afterclean --removemake --save && \
    cd .. && rm -rf yay && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

# Installing vapoursynth and plugins
RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

# Installing packages
RUN sudo pacman -Syu --noconfirm --noprogressbar \
    cmake ninja \
    less \
    nano nvim vim \
    boost-libs \
    python-{pip,distutils-extra,uv} ruff \
    python-ipykernel jupyterlab \
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
    qt6-multimedia \
    docker && \
    sudo pacman -Scc --noconfirm && sudo rm -rf /tmp/* /var/tmp/*

RUN sudo usermod -aG docker user

RUN yay -Syu --noconfirm --noprogressbar --removemake mkbrr && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

RUN git clone https://gitlab.com/passelecasque/propolis.git && \
    cd propolis && \
    make build && sudo install -D propolis /usr/local/bin/propolis && \
    cd .. && sudo rm -rf propolis

RUN git clone https://github.com/casey/intermodal.git && \
    cd intermodal && \
    sudo cargo install --path . && \
    cd .. && sudo rm -rf intermodal


RUN yay -Syu --noconfirm --noprogressbar --removemake \
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
    vapoursynth-plugin-lvsfunc-git \
    vapoursynth-plugin-muvsfunc-git \
    vapoursynth-plugin-mvsfunc-git \
    vapoursynth-plugin-mvtools-git \
    vapoursynth-plugin-nnedi3-git \
    vapoursynth-plugin-sangnom-git \
    vapoursynth-plugin-retinex-git \
    vapoursynth-plugin-vsutil-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

COPY vapoursynth-plugin-adaptivegrain-git.patch .
RUN yay -G vapoursynth-plugin-adaptivegrain-git && \
    cd vapoursynth-plugin-adaptivegrain-git && \
    patch -p1 < ../vapoursynth-plugin-adaptivegrain-git.patch && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf vapoursynth-plugin-adaptivegrain-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-kagefunc-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

COPY vapoursynth-plugin-znedi3-git.patch .
RUN yay -G vapoursynth-plugin-znedi3-git && \
    cd vapoursynth-plugin-znedi3-git && \
    makepkg -so --noconfirm && \
    patch -p0 < ../vapoursynth-plugin-znedi3-git.patch && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf vapoursynth-plugin-znedi3-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

RUN yay -Syu --noconfirm --noprogressbar \
    vapoursynth-plugin-eedi3m-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

COPY vapoursynth-plugin-resize2-git.patch .
RUN yay -G vapoursynth-plugin-resize2-git && \
    cd vapoursynth-plugin-resize2-git && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf vapoursynth-plugin-resize2-git && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

COPY qtgmc.patch .
RUN yay -G qtgmc && \
    cd qtgmc && \
    patch -p1 < ../qtgmc.patch && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf qtgmc && \
    sudo rm -rf /tmp/* /var/tmp/* /home/user/.cache/yay/* && sudo pacman -Scc --noconfirm

# python packages
RUN python -m venv venv && \
    venv/bin/python -m pip install -U wheel setuptools pip ipykernel && \
    venv/bin/python -m ipykernel install --user --name=vapoursynth --display-name="Vapoursynth"

RUN venv/bin/python -m pip install \
    vsengine vsjetpack vspreview vsutil \
    av \
    numpy scipy pandas matplotlib scikit-image \
    requests \
    jinja2 \
    deew \
    guessit \
    seaborn matplotlib plotly bokeh altair ggplot \
    jupyter-repo2docker

WORKDIR /home/user
ENTRYPOINT [ "jupyter", "lab", "--LabApp.token=''", "--allow-root", "--ip=0.0.0.0", "--port=8889"]
