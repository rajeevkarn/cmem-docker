# eccenca Corporate Memory Docker orchestration

This orchestration bundles Corporate Memory and enables you to evaluate it easily on your own PC.

## Table of contents

<!-- MarkdownTOC -->

- [Requirements](#requirements)
- [Usage instructions](#usage-instructions)
    - [Stardog specific instructions](#stardog-specific-instructions)
    - [Virtuoso specific instructions](#virtuoso-specific-instructions)
- [Applications](#applications)
    - [Corporate Memory](#corporate-memory)
    - [Backend](#backend)
- [Project structure](#project-structure)

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

You have the possibility to start this orchestration either with Stardog or with Virtuoso as backend. Please follow the instructions below:

1. Run `git clone https://github.com/eccenca/cmem-docker.git && cd cmem-docker`.

1. Download the eccenca Corporate Memory release artifacts listed in [cmem/README.md](cmem/README.md) into the `cmem` folder.

1. Download the eccenca Corporate Memory inital data artifacts listed in [data/README.md](data/README.md) into the `data` folder.

1. Now you have to choose if you want to run Stardog or Virtuoso as backend:

    1.  If you want to use Stardog, execute the steps described [here](#stardog-specific-instructions).

    1.  If you want to use virtuoso, execute the steps described [here](#virtuoso-specific-instructions).

1. Open [http://docker.local:8080](http://docker.local:8080) in your browser.

1. Login with one of the two configured sample users (password same as user name), where
    - `userA` can read all graphs, and
    - `userB` can read/write all graphs.

### Stardog specific instructions

1. Stardog is commercially licensed software. You need to obtain a copy of Stardog and a license, and place them into the `stardog` folder. For more details, have a look at [stardog/README.md](stardog/README.md).

1. Execute the following steps:

    ```bash
    # Create a docker volume where Stardog will store it's data
    docker volume create --name=stardog-data

    # Build the Corporate Memory and the Stardog image
    docker-compose --file docker-compose.stardog.yml build --no-cache

    # Start Corporate Memory and Stardog
    docker-compose --file docker-compose.stardog.yml up
    ```

1. Continue with the rest of [Usage instructions](#usage-instructions).

### Virtuoso specific instructions

1. Execute the following steps:

    ```bash
    # Create a docker volume where Virtuoso will store it's data
    docker volume create --name=virtuoso-data

    # Build the Corporate Memory image
    docker-compose --file docker-compose.virtuoso.yml build --no-cache

    # Start Corporate Memory and Virtuoso
    docker-compose --file docker-compose.virtuoso.yml up
    ```

1. Continue with the rest of [Usage instructions](#usage-instructions).

## Applications

### Corporate Memory

- DataManager: [http://docker.local:8080](http://docker.local:8080)
- DataPlatform: [http://docker.local:8080/dataplatform](http://docker.local:8080/dataplatform)
- DataIntegration: [http://docker.local:8080/dataintegration](http://docker.local:8080/dataintegration)

### Backend

- Stardog: [http://docker.local:5820](http://docker.local:5820)
    - Administrator credentials: `admin/admin`

or

- Virtuoso: [http://docker.local:8890](http://docker.local:8890)
    - Administrator credentials: `dba/dba`

## Project structure

|              File             |                              Description                               |
| ----------------------------- | ---------------------------------------------------------------------- |
| `docker-compose.stardog.yml`  | Docker container composition of Corporate Memory and Stardog image.    |
| `docker-compose.virtuoso.yml` | Docker container composition of Corporate Memory and Virtuoso image.   |
| `cmem/`                       | Folder that should hold the downloaded Corporate Memory artifacts.     |
| `cmem/Dockerfile`             | Docker file to build the Corporate Memory image.                       |
| `data/`                       | Folder for initial data.                                               |
| `etc/`                        | Individual run-time configuration for the Corporate Memory components. |
| `stardog/`                    | Folder that should hold the downloaded Stardog artifacts.              |
| `stardog/Dockerfile`          | Docker file to build the Stardog image.                                |
