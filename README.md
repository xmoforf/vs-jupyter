# vs-jupyter

[![docker](https://github.com/xmoforf/vs-jupyter/actions/workflows/docker.yml/badge.svg)](https://github.com/xmoforf/vs-jupyter/actions/workflows/docker.yml)

Simple docker containers for using [vapoursynth](https://www.vapoursynth.com/) and modern encoding tools.

The containers gives you a collection of preselected vapoursynth plugins available at three levels of functionality:

- vs-shell: Just vapoursynth, plugins, and encoding utilities.
- vs-jupyter: Adds a Jupyter Lab instance on port 8889.
- vs-yuuno: Adds the [Yuuno](https://github.com/Irrational-Encoding-Wizardry/yuuno) Jupyter plugin.
- vs-max: Adds additional potentially useful utilities.

Based on archlinux and uses AUR. Works around some bugs so the plugins will build.

Simple shell:

```bash
docker run \
    -v [project_directory]:/home/user/projects \
    --rm -it --entrypoint bash ghcr.io/xmoforf/vs-shell:latest
```

## docker compose example

```yaml
services:
  vs-jupyter:
    container_name: vs-jupyter
    image: ghcr.io/xmoforf/vs-max:latest
    environment:
      - JUPYTER_TOKEN=""
    user: "1000:1000"
    volumes:
      - <YOUR_PROJECT_DIR_HERE>:/home/user/projects
      - <YOUR_SSH_DIR_HERE>:/home/user/.ssh
      - ./vapoursynth/config:/home/user/.jupyter
    restart: unless-stopped
```

## included

### vs-shell

If you use this one, you would run the container and then execute a container shell to get in.

- basic build environment
- vapoursynth
  - adaptivegrain, addgrain, adjust, awarpsharp2, awsmfunc, bilateral, bm3d, cas, combmask, ctmf, d2vsource, dctfilter, deblock, descale, dfttest, dither, edgefixer, edi_rpow2, eedi2, eedi3m, fft3dfilter, fillborders, fmtconv, fvsfunc, havsfunc, kagefunc, knlmeanscl, lsmashsource, lvsfunc, misc, muvsfunc, mvsfunc, mvtools, nnedi3, qtgmc, rekt, remapframes, removegrain, resize2, retinex, sangnom, stgfunc, subtext, tcanny, temporalmedian, vodesfunc, vsengine, vsjetpack, vsmuxtools, vspreview, vsutil, wwxd, yadifmod, znedi3
- encoding tools
  - deew (requires DEE)
  - ffmpeg
  - flac
  - mediainfo
  - mkvtoolnix
  - opus
  - x264 / x265
- python
  - matplotlib
  - numpy / scipy / pandas

### vs-jupyter

The rest of these run Jupyter Lab on port 8889.

- jupyter lab

### vs-yuuno

- yuuno

### vs-max

- imdl
- mkbrr
- propolis

# credit

Derived from work done here: https://github.com/Midtan/vapoursynth-docker
