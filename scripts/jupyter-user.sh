#!/bin/bash

(
    cd /home/user || exit 1
    venv/bin/python -m pip install -U wheel setuptools pip
    venv/bin/python -m pip install \
        jupyter jupyterlab jupyter-repo2docker jupyter-server-terminals \
        jupyterlab-lsp jupyterlab-widgets ipykernel
    venv/bin/python -m ipykernel install --user --name=vapoursynth --display-name="Vapoursynth"
)

sudo rm -rf /tmp/*
