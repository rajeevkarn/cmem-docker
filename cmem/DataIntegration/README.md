# How to build the docker image for eccenca DataIntegration

In order to use a docker image for eccenca DataIntegration you have to provide the following software artifact:

- eccenca DataIntegration

## Build the dockerimage

The artifact can be downloaded from eccenca.com (using proper credentials):
To get access please use our [contact form](https://www.eccenca.com/en/company-contact.html)

- [https://artifactory.eccenca.com/cmem/eccenca-DataIntegration/eccenca-DataIntegration-v4.0.2.zip](https://artifactory.eccenca.com/cmem/eccenca-DataIntegration/eccenca-DataIntegration-v4.0.2.zip)

Download the `.zip` files and put them into this directory (`DataIntegration`).

```bash
docker build -t eccenca-dataintegration-k8s:vX.Y.Z .
```

After finishing the build process you'll find a docker image with the name `eccenca-dataintegration-k8s:vX.Y.Z`.
This can be used to start the eccenca DataIntegration in a standalone docker container.

## Download the image from our docker registry

The docker image can be downloaded from the eccenca docker registry(using proper credentials):
To get access please use our [contact form](https://www.eccenca.com/en/company-contact.html)

Therefore please login into the eccenca docker registry useing the follwing command:

```bash
docker login https://docker-registry.eccenca.com
```

After a successful login you can pull the prebuild docker image:

```bash
docker pull docker-registry.eccenca.com/eccenca-dataintegration-k8s:latest
```

# Configuration parameter

Available environment parameters:

* [SERVER_PORT](#parameter-server_port)
* [SERVER_CONTEXTPATH](#parameter-server_contextpath)
* [JAVA_OPTS](#parameter-java_opts)

## **Parameter** `SERVER_PORT`

|                 |                                |
|-----------------|--------------------------------|
| Default         | `80`                           |
| Required        | no                             |
| Conflicts with  | none                           |
| Valid values    | numeric value                  |

Use this property to specify the port within the application should be started.

__Example__:
To launch the application listening to a custom port `https://dataintegration.example.com:12345` you have to set the `SERVER_PORT` variable to value `12345`.

```bash
docker run -d ... -e SERVER_PORT="12345" ... eccenca-dataintegration-k8s:vX.Y.Z
```

## **Parameter** `SERVER_CONTEXTPATH`

|                 |                                |
|-----------------|--------------------------------|
| Default         | `/`                            |
| Required        | no                             |
| Conflicts with  | none                           |
| Valid values    | string                         |

Use this property to specify the path within the application should be started.

__Example__:
To launch the application within the subpath `https://example.com/dataintegration` you have to set the `SERVER_CONTEXTPATH` variable to `/dataintegration`.

```bash
docker run -d ... -e SERVER_CONTEXTPATH="/dataintegration" ... eccenca-dataintegration-k8s:vX.Y.Z
```

## **Parameter** `JAVA_OPTS`

|                 |                                |
|-----------------|--------------------------------|
| Default         | `-Xms2g -Xmx4g`              |
| Required        | no                             |
| Conflicts with  | none                           |
| Valid values    | string                         |

Use this property to set custom `JAVA_OPTS`.
These will modify the configuration of the JVM.
For a list of all available Java Options take a look to the [offical Java Platform, Standard Edition Tools Reference](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html)

>Note: In any way the following JVM settings will be set `-server -Djava.security.egd=file:/dev/./urandom" \`.
This is necessary to optimize the JVM for running within a docker environment.

```bash
docker run -d ... -e JAVA_OPTS="-Xms8g -Xmx8g" ... eccenca-dataintegration-k8s:vX.Y.Z
```
