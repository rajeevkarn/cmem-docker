#!/bin/bash

# Check that all the ENV vars are set
export DOCKER_USER=iermilov
export DOCKER_PASS=!B!x2!I6gP%H84U7fPX^75IX
export DEPLOYHOST=${AWS_PUBLIC_DNS}
export DEPLOYPROTOCOL=http

docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} https://docker-registry.eccenca.com
make clean pull start
