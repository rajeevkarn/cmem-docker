#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

./check-aws-env.sh
./check-docker-env.sh
