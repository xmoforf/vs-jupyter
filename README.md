# vs-jupyter

Simple docker containers for using [vapoursynth](https://www.vapoursynth.com/) and modern encoding tools.

This container gives you a collection of preselected vapoursynth plugins as well as a Jupyter Lab environment.

Based on archlinux and uses AUR. Works around some bugs so the plugins will build.

## description

Tools included are:

### vs-shell

If you use this one, you would run the container and then execute a container shell to get in.

- basic build environment
- vapoursynth
- ffmpeg
- mediainfo
- mkvtoolnix
- flac
- opus
- x264 / x265
- python
- matplotlib
- scipy / numpy / pandas
- deew (requires DEE)

### vs-jupyter

The rest of these run Jupyter Lab on port 8889.

- jupyter lab

### vs-yuuno

- yuuno

### vs-max

- imdl
- mkbrr
- propolis

## docker compose

This is an example.

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
      - ./vapoursynth/config:/home/user/.jupyter
    restart: unless-stopped
```

# credit

Derived from work done here: https://github.com/Midtan/vapoursynth-docker
