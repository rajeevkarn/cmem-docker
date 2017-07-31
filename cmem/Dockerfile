FROM tomcat:8.5

ENV \
  ELDS_HOME=/opt/elds \
  CATALINA_OPTS="-Xmx2g -XX:MaxPermSize=512m"

COPY eccenca-*.zip /tmp/
RUN \
  mkdir -p ${ELDS_HOME}/dist \
  && unzip -d ${ELDS_HOME}/dist/ /tmp/eccenca-DataIntegration* \
  && unzip -d ${ELDS_HOME}/dist/ /tmp/eccenca-DataManager* \
  && unzip -d ${ELDS_HOME}/dist/ /tmp/eccenca-DataPlatform* \
  && cd ${ELDS_HOME}/dist \
  && mv eccenca-DataIntegration* dataintegration \
  && mv eccenca-DataManager* datamanager \
  && mv eccenca-DataPlatform* dataplatform \
  && rm -rf /tmp/eccenca-Data*

WORKDIR ${ELDS_HOME}/dist

# install rdf.sh
RUN \
  wget -O /usr/local/bin/rdf https://raw.githubusercontent.com/seebi/rdf.sh/develop/rdf \
  && chmod +x /usr/local/bin/rdf

# link the wars to catalina/webapps
RUN \
  rm -rf ${CATALINA_HOME}/webapps/ROOT \
  && mkdir -p ${CATALINA_HOME}/conf/Catalina/localhost \
  && ln -sf ${ELDS_HOME}/dist/dataplatform/lib/eccenca-DataPlatform.war ${CATALINA_HOME}/webapps/dataplatform.war \
  && ln -sf ${ELDS_HOME}/dist/dataplatform/etc/dataplatform.xml.dist ${CATALINA_HOME}/conf/Catalina/localhost/dataplatform.xml \
  && ln -sf ${ELDS_HOME}/dist/datamanager/lib/eccenca-DataManager.war ${CATALINA_HOME}/webapps/ROOT.war \
  && ln -sf ${ELDS_HOME}/dist/datamanager/etc/datamanager.xml.dist ${CATALINA_HOME}/conf/Catalina/localhost/ROOT.xml \
  && ln -sf ${ELDS_HOME}/dist/dataintegration/lib/eccenca-DataIntegration.war ${CATALINA_HOME}/webapps/dataintegration.war

CMD /opt/elds/etc/import.sh
