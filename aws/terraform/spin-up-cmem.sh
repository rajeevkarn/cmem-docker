#!/bin/bash

export AWS_REGION="eu-central-1"
export CMEM_IMAGE_VERSION="1.0.0"

wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip -o terraform_0.11.7_linux_amd64.zip
export PATH_TO_PRIVATE_SSH_KEY=$(grep "PATH_TO_PRIVATE_SSH_KEY" ../aws.conf | cut -d' ' -f 2)
export AWS_ACCESS_KEY=$(grep "AWS_ACCESS_KEY" ../aws.conf | cut -d' ' -f 2)
export AWS_SECRET_KEY=$(grep "AWS_SECRET_KEY" ../aws.conf | cut -d' ' -f 2)
export AWS_INSTANCE_TYPE=$(grep "AWS_INSTANCE_TYPE" ../aws.conf | cut -d' ' -f 2)
export AWS_KEY_NAME=$(grep "AWS_KEY_NAME" ../aws.conf | perl -pe 's|^.*?\s||')
export ECC_DOCKER_USER=$(grep "ECC_DOCKER_USER" ../aws.conf | cut -d' ' -f 2)
export ECC_DOCKER_PASS=$(grep "ECC_DOCKER_PASS" ../aws.conf | cut -d' ' -f 2)
if [ -z "$PATH_TO_PRIVATE_SSH_KEY" ]; then
  echo "You are required to set PATH_TO_PRIVATE_SSH_KEY (path to your private ssh key corresponding to AWS key pair) in aws.conf file."
  exit 1
fi
if [ -z "$AWS_ACCESS_KEY" ]; then
  echo "You are required to set AWS_ACCESS_KEY (AWS access key for your AWS account) in aws.conf file."
  exit 1
fi
if [ -z "$AWS_SECRET_KEY" ]; then
  echo "You are required to set AWS_SECRET_KEY (AWS secret key for your AWS account) in aws.conf file."
  exit 1
fi
if [ -z "$AWS_INSTANCE_TYPE" ]; then
  echo "You are required to set AWS_INSTANCE_TYPE (AWS instance type for CMEM) in aws.conf file. The recommended minimum setup is t2.large"
  exit 1
fi
if [ -z "$AWS_KEY_NAME" ]; then
  echo "You are required to set AWS_KEY_NAME (the name of AWS key pair in the selected AWS region) in aws.conf file. Usually it is FirstName LastName."
  exit 1
fi
if [ -z "$ECC_DOCKER_USER" ]; then
  echo "You are required to set ECC_DOCKER_USER (eccenca docker registry login) in aws.conf file."
  exit 1
fi
if [ -z "$ECC_DOCKER_PASS" ]; then
  echo "You are required to set ECC_DOCKER_PASS (eccenca docker registry password) in aws.conf file."
  exit 1
fi

./generate-terraform-template.sh > main.tf
./generate-aws-start-up.sh > aws-start-up.sh
./terraform init
./terraform apply -var "key_name=${AWS_KEY_NAME}" \
	-var "aws_region=${AWS_REGION}"
