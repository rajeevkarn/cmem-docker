# eLDS Docker Composition

## usage instructions

to run eLDS and Virtuoso with docker on your local machine do:

1. login to [artifactory.eccenca.com](https://artifactory.eccenca.com) and download artifact zip files into the `artifacts` folder - see [artifacts/README.md](artifacts/README.md) for details
2. add in your `/etc/hosts` host name alias `docker.local` pointing to the IP address of your docker service (e.g. by adding a line like `92.168.99.100    docker.local`)
3. run `docker-compose up`
4. open [http://docker.local:8080](http://docker.local:8080) in your browser


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
