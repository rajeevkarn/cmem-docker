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
| `aws/`               | AWS deployment scripts.                                                |

## Deploying on AWS

To deploy CMEM on AWS you are required to provide your Eccenca Docker registry credentials, AWS access/secret key as well as Stardog license key.

First of all, put your stardog license key under conf/stardog/stardog-license-key.bin (the filename should match).

Secondly, export your Eccenca docker registry credentials and AWS keys as environmental variables. For example, you can put them in a set-env.sh script:
```
$ cat set-env.sh

#!/bin/bash

export ECC_DOCKER_USER=username
export ECC_DOCKER_PASS=password
export AWS_ACCESS_KEY=accesskey
export AWS_SECRET_KEY=secretkey
```

Then to export your environment variables you can use `source` command:
```
$ source set-env.sh
```

Or use your own way, check that your terminal session got access to those variables:
```
$ echo $ECC_DOCKER_USER
username
```

Now you are ready to build the AMI image and deploy it on AWS:
```
make aws
```

The `make aws` command will first build AMI using t2.micro AWS instance and then deploy it with t2.large AWS instance. During the deployment you will be asked to check the deployment plan (i.e. security groups, ssh key, aws instance)

When the deployment finished, you will see the message such as:
```
...
aws_instance.cmem (remote-exec): Finished starting orchestration
aws_instance.cmem (remote-exec): Use 'make logs' to see logging output of all containers
Use the following hostname to access your CMEM deployment:
  public_dns = hostname.compute.amazonaws.com
```

Now you can open hostname.compute.amazonaws.com in your browser and access CMEM with userA/userA or userB/userB credentials.

### Additional options

In case you have already built an AMI, and you want to simply redeploy it:
```
make aws-deploy
```

You can as well just build an AMI without deploying it:
```
make aws-build-ami
```

To view the hostname of the deployed instance:
```
make aws-show-hostname
```

To view all the details of the deployed setup (including generated SSH key in case you want to connect to instance using SSH):
```
make aws-details
```

Note: if you want to connect to the AWS instance using SSH, simply copy private key from `make aws-details` command to a new file (e.g. ssh.key), then get the hostname of the instance with `make aws-show-hostname`. You should be able to connect to the instance as follows (substitute hostname.compute.amazonaws.com with the hostname you will get):
```
ssh -i ssh.key ubuntu@hostname.compute.amazonaws.com
```

It is possible to set AWS region, instance type and CMEM AMI version (simple postfix on AMI name) using the following environmental variables (listed with their default values):
```
export CMEM_IMAGE_VERSION=1.0.0
export AWS_REGION=eu-central-1
export AWS_INSTANCE_TYPE=t2.large
```