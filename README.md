# papermc-docker
[![Build Container Image](https://github.com/sksat/papermc-docker/actions/workflows/build-image.yml/badge.svg)](https://github.com/sksat/papermc-docker/actions/workflows/build-image.yml)
[![image version](https://img.shields.io/docker/v/sksat/papermc-docker?sort=semver)](https://hub.docker.com/r/sksat/papermc-docker)
[![image size](https://img.shields.io/docker/image-size/sksat/papermc-docker/main)](https://hub.docker.com/r/sksat/papermc-docker)
[![image pulls](https://img.shields.io/docker/pulls/sksat/papermc-docker)](https://hub.docker.com/r/sksat/papermc-docker)
[![auto update](https://github.com/sksat/papermc-docker/actions/workflows/auto-update.yml/badge.svg)](https://github.com/sksat/papermc-docker/actions/workflows/auto-update.yml)

Docker container for PaperMC

- [GitHub Container Registry](https://github.com/sksat/papermc-docker/pkgs/container/papermc-docker)
- [DockerHub](https://hub.docker.com/r/sksat/papermc-docker)

## Deploy

```sh
$ git clone https://github.com/sksat/papermc-docker
$ cd papermc-docker
$ mkdir data
$ echo "eula=true" > data/eula.txt
$ docker-compose up -d
```

## Disclaimer

This project use [paperclip system](https://paper.readthedocs.io/en/latest/about/structure.html#id2).
So this container image does not contain vanilla Minecraft jar file.
The vanilla Minecraft jar file will be downloaded and patched at the first time the container is started.
