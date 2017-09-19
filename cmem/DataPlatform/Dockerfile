FROM java:8u111-jre

ENV ECC_IMAGE_PREFIX eccenca
ENV ECC_IMAGE_NAME dataplatform-k8s

ENV \
  ELDS_HOME="/opt/elds" \
  WORKDIR="/data" \
  # set JAVA OPTIONS
  # provide a random env better suited for headless work such as docker images \
  # http:\/\/www.labouisse.com\/misc\/2014\/06\/19\/tomcat-startup-time-surprises \
  ECC_JAVA_OPTS="-server -Djava.security.egd=file:/dev/./urandom" \
  JAVA_OPTS="-Xms1g -Xmx2g" \
  # configure spring application port and expose it
  SERVER_PORT=80 \
  SERVER_CONTEXTPATH=""

# add configuration & webapp
COPY eccenca-DataPlatform*.zip /tmp/eccenca-DataPlatform.zip

# prepare folder
RUN \
  mkdir -p ${ELDS_HOME}/dist ${ELDS_HOME}/etc/dataplatform ${ELDS_HOME}/var/log \
  && unzip /tmp/eccenca-DataPlatform*.zip -d ${ELDS_HOME}/dist \
  && ln -s ${ELDS_HOME}/dist/eccenca-DataPlatform-v* ${ELDS_HOME}/dist/dataplatform \
  && cp -nr ${ELDS_HOME}/dist/dataplatform/etc/* ${ELDS_HOME}/etc/dataplatform \
  && rm -f /tmp/eccenca-DataPlatform.zip

# expose port
EXPOSE ${SERVER_PORT}
# set working dir
WORKDIR ${WORKDIR}
VOLUME "${WORKDIR}"

# add healthcheck based on testURI command
COPY assets/testURI.sh /usr/local/bin/testURI
HEALTHCHECK --interval=5s --timeout=10s --retries=20 \
  CMD testURI "http://localhost:${SERVER_PORT}${SERVER_CONTEXTPATH}/health"

# start application
COPY assets/entrypoint.sh /opt/entrypoint.sh
CMD /opt/entrypoint.sh
