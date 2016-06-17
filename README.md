# eLDS Docker Composition

## usage instructions

to run eLDS and Virtuoso with docker on your local machine do:

1. run `git clone https://github.com/eccenca/elds-docker.git && cd elds-docker`
2. login to [artifactory.eccenca.com](https://artifactory.eccenca.com) and download artifact zip files into the `artifacts` folder - see [artifacts/README.md](artifacts/README.md) for details
3. add in your `/etc/hosts` host name alias `docker.local` pointing to the IP address of your docker service (e.g. by adding a line like `192.168.99.100    docker.local`)
4. run `docker-compose up`
5. open [http://docker.local:8080](http://docker.local:8080) in your browser
6. login: two sample users are configured `userA` and `userB` (password same as user name), where
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
- `README.md` this file
- `artifacts/` folder that should hold the downloaded eLDS artifacts
- `etc/` individual run-time configuration for the eLDS components
