#!/bin/bash

export AWS_REGION="eu-central-1"
export CMEM_IMAGE_VERSION="1.0.0"

wget https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip
unzip -o packer_1.2.3_linux_amd64.zip
export AWS_ACCESS_KEY=$(grep "AWS_ACCESS_KEY" ../aws.conf | cut -d' ' -f 2)
export AWS_SECRET_KEY=$(grep "AWS_SECRET_KEY" ../aws.conf | cut -d' ' -f 2)
if [ -z "$AWS_ACCESS_KEY" ]; then
  echo "You are required to set AWS_ACCESS_KEY (AWS access key for your AWS account) in aws.conf file."
  exit 1
fi
if [ -z "$AWS_SECRET_KEY" ]; then
  echo "You are required to set AWS_SECRET_KEY (AWS secret key for your AWS account) in aws.conf file."
  exit 1
fi

./generate-packer-template.sh > cmem-docker.json
./packer validate cmem-docker.json

./packer build \
    -var "aws_access_key=$AWS_ACCESS_KEY" \
    -var "aws_secret_key=$AWS_SECRET_KEY" \
    -var "image_version=$CMEM_IMAGE_VERSION" \
    cmem-docker.json
