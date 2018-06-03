#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

: ${AWS_ACCESS_KEY?"You are required to set AWS_ACCESS_KEY (AWS access key for your AWS account) environment variable."}
: ${AWS_SECRET_KEY?"You are required to set AWS_SECRET_KEY (AWS secret key for your AWS account) environment variable."}
: ${AWS_INSTANCE_TYPE?"You are required to set AWS_INSTANCE_TYPE (AWS instance type for CMEM) environment variable. The recommended minimum setup is t2.large"}
: ${AWS_REGION?"You are required to set AWS_REGION (AWS region) environment variable. The recommended parameter for Europe is eu-central-1"}
: ${CMEM_IMAGE_VERSION?"You are required to set CMEM_IMAGE_VERSION (AMI version) environment variable."}