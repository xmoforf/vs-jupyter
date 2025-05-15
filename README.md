# vs-jupyter
Simple docker containers for using [vapoursynth](https://www.vapoursynth.com/) and modern encoding tools.

This container gives you a collection of preselected vapoursynth plugins as well as a Jupyter Lab environment.

Based on archlinux and uses AUR. Works around some bugs so the plugins will build.

## description

Tools included are:
- basic build environment
- ffmpeg
- mediainfo
- mkvtoolnix
- flac
- opus
- x264 / x265
- python / jupyter
- matplotlib
- scipy / numpy / pandas
- deew (requires DEE)

### docker compose

```yaml
services:
  vs-jupyter:
    container_name: vs-jupyter
    build:
      context: ./vapoursynth/vapoursynth-jupyter
      dockerfile: ./Dockerfile
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
