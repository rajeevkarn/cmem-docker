#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

ECC_HOST=${ECC_HOST:-}
PERSIST_BACKUPS=${PERSIST_BACKUPS:-}

if [ ! -n $ECC_HOST ]; then
  CMD="docker --tlsverify --tlscacert=${HOME}/.config/ssl/docker-eccenca/ca.pem --tlscert=${HOME}/.config/ssl/docker-eccenca/client-cert.pem --tlskey=${HOME}/.config/ssl/docker-eccenca/client-key.pem -H=$ECC_HOST.eccenca.com:2375"
else
  CMD="docker"
fi
if [[ $PERSIST_BACKUPS == "true" ]]; then
  ls "${DESTINATION}/data/backups/database/backups/$1/"
else
  ${CMD} exec "${COMPOSE_PROJECT_NAME}_stardog_1" ls "/data/backups/$1/"
fi
