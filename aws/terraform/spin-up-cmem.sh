#!/usr/bin/env bash
# shellcheck disable=SC1090
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GITHUB_ROOT="$DIR/../../"

docker run -it --rm\
    -v $DIR:/terraform/\
	-w /terraform/\
	-v $GITHUB_ROOT/:/cmem-docker/:ro\
	hashicorp/terraform:light init


docker run -it --rm\
    -v $DIR:/terraform/\
	-w /terraform/\
	-v $GITHUB_ROOT/:/cmem-docker/:ro\
	hashicorp/terraform:light apply\
	-var "aws_access_key=${AWS_ACCESS_KEY}"\
	-var "aws_secret_key=${AWS_SECRET_KEY}"