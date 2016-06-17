FROM tomcat:8.5

ENV ELDS_HOME /opt/elds
RUN mkdir -p ${ELDS_HOME}/dist
COPY dist ${ELDS_HOME}/dist

WORKDIR ${ELDS_HOME}/dist

# link the wars to cataline/webapps
RUN \
  rm -rf ${CATALINA_HOME}/webapps/ROOT \
  && mkdir -p ${CATALINA_HOME}/conf/Catalina/localhost \
  && ln -sf ${ELDS_HOME}/dist/dataplatform/lib/eccenca-DataPlatform.war ${CATALINA_HOME}/webapps/dataplatform.war \
  && ln -sf ${ELDS_HOME}/dist/dataplatform/etc/dataplatform.xml.dist ${CATALINA_HOME}/conf/Catalina/localhost/dataplatform.xml \
  && ln -sf ${ELDS_HOME}/dist/datamanager/lib/eccenca-DataManager.war ${CATALINA_HOME}/webapps/ROOT.war \
  && ln -sf ${ELDS_HOME}/dist/datamanager/etc/datamanager.xml.dist ${CATALINA_HOME}/conf/Catalina/localhost/ROOT.xml \
  && ln -sf ${ELDS_HOME}/dist/dataintegration/lib/eccenca-DataIntegration.war ${CATALINA_HOME}/webapps/dataintegration.war \
  && ln -sf ${ELDS_HOME}/dist/dataintegration/etc/dataintegration.xml.dist ${CATALINA_HOME}/conf/Catalina/localhost/dataintegration.xml