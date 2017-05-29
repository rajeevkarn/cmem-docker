#!/bin/bash

echo "Starting tomcat"

sh /usr/local/tomcat/bin/startup.sh

echo "Waiting for DataPlatform to come online ..."

until $(curl --output /dev/null --silent --head --fail http://localhost:8080/dataplatform); do
    echo "Waiting for DataPlatform to come online ..."
    sleep 5
done

echo "DataPlatform online, importing data ..."

rdf gsp-put https://ns.eccenca.com/example/virtuoso-datatypes/ /data/dataplatform/datatypes.ttl http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-put https://ns.eccenca.com/example/virtuoso-datatypes/ /data/dataplatform/datatypes.ttl http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-delete https://ns.eccenca.com/example/virtuoso-datatypes/ http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-put https://ns.eccenca.com/example/data/dataset/ /data/dataplatform/datasets.ttl http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-put https://vocab.eccenca.com/dsm/ /data/dataplatform/dsm.ttl http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-put http://di.eccenca.com/project/cmem /data/dataplatform/empty-cmem-di-project.ttl http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-put https://vocab.eccenca.com/sketch/ /data/dataplatform/sketch.ttl http://localhost:8080/dataplatform/proxy/default/graph
rdf gsp-put https://ns.eccenca.com/example/data/vocabs/ /data/dataplatform/vocabs.ttl http://localhost:8080/dataplatform/proxy/default/graph

echo "Finished importing data. Now tailing tomcat log ..."

# we need this to avoid shutdown of the docker process
tail -f /usr/local/tomcat/logs/catalina.out
