# Шаблон для проектов с DevPod

Этот репозиторий является отправной точкой для проектов при работе с которыми я использую [DevPod](https://devpod.sh/)

```bash
devpod up git@github.com:ExampleUser/template-devpod.git --id template-devpod-[...] --provider [...]
```

## [Docker in docker](https://github.com/devcontainers/features/tree/main/src/docker-in-docker)

```
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
```

## [Docker outside of docker](https://github.com/devcontainers/features/tree/main/src/docker-outside-of-docker)

```
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ],
  "features": {
    "ghcr.io/devcontainers/features/docker-outside-of-docker:1": {}
  },
  "runArgs": [
    "--privileged",
    "--pid=host",
    "--network=host"
  ],
```
