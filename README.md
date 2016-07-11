# eLDS Docker Composition

## Requirements / stardog docker image

This composition assumes the docker image `stardog:4.1.1` is available locally.
See [https://github.com/rpietzsch/stardog-docker](https://github.com/rpietzsch/stardog-docker) for instructions and `Dockerfile` to create such image. Only clone and build the docker image using the `stardog-docker` repository. The resulting image will be used (run) in _this_ docker composition.


## usage instructions

to run eLDS and Stardog with docker on your local machine do:

1. run `git clone https://github.com/eccenca/elds-docker.git && cd elds-docker && git checkout stardog`
2. login to [artifactory.eccenca.com](https://artifactory.eccenca.com) and download artifact zip files into the `artifacts` folder - see [artifacts/README.md](artifacts/README.md) for details
3. add in your `/etc/hosts` host name alias `docker.local` pointing to the IP address of your docker service (e.g. by adding a line like `192.168.99.100    docker.local`)
4. run `docker-compose build`
5. run `docker volume create --name=stardog-data`
6. run `docker-compose up`
7. open [http://docker.local:8080](http://docker.local:8080) in your browser
8. login: two sample users are configured `userA` and `userB` (password same as user name), where
    - `userA` can read all graphs
    - `userB` can read/write all graphs


## URIs

- DataManager: [http://docker.local:8080](http://docker.local:8080)
- DataPlatform: [http://docker.local:8080/dataplatform](http://docker.local:8080/dataplatform)
- DataIntegration: [http://docker.local:8080/dataintegration](http://docker.local:8080/dataintegration)


## Project Structure

- `Dockerfile` docker file to build the elds image
- `docker-compose.yml` docker container composition of elds and virtuoso image
- `aksworg.trig` some sample data 
- `aksworg.ttl` some sample data 
- `README.md` this file
- `artifacts/` folder that should hold the downloaded eLDS artifacts
- `etc/` individual run-time configuration for the eLDS components
