#!/bin/bash

# used to check successful startup
HEALTH_FILE=/tmp/healthy
rm -f ${HEALTH_FILE}

echo "### Starting Tomcat..."

sh /usr/local/tomcat/bin/startup.sh

echo "### Waiting for DataPlatform to come online..."

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
    echo "### Still waiting for DataPlatform to come online..."
    sleep 5
done

echo "### DataPlatform online, importing data ..."

if [ -f /data/dataplatform/empty-cmem-di-project.ttl ]; then

  access_token=$(curl -X POST -s -u eldsClient:secret http://localhost:8080/dataplatform/oauth/token -H "Accept: application/json" -d "password=userB&username=userB&grant_type=password&client_secret=secret&client_id=eldsClient" | perl -ne 'if(s/.*"access_token"\s*:\s*"([^"]+).*/$1/){print;exit}')

  curl -v -L -X PUT -H "Authorization: Bearer ${access_token}" -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/datatypes.ttl "http://localhost:8080/dataplatform/proxy/default/graph?comment=Initial+commit&graph=https%3a%2f%2fns.eccenca.com%2fexample%2fvirtuoso-datatypes%2f"
  curl -v -L -X PUT -H "Authorization: Bearer ${access_token}" -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/datasets.ttl "http://localhost:8080/dataplatform/proxy/default/graph?comment=Initial+commit&graph=https%3a%2f%2fns.eccenca.com%2fexample%2fdata%2fdataset%2f"
  curl -v -L -X PUT -H "Authorization: Bearer ${access_token}" -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/dsm.ttl "http://localhost:8080/dataplatform/proxy/default/graph?comment=Initial+commit&graph=https%3a%2f%2fvocab.eccenca.com%2fdsm%2f"
  curl -v -L -X PUT -H "Authorization: Bearer ${access_token}" -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/empty-cmem-di-project.ttl "http://localhost:8080/dataplatform/proxy/default/graph?comment=Initial+commit&graph=http%3a%2f%2fdi.eccenca.com%2fproject%2fcmem"
  curl -v -L -X PUT -H "Authorization: Bearer ${access_token}" -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/sketch.ttl "http://localhost:8080/dataplatform/proxy/default/graph?comment=Initial+commit&graph=https%3a%2f%2fvocab.eccenca.com%2fsketch%2f"
  curl -v -L -X PUT -H "Authorization: Bearer ${access_token}" -H 'Content-Type:text/turtle' --data-binary @/data/dataplatform/vocabs.ttl "http://localhost:8080/dataplatform/proxy/default/graph?comment=Initial+commit&graph=https%3a%2f%2fns.eccenca.com%2fexample%2fdata%2fvocabs%2f"

  touch ${HEALTH_FILE}

  echo "### Finished importing data. Now tailing Tomcat log ..."

  # we need this to avoid shutdown of the docker process
  tail -f /usr/local/tomcat/logs/catalina.out

else

  echo "### ERROR: Unable to import data, initial data artifacts not found!"

fi
