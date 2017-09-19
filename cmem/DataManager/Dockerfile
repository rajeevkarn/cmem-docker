FROM java:8u111-jre

ENV ECC_IMAGE_PREFIX eccenca
ENV ECC_IMAGE_NAME datamanager-k8s

ENV \
  ELDS_HOME="/opt/elds" \
  WORKDIR="/data" \
  # set JAVA OPTIONS
  # provide a random env better suited for headless work such as docker images \
  # http:\/\/www.labouisse.com\/misc\/2014\/06\/19\/tomcat-startup-time-surprises \
  ECC_JAVA_OPTS="-server -Djava.security.egd=file:/dev/./urandom" \
  JAVA_OPTS="-Xms512m -Xmx1g" \
  # configure spring application port and expose it
  SERVER_PORT=80 \
  SERVER_CONTEXTPATH=""

# add configuration & webapp
COPY eccenca-DataManager*.zip /tmp/eccenca-DataManager.zip

# prepare folder
RUN \
  mkdir -p ${ELDS_HOME}/dist ${ELDS_HOME}/etc/datamanager ${ELDS_HOME}/var/log \
  && unzip /tmp/eccenca-DataManager*.zip -d ${ELDS_HOME}/dist \
  && ln -s ${ELDS_HOME}/dist/eccenca-DataManager-v* ${ELDS_HOME}/dist/datamanager \
  && cp -nr ${ELDS_HOME}/dist/datamanager/etc/* ${ELDS_HOME}/etc/datamanager \
  && rm -f /tmp/eccenca-DataManager.zip

# expose port
EXPOSE ${SERVER_PORT}
# set working dir
WORKDIR ${WORKDIR}
VOLUME "${WORKDIR}"

# add healthcheck based on testURI command
COPY assets/testURI.sh /usr/local/bin/testURI
HEALTHCHECK --interval=5s --timeout=10s --retries=20 \
  CMD testURI "http://localhost:${SERVER_PORT}${SERVER_CONTEXTPATH}"

# start application
COPY assets/entrypoint.sh /opt/entrypoint.sh
CMD /opt/entrypoint.sh
