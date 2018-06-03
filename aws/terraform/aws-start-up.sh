#!/bin/bash

export DEPLOYHOST=${AWS_PUBLIC_DNS}
export DEPLOYPROTOCOL=http
docker login -u ${ECC_DOCKER_PASS} -p ${ECC_DOCKER_PASS} https://docker-registry.eccenca.com
make clean pull start
