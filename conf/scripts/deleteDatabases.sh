#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

ECC_HOST=${ECC_HOST:-}

if [ ! -n $ECC_HOST ]; then
  CMD="docker --tlsverify --tlscacert=${HOME}/.config/ssl/docker-eccenca/ca.pem --tlscert=${HOME}/.config/ssl/docker-eccenca/client-cert.pem --tlskey=${HOME}/.config/ssl/docker-eccenca/client-key.pem -H=$ECC_HOST.eccenca.com:2375"
else
  CMD="docker"
fi

# if there are no arguments, restore latest backups for each everything
if [ -z "$1" ]; then

    echo "Started deleting databases ..."

    echo "Deleting stardog"

    ${CMD} exec "${COMPOSE_PROJECT_NAME}_stardog_1" /opt/stardog/bin/stardog-admin db drop -v stardog || exit 0

    echo "finished deleting databases."

else
    echo "Deleting $1"
    ${CMD} exec "${COMPOSE_PROJECT_NAME}_stardog_1" /opt/stardog/bin/stardog-admin db drop -v "$1"
fi
