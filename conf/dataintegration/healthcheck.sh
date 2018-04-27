#!/bin/bash

function testURI {
    curlHTTPStatus=$(curl --silent --output /dev/null --head --write-out "%{http_code}" $1)
    curlExitStatus=$?
    if [[ "$curlExitStatus" -ne "0" ]]; then
        echo "curl returned exit code $curlExitStatus, unhealthy"
        exit 1
    fi
    if [[ "$curlHTTPStatus" -ne "200" ]]; then
        echo "HEAD on $1 returned $curlHTTPStatus != 200, unhealthy"
        exit 1
    fi
}
testURI "http://localhost:${SERVER_PORT}${SERVER_CONTEXTPATH}version" || exit 1

echo "healthy"
exit 0
