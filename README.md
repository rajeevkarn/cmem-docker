# eLDS Docker Composition

## usage instructions

to run eLDS and Virtuoso with docker on your local machine do:

1. login to [artifactory.eccenca.com](https://artifactory.eccenca.com) and download artifact zip files into the `artifacts` folder - see [artifacts/README.md](artifacts/README.md) for details
2. run `extract_artifacts.sh`, which unzips the artifacts zip files and renames them properly into the `dist` folder
3. add in your `/etc/hosts` host name alias `docker.local` pointing to the IP address of your docker service
4. run `docker-compose up`
5. open [http://docker.local:8080](http://docker.local:8080) in your browser

## URIs

- DataManager: [http://docker.local:8080](http://docker.local:8080)
- DataPlatform: [http://docker.local:8080/dataplatform](http://docker.local:8080/dataplatform)
- DataIntegration: [http://docker.local:8080/dataintegration](http://docker.local:8080/dataintegration)
