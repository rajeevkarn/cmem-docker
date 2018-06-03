#!/usr/bin/env bash
# shellcheck disable=SC1090
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

# Check that all the ENV vars are set
./aws/check-docker-env.sh

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

# Login into eccenca docker
docker login -u ${ECC_DOCKER_USER} -p ${ECC_DOCKER_PASS} https://docker-registry.eccenca.com

export DEPLOYHOST=anyhost.local
export DEPLOYPROTOCOL=http
make clean pull start
