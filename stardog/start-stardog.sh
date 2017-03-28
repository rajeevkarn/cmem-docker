#!/bin/bash

rm -f ${STARDOG_HOME}/*.lock
rm -f ${STARDOG_HOME}/*.log

# copy license from install dir if not already in STARDOG_HOME
if [ ! -f ${STARDOG_HOME}/stardog-license-key.bin ]; then
  cp ${STARDOG_INSTALL_DIR}/stardog-license-key.bin ${STARDOG_HOME}/stardog-license-key.bin
fi

# copy server properties from install dir if not already in STARDOG_HOME
if [ ! -f ${STARDOG_HOME}/stardog.properties ]; then
  cp ${STARDOG_INSTALL_DIR}/stardog.properties ${STARDOG_HOME}/stardog.properties
fi

${STARDOG_INSTALL_DIR}/bin/stardog-admin server start ${STARDOG_START_PARAMS}
${STARDOG_INSTALL_DIR}/bin/stardog-admin db create ${STARDOG_CREATE_PARAMS}
${STARDOG_INSTALL_DIR}/bin/stardog-admin server stop

echo "starting stardog with the following environment:"
echo "STARDOG_START_PARAMS: ${STARDOG_START_PARAMS}"
echo "STARDOG_CREATE_PARAMS: ${STARDOG_CREATE_PARAMS}"

${STARDOG_INSTALL_DIR}/bin/stardog-admin server start --foreground ${STARDOG_START_PARAMS}
