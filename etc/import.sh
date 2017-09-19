#!/bin/bash

echo "Starting tomcat"

sh /usr/local/tomcat/bin/startup.sh

echo "Waiting for DataPlatform to come online ..."

function testUri() {

    uri="http://localhost:8080/dataplatform/health"
    curlHTTPStatus=$(curl --silent --output /dev/null -H "Origin: http://docker.local" --head --write-out "%{http_code}" "${uri}")
    curlExitStatus=$?

    if [[ "${curlExitStatus}" -ne "0" ]]; then
      (echo "testURI (${uri}): curl returned exit code ${curlExitStatus} (https://curl.haxx.se/libcurl/c/libcurl-errors.html), unhealthy")
      return 1
    elif [[ "${curlHTTPStatus}" -ne "200" ]]; then
      (echo "testURI (${uri}): HEAD on returned ${curlHTTPStatus} != 200, unhealthy")
      return 1
    fi
    return 0
}

until testUri; do
    echo "still waiting for DataPlatform to come online..."
    sleep 5
done

echo "DataPlatform online, importing data ..."

curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/datatypes.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=https%3a%2f%2fns.eccenca.com%2fexample%2fvirtuoso-datatypes%2f"
curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/datatypes.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=https%3a%2f%2fns.eccenca.com%2fexample%2fvirtuoso-datatypes%2f"
curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/datasets.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=https%3a%2f%2fns.eccenca.com%2fexample%2fdata%2fdataset%2f"
curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/dsm.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=https%3a%2f%2fvocab.eccenca.com%2fdsm%2f"
curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/empty-cmem-di-project.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=http%3a%2f%2fdi.eccenca.com%2fproject%2fcmem"
curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/sketch.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=https%3a%2f%2fvocab.eccenca.com%2fsketch%2f"
curl -v -L -X PUT -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/vocabs.ttl "http://localhost:8080/dataplatform/proxy/default/graph?graph=https%3a%2f%2fns.eccenca.com%2fexample%2fdata%2fvocabs%2f"

echo "Finished importing data. Now tailing tomcat log ..."

# we need this to avoid shutdown of the docker process
tail -f /usr/local/tomcat/logs/catalina.out
