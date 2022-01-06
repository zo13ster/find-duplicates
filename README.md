# find-duplicates

[![GitHub](https://img.shields.io/github/license/jfandy1982/find-duplicates?logo=GitHub)](https://github.com/jfandy1982/find-duplicates/blob/main/LICENSE.md)
[![Deployment Pipeline](https://github.com/jfandy1982/find-duplicates/actions/workflows/continuous_deployment.yml/badge.svg?branch=main&event=push)](https://github.com/jfandy1982/find-duplicates/actions/workflows/continuous_deployment.yml)
[![Docker Image Size](https://img.shields.io/docker/image-size/jfandy1982/find-duplicates/latest)](https://hub.docker.com/repository/docker/jfandy1982/find-duplicates)

Search for file duplicates using FDupes tool wrapped in a Docker container

## Quickstart

To search for duplicates in the current path without deleting anything automatically execute:

```bash
# docker run --rm -v "$(pwd):/findup_data01:ro" -v $HOME/findup_result:/findup_result jfandy1982/find-duplicates:latest
```
