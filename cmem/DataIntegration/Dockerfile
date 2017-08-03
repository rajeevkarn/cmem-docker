FROM java:8u111-jre

ENV ECC_IMAGE_PREFIX k8s-eccenca
ENV ECC_IMAGE_NAME dataintegration

ENV \
  ELDS_HOME="/opt/elds" \
  WORKDIR="/data" \
  # set JAVA OPTIONS
  # provide a random env better suited for headless work such as docker images \
  # http:\/\/www.labouisse.com\/misc\/2014\/06\/19\/tomcat-startup-time-surprises \
  ECC_JAVA_OPTS="-server -Djava.security.egd=file:/dev/./urandom" \
  JAVA_OPTS="-Xms2g -Xmx4g" \
  # configure spring application port and expose it
  SERVER_PORT=80 \
  SERVER_CONTEXTPATH="/"

# add configuration & webapp
COPY eccenca-DataIntegration*.zip /tmp/eccenca-DataIntegration.zip

# prepare folder
RUN \
  mkdir -p ${ELDS_HOME}/dist ${ELDS_HOME}/etc/dataintegration ${ELDS_HOME}/var/log \
  && unzip /tmp/eccenca-DataIntegration*.zip -d /tmp/dataintegration \
  && unzip /tmp/dataintegration/eccenca-DataIntegration*/lib/*cloudfoundry.zip -d ${ELDS_HOME}/dist \
  && ln -s ${ELDS_HOME}/dist/eccenca-dataintegration-* ${ELDS_HOME}/dist/dataintegration \
  && cp -nr /tmp/dataintegration/eccenca-DataIntegration-v*/etc/dataintegration.conf.dist ${ELDS_HOME}/etc/dataintegration/dataintegration.conf.dist \
  && cp -n /tmp/dataintegration/eccenca-DataIntegration-v*/lib/eccenca-DataIntegration-assembly.jar ${ELDS_HOME}/dist/dataintegration/spark-assembly.jar \
  && rm -rf /tmp/eccenca-DataIntegration.zip /tmp/dataintegration*

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
