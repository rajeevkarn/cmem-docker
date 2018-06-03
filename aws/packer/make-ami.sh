#!/bin/bash

wget https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip
unzip -o packer_1.2.3_linux_amd64.zip

./packer validate cmem-docker.json

./packer build \
    -var "aws_access_key=$AWS_ACCESS_KEY" \
    -var "aws_secret_key=$AWS_SECRET_KEY" \
    -var "image_version=$CMEM_IMAGE_VERSION" \
    -var "aws_region=$AWS_REGION" \
    cmem-docker.json
