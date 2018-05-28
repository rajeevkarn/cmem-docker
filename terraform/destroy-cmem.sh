#!/bin/bash

export AWS_REGION="eu-central-1"
export CMEM_IMAGE_VERSION="1.0.0"
export AWS_ACCESS_KEY=$(grep "AWS_ACCESS_KEY" ../aws.conf | cut -d' ' -f 2)
export AWS_SECRET_KEY=$(grep "AWS_SECRET_KEY" ../aws.conf | cut -d' ' -f 2)
./terraform destroy -var "key_name=${AWS_KEY_NAME}" \
	-var "aws_region=${AWS_REGION}"
