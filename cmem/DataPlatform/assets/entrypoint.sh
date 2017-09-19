#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail;

# check if application.yml is given, if not copy default one to WORKDIR/mounting point
if [ ! -f "${WORKDIR}/application.yml" ]; then
  echo "copy default application.yml to WORKDIR: ${WORKDIR}"
  cp "${ELDS_HOME}/etc/dataplatform/application.yml.dist" "${WORKDIR}/application.yml"
fi
# check if accessCondition.ttl is given, if not copy default one to WORKDIR/mounting point
if [ ! -f "${WORKDIR}/accessConditions.ttl" ]; then
  echo "copy default accessConditions.ttl to WORKDIR: ${WORKDIR}"
  cp "${ELDS_HOME}/etc/dataplatform/accessConditions.ttl.dist" "${WORKDIR}/accessConditions.ttl"
fi

# start application
export JAVA_OPTS="${JAVA_OPTS} ${ECC_JAVA_OPTS}"
echo "ready to start application ${ECC_IMAGE_PREFIX}-${ECC_IMAGE_NAME} ..."
SPRING_CONFIG_LOCATION=/data/application.yml java -jar ${JAVA_OPTS} ${ELDS_HOME}/dist/dataplatform/lib/eccenca-DataPlatform.war
