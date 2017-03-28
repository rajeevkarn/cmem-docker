# How to download the required artifacts

In order to use eccenca Corporate Memory (CMEM) with stardog you have to provide the following software artifacts:

-   `stardog-4.2.3.zip`

    *Note:* At the moment stardog 4.2.3 is required. If you do not have this specific version available, please try to retrieve one by contacting complexible.

-   `stardog-license-key.bin` (community or enterprise license)

Both are obtainable from complexible [http://stardog.com/#download](http://stardog.com/#download)

All three artifacts can be downloaded from the [eccenca Artifactory Repository](https://artifactory.eccenca.com):

- [https://artifactory.eccenca.com/elds-release/eccenca-DataManager/eccenca-DataManager-v3.5.3.zip](https://artifactory.eccenca.com/elds-release/eccenca-DataManager/eccenca-DataManager-v3.5.3.zip)
- [https://artifactory.eccenca.com/elds-release/eccenca-DataIntegration/eccenca-DataIntegration-v3.3.2.zip](https://artifactory.eccenca.com/elds-release/eccenca-DataIntegration/eccenca-DataIntegration-v3.3.2.zip)
- [https://artifactory.eccenca.com/elds-release/eccenca-DataPlatform/eccenca-DataPlatform-v7.0.3.zip](https://artifactory.eccenca.com/elds-release/eccenca-DataPlatform/eccenca-DataPlatform-v7.0.3.zip)

Download the `.zip` files and put them into this directory (`artifacts`).


## Build

- download stardog release .zip `stardog-4.2.3.zip` and `stardog-license-key.bin` license file (community or enterprise) from [http://stardog.com/#download](http://stardog.com/#download) and save both in this folder.
- `docker build -t stardog:4.1.2 .`


## Run

```shell
docker run -d --name stardog -p 5820:5820 stardog:4.1.2
```

**HINT:** A default database named `stardog` will be created.

## Data

By default `STARDOG_HOME` is set to `/data`, this is where your runtime data / database data goes.

### Use a data volume
To create a volume container run:

```shell
docker volume create --name stardog-data
```

To run the stardog image using this volume do:

```shell
docker run -d --name stardog -p 5820:5820 -v stardog-data:/data stardog:4.1.2
```

## Access

open [http://< your-docker-host-ip >:5820](http://<your-docker-host-ip>:5820) in your browser for the stardog admin web interface.
e.g.: [http://localhost:5820](http://localhost:5820) or [http://docker.local:5820](http://docker.local:5820)


## Default admin credentials

The default administrator credentials (as stated by the [Stardog documentation](http://docs.stardog.com/#_insecurity)) are the following:

- username: `admin`
- password: `admin`

For more information on security enforcement in Stardog, check the [official documentation](http://docs.stardog.com/#_security).
