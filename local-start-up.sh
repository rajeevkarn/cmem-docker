#!/bin/bash

if [ ! -f conf/stardog/stardog-license-key.bin ]; then

    echo "Stardog license key not found at conf/stardog/stardog-license-key.bin. Please provide the key. Aborting..."
    exit 1
fi

wget https://download.eccenca.com/cmem/2018-04-cmem-data.zip -O - > data/backups/2018-04-cmem-data.zip
# Check that file downloaded correctly
if [ ! -f data/backups/2018-04-cmem-data.zip ]; then
    echo "Download of CMEM data dump was not successful! Aborting..."
    exit 1
fi

# Check that all the ENV vars are set
export ECC_DOCKER_USER=$(grep "ECC_DOCKER_USER" aws.conf | cut -d' ' -f 2)
export ECC_DOCKER_PASS=$(grep "ECC_DOCKER_PASS" aws.conf | cut -d' ' -f 2)
export DOCKER_USER=${ECC_DOCKER_USER}
export DOCKER_PASS=${ECC_DOCKER_PASS}
export DEPLOYHOST=localhost
export DEPLOYPROTOCOL=http
docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} https://docker-registry.eccenca.com
make clean pull start
