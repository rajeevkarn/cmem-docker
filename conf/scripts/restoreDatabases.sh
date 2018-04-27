#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

# test for available jq tool (which is not POSIX so we need to test for it)
if ! hash jq 2>/dev/null; then
    echo "$(basename "${0}") uses jq to parse JSON. Please install it as an dependency."
    exit 1;
fi

ECC_HOST=${ECC_HOST:-}

if [ ! -n $ECC_HOST ]; then
  CMD="docker --tlsverify --tlscacert=${HOME}/.config/ssl/docker-eccenca/ca.pem --tlscert=${HOME}/.config/ssl/docker-eccenca/client-cert.pem --tlskey=${HOME}/.config/ssl/docker-eccenca/client-key.pem -H=$ECC_HOST.eccenca.com:2375"
else
  CMD="docker"
fi

CONTAINER="${COMPOSE_PROJECT_NAME}_stardog_1"

if [[ $PERSIST_BACKUPS == "true" ]]; then
  echo "copy backups to ${DESTINATION}/data/backups/database"
  ${CMD} exec "${CONTAINER}" /bin/bash -c "rm -rf /data/backups"
  ${CMD} cp "${DESTINATION}"/data/backups/database "${CONTAINER}:/data/backups/"
  ${CMD} exec "$CONTAINER" ls /data/backups/
fi

# if there are no arguments, restore latest backups for each everything
if [ -z "$1" ]; then

    echo "Restore of latest backups for all databases started ..."

    echo "Started restoration of latest backup of stardog"
    LATEST_BACKUP=$(${CMD} exec "${CONTAINER}" ls -t /data/backups/stardog | head -1)
    LATEST_BACKUP="/data/backups/stardog/$LATEST_BACKUP"
    echo "Latest backup: ${LATEST_BACKUP}"
    ${CMD} exec "${CONTAINER}" /opt/stardog/bin/stardog-admin db restore --overwrite -v "${LATEST_BACKUP}"

    echo "Finished restoring latest backups of databases."

# restore given backup
else
    echo "Started restoration of $1 backup, version $2"
    ${CMD} exec "${CONTAINER}" /opt/stardog/bin/stardog-admin db restore --overwrite -v "/data/backups/$1/$2"
fi

ECCUSERNAME=${ECCUSERNAME:-userB}
ECCUSERPASS=${ECCUSERPASS:-userB}
ECCCLIENTNAME=${ECCCLIENTNAME:-eldsClient}
ECCCLIENTPASS=${ECCCLIENTPASS:-secret}

## Refresh Access conditions

RELOAD_URL="${DEPLOY_BASE_URL}/dataplatform/authorization/refresh"

echo "Started reload of access conditions via ${RELOAD_URL}"

# get new token
AUTH_URL="${DEPLOY_BASE_URL}/dataplatform/oauth/token"

RESPONSE=$(curl  --max-time 120 --retry-delay 5 -s -S -X POST -u "${ECCCLIENTNAME}":"${ECCCLIENTPASS}" "$AUTH_URL" -d "password=${ECCUSERPASS}&username=${ECCUSERNAME}&grant_type=password")
echo "${AUTH_URL} returned ${RESPONSE}"
TOKEN=$(echo "$RESPONSE" | jq -r ".access_token")

# call dataplatform to refresh access conditions
curl  --max-time 120 --retry-delay 5 -X "GET" -H "Authorization: Bearer ${TOKEN}" \
    "${RELOAD_URL}"

echo "Finished reload of access conditions"
