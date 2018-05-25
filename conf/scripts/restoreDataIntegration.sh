#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

# test for available jq tool (which is not POSIX so we need to test for it)
if ! hash jq 2>/dev/null; then
    echo "$(basename "${0}") uses jq to parse JSON. Please install it as an dependency."
    exit 1;
fi

ECC_HOST=${ECC_HOST:-}
PERSIST_BACKUPS=${PERSIST_BACKUPS:-}

if [ ! -n $ECC_HOST ]; then
  CMD="docker --tlsverify --tlscacert=${HOME}/.config/ssl/docker-eccenca/ca.pem --tlscert=${HOME}/.config/ssl/docker-eccenca/client-cert.pem --tlskey=${HOME}/.config/ssl/docker-eccenca/client-key.pem -H=$ECC_HOST.eccenca.com:2375"
else
  CMD="docker"
fi

if [[ $PERSIST_BACKUPS == "true" ]]; then

    echo "Started restore of dataintegration"

    ECCUSERNAME=${ECCUSERNAME:-userB}
    ECCUSERPASS=${ECCUSERPASS:-userB}
    ECCCLIENTNAME=${ECCCLIENTNAME:-eldsClient}
    ECCCLIENTPASS=${ECCCLIENTPASS:-secret}

    # get new token
    AUTH_URL="${DEPLOY_BASE_URL}/dataplatform/oauth/token"

    RESPONSE=$(curl  --max-time 120 --retry-delay 5 -s -S -X POST -u "${ECCCLIENTNAME}":"${ECCCLIENTPASS}" "$AUTH_URL" -d "password=${ECCUSERPASS}&username=${ECCUSERNAME}&grant_type=password")
    echo "${AUTH_URL} returned ${RESPONSE}"
    TOKEN=$(echo "$RESPONSE" | jq -r ".access_token")

    RELOAD_URL="${DEPLOY_BASE_URL}/dataintegration/workspace/import/xmlZip"

    echo "Started import of dataintegration projects via ${RELOAD_URL}"

    curl --max-time 120 --retry-delay 5 -X "POST" -H "Authorization: Bearer ${TOKEN}" \
        -F "project_name=cmem" -F "file=@${DESTINATION}/data/backups/dataintegration/cmem_workspace.zip" \
        "${RELOAD_URL}"

    echo "Finished import of dataintegration projects"

    RELOAD_URL="${DEPLOY_BASE_URL}/dataintegration/workspace/reload"


    echo "Started reload of dataintegration workspace via ${RELOAD_URL}"

    # call dataintegration to reload workspace (using the TOKEN)
    curl --max-time 120 --retry-delay 5 -X "POST" -H "Authorization: Bearer ${TOKEN}" \
        "${RELOAD_URL}"

    echo "Finished reload of dataintegration workspace"

    echo "Finished restore of dataintegration"

else
    echo "no data has to be restored for dataintegration"
fi
