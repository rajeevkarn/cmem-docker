#!/usr/bin/env bash
# shellcheck disable=SC1090
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GITHUB_ROOT="$DIR/../../"
echo $GITHUB_ROOT

docker run -it --rm\
    -v $DIR/cmem-docker.json:/cmem-docker.json:ro\
    -v $GITHUB_ROOT:/cmem-docker:ro\
    hashicorp/packer:light validate /cmem-docker.json

docker run -it --rm\
    -v $DIR/cmem-docker.json:/cmem-docker.json\
    -v $GITHUB_ROOT:/cmem-docker:ro\
    hashicorp/packer:light build\
    -var "aws_access_key=$AWS_ACCESS_KEY" \
    -var "aws_secret_key=$AWS_SECRET_KEY" \
    -var "image_version=$CMEM_IMAGE_VERSION" \
    -var "aws_region=$AWS_REGION" \
    /cmem-docker.json
