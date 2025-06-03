FROM archlinux:base AS vs-shell

COPY scripts/base-root.sh .
RUN ./base-root.sh

USER user
WORKDIR /tmp

COPY scripts/base-user.sh .
RUN ./base-user.sh



###############################################################################
# vapoursynth-shell
###############################################################################

COPY patches/vapoursynth-plugin-adaptivegrain-git.patch .
COPY patches/vapoursynth-plugin-znedi3-git.patch .
COPY patches/vapoursynth-plugin-resize2-git.patch .
COPY patches/qtgmc.patch .
COPY scripts/shell-user.sh .
RUN ./shell-user.sh

ENTRYPOINT ["/bin/sh", "-c", "while true; do sleep 3600; done"]



###############################################################################
# vapoursynth-jupyter
###############################################################################

FROM vs-shell AS vs-jupyter

COPY scripts/jupyter-user.sh .
RUN ./jupyter-user.sh

ENTRYPOINT [ "venv/bin/jupyter", "lab", "--LabApp.token=''", "--allow-root", "--ip=0.0.0.0", "--port=8889"]



###############################################################################
# vapoursynth-yuuno
###############################################################################

FROM vs-jupyter AS vs-yuuno

COPY scripts/yuuno-user.sh .
RUN ./yuuno-user.sh

ENTRYPOINT [ "venv/bin/jupyter", "lab", "--LabApp.token=''", "--allow-root", "--ip=0.0.0.0", "--port=8889"]



###############################################################################
# vapoursynth-max
###############################################################################

FROM vs-yuuno AS vs-max

COPY scripts/max-user.sh .
RUN ./max-user.sh

WORKDIR /home/user

ENTRYPOINT [ "venv/bin/jupyter", "lab", "--LabApp.token=''", "--allow-root", "--ip=0.0.0.0", "--port=8889"]
