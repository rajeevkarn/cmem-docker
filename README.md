# CMEM Docker orchestration

This orchestration bundles CMEM and enables you to evaluate it easily on your own PC.

## Requirements

You need to have the following software set up:

- `git`
- a working docker environment with:
    - `docker 1.11.1` or newer
    - `docker-compose 1.7.1` or newer
    - (if need-be `docker-machine 0.7.0` or newer)

Furthermore you need to setup `docker.local` as an alias for your docker instance. So add `docker.local` to your `/etc/hosts` file:

```bash
#(ip of your docker-machine)    docker.local
# Example if you use docker natively on linux:
127.0.0.1    docker.local

# Example if you use macOS/docker-machine
192.168.99.100    docker.local
```

## Usage instructions

To run CMEM and Stardog with docker on your local machine do:

1. run `git clone https://github.com/eccenca/cmem-docker.git && cd cmem-docker`
1. login to https://artifactory.eccenca.com and download CMEM zip files listed in [cmem/README.md](cmem/README.md) into the `cmem` folder
1. stardog is commercially licensed software. You need to obtain a copy of stardog and a license from complexible and place them into the `stardog` folder. For more details, have a look at [stardog/README.md](stardog/README.md)
1. run `docker-compose build`
1. run `docker volume create --name=stardog-data`
1. run `docker-compose up`
1. open http://docker.local:8080 in your browser
1. login: two sample users are configured `userA` and `userB` (password same as user name), where
    - `userA` can read all graphs
    - `userB` can read/write all graphs


## URIs

- DataManager: http://docker.local:8080
- DataPlatform: http://docker.local:8080/dataplatform
- DataIntegration: http://docker.local:8080/dataintegration


## Project Structure

- `docker-compose.yml` docker container composition of CMEM and stardog image
- `aksworg.trig` some sample data
- `aksworg.ttl` some sample data
- `README.md` this file
- `cmem/` folder that should hold the downloaded CMEM artifacts
- `cmem/Dockerfile` docker file to build the CMEM image
- `etc/` individual run-time configuration for the CMEM components
- `stardog/` folder that should hold the downloaded stardog artifacts
- `stardog/Dockerfile` docker file to build the stardog image
