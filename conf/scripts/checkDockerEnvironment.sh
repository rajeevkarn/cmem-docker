#!/bin/sh
set -e

DOCKER_MAJOR_W=${DOCKER_MAJOR_W:-1}
DOCKER_MINOR_W=${DOCKER_MINOR_W:-11}

DOCKER_COMPOSE_MAJOR_W=${DOCKER_COMPOSE_MAJOR_W:-1}
DOCKER_COMPOSE_MINOR_W=${DOCKER_COMPOSE_MINOR_W:-7}

command_exists() {
  command -v "$@" > /dev/null 2>&1
}


semverParse() {
  major="${1%%.*}"
  minor="${1#$major.}"
  minor="${minor%%.*}"
  patch="${1#$major.$minor.}"
  patch="${patch%%[-.]*}"
}


if command_exists docker; then
  version="$(docker -v | awk -F '[ ,]+' '{ print $3 }')"

  semverParse $version

  shouldWarnD=0
  if [ $major -lt $DOCKER_MAJOR_W ]; then
    shouldWarnD=1
  fi

  if [ $major -le $DOCKER_MAJOR_W ] && [ $minor -lt $DOCKER_MINOR_W ]; then
    shouldWarnD=1
  fi

  if [ $shouldWarnD -eq 1 ]; then
    echo "You are running docker in version: ${version}. This version is deprecated. Please take a look at https://confluence.brox.de/display/ECCGMBH/Docker and check supported version and update your docker-environment"
  fi
fi

if command_exists docker-compose; then
  version="$(docker-compose -v | awk -F '[ ,]+' '{ print $3 }')"

  semverParse $version

  shouldWarnDC=0
  if [ $major -lt $DOCKER_COMPOSE_MAJOR_W ]; then
    shouldWarnDC=1
  fi

  if [ $major -le $DOCKER_COMPOSE_MAJOR_W ] && [ $minor -lt $DOCKER_COMPOSE_MINOR_W ]; then
    shouldWarnDC=1
  fi

  if [ $shouldWarnDC -eq 1 ]; then
    echo "You are running docker-compose in version: ${version}. This version is deprecated. Please take a look at https://confluence.brox.de/display/ECCGMBH/Docker and check supported version and update your docker-environment"
  fi

  # wirte exit code in case of docker or docker-compose version conflicts
  if [ $shouldWarnD -eq 1 ] || [ $shouldWarnDC -eq 1 ]; then
    exit 1
  fi
fi
