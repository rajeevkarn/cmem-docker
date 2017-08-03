#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail;

# check if application.yml is given, if not copy default one to WORKDIR/mounting point
if [ ! -f "${WORKDIR}/dataintegration.conf" ]; then
  echo "copy default dataintegration.conf to WORKDIR: ${WORKDIR}"
  cp "${ELDS_HOME}/etc/dataintegration/dataintegration.conf.dist" "${WORKDIR}/dataintegration.conf"
fi

if [ -f "${WORKDIR}/dataintegration.conf" ]; then
  echo "copy provides dataintegration.conf as default one"
  cp "${WORKDIR}/dataintegration.conf" "${ELDS_HOME}/etc/dataintegration/dataintegration.conf"
fi

# start application
export JAVA_OPTS="${JAVA_OPTS} ${ECC_JAVA_OPTS}"
echo "ready to start application ${ECC_IMAGE_PREFIX}-${ECC_IMAGE_NAME} ..."
${ELDS_HOME}/dist/dataintegration/bin/eccenca-dataintegration -Dplay.server.http.port=${SERVER_PORT} -Dplay.http.context=${SERVER_CONTEXTPATH} -Dpidfile.path=/dev/null
