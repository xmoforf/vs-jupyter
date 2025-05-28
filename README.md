# vs-jupyter

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

Then activate the virtual environment.

```bash
source venv/bin/activate && cd projects
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
      - ./vapoursynth/config:/home/user/.jupyter
    restart: unless-stopped
```

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

# credit

Derived from work done here: https://github.com/Midtan/vapoursynth-docker
