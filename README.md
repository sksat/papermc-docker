# papermc-docker
[![Build Container Image](https://github.com/sksat/papermc-docker/actions/workflows/build-image.yml/badge.svg)](https://github.com/sksat/papermc-docker/actions/workflows/build-image.yml)
[![image version](https://img.shields.io/docker/v/sksat/papermc-docker?sort=semver)](https://hub.docker.com/r/sksat/papermc-docker)
[![image pulls](https://img.shields.io/docker/pulls/sksat/papermc-docker)](https://hub.docker.com/r/sksat/papermc-docker)

Docker container for [PaperMC](https://papermc.io/)

## Image

|Registry|Image|
|-|-|
|[DockerHub](https://hub.docker.com/r/sksat/papermc-docker)|`sksat/papermc-docker`|
|[GitHub Container Registry](https://github.com/sksat/papermc-docker/pkgs/container/papermc-docker)|`ghcr.io/sksat/papermc-docker`|

|tag|Image Size|
|-|-|
|`1.17.1`|![1.17.1](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1)|
|`1.17.1-R0.1-SNAPSHOT`|![1.17.1-R0.1-SNAPSHOT](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-R0.1-SNAPSHOT)|
|`1.17.1-openjdk`|![1.17.1-openjdk](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-openjdk)|
|`1.17.1-openjdk-17-slim`|![1.17.1-openjdk-17-slim](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-openjdk-17-slim)|
|`1.17.1-openjdk-17-slim-buster`|![1.17.1-openjdk-17-slim-buster](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-openjdk-17-slim-buster)|
|`1.17.1-openjdk-17-oraclelinux8`|![1.17.1-openjdk-17-oraclelinux8](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-openjdk-17-oraclelinux8)|
|`1.17.1-temurin-17.0.1_12-jdk`|![1.17.1-temurin-17.0.1_12-jdk](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-temurin-17.0.1_12-jdk)|
|`1.17.1-temurin-17.0.1_12-jdk-focal`|![1.17.1-temurin-17.0.1_12-jdk-focal](https://img.shields.io/docker/image-size/sksat/papermc-docker/1.17.1-temurin-17.0.1_12-jdk-focal)|


### Tags

tag structure: `<branch>-<Minecraft version>-<JDK>-<base-img>`

Some fields have default value.
If the tag contains a default value, there are other versions of tags that do not include that field.

Example: `main-1.17.1-R0.1-SNAPSHOT-d0a2193-alpine-jre` -> `1.17.1-alpine`

- tag field

|field|detail|default value|example|
|-|-|-|-|
|branch|branch name|`main`|`renovate/openjdk-17-slim`|
|Minecraft version|Minecraft(PaperMC) version|N/A|`1.17.1`,`1.17.1-R0.1-SNAPSHOT`,`1.17.1-R0.1-SNAPSHOT-d0a2193`|
|JDK|OpenJDK or Eclipse temurin|`openjdk`|`temurin`,`openjdk`|
|base-img|Base Image|It depends on JDK. `openjdk`->`17-slim`|


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
