# eccenca Corporate Memory Docker orchestration

This orchestration bundles Corporate Memory and enables you to evaluate it easily on your own PC.

## Table of contents

<!-- MarkdownTOC -->

- Requirements
- Usage instructions
    - Usage hints
- Applications
    - Corporate Memory
    - Backend
- Project structure

<!-- /MarkdownTOC -->

## Requirements

You should have at least 8GB of RAM available to run Corporate Memory with Docker.

You need to have the following software set up:

- `git`
- `perl`
- a working Docker Machine setup with:
    - `Docker version 17.09.0-ce` or newer
    - `docker-compose version 1.16.1` or newer
    - `docker-machine version 0.12.2` or newer

Furthermore you need to setup `docker.local` as an alias for your Docker instance. Add `docker.local` to your `/etc/hosts` file:

```bash
...

# Example if you use docker natively on linux:
127.0.0.1         docker.local

# Example if you use macOS/docker-machine
192.168.99.100    docker.local
::1               docker.local
```

## Usage instructions

1. Run `git clone https://github.com/eccenca/cmem-docker.git && cd cmem-docker`.

1. Download the eccenca Corporate Memory inital data artifacts zip listed in [data/README.md](data/README.md) into the `data/backups` folder.

1. Login your Docker client to the eccenca Docker registry with your eccenca account:

    ```bash
    $ docker login -u USERNAME https://docker-registry.eccenca.com
    ```

1. Stardog is commercially licensed software. You need to obtain a license, and then place it into the `conf/stardog` folder.

1. Execute the following command in order to pull the Docker images and start the orchestration:

    ```bash
    # starts the orchestration and imports the demo data backup
    $ make clean pull start
    ```

1. Open [http://docker.local:8080](http://docker.local:8080) in your browser.

1. Login with one of the two configured sample users (password same as user name), where
    - `userA` can read all graphs, and
    - `userB` can read/write all graphs.

### Usage hints

- To stop the orchestration use `make down`. This will not delete the data stored in Stardog.

- The `make start` command will create a persistent volume for Stardog and also import data. In order to avoid the deletion of data once imported, use `make up` to just run the orchestration after it was stopped with `make down`.

- Use `make clean` in order to get a completely clean state.

## Applications

### Corporate Memory

- DataManager: [http://docker.local:8080](http://docker.local:8080)
- DataPlatform: [http://docker.local:8080/dataplatform](http://docker.local:8080/dataplatform)
- DataIntegration: [http://docker.local:8080/dataintegration](http://docker.local:8080/dataintegration)

### Backend

- Stardog: [http://docker.local:5820](http://docker.local:5820)
    - Administrator credentials: `admin/admin`


## Project structure

|         File         |                              Description                               |
|----------------------|------------------------------------------------------------------------|
| `docker-compose.yml` | Docker container composition of Corporate Memory and Stardog image.    |
| `data/`              | Folder for initial data.                                               |
| `conf/`              | Individual run-time configuration for the Corporate Memory components. |
