#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail;

curlHTTPStatus=$(curl --silent --output /dev/null -H "Origin: http://docker.local" --head --write-out "%{http_code}" ${1})
curlExitStatus=$?
if [[ "${curlExitStatus}" -ne "0" ]]; then
  echo "curl returned exit code ${curlExitStatus}, unhealthy"
exit 1
fi
if [[ "${curlHTTPStatus}" -ne "200" ]]; then
  echo "HEAD on $1 returned ${curlHTTPStatus} != 200, unhealthy"
  exit 1
fi
echo "healthy"
exit 0
