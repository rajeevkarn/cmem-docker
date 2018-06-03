#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

: ${ECC_DOCKER_USER?"You are required to set ECC_DOCKER_USER (eccenca docker registry login) environment variable."}
: ${ECC_DOCKER_PASS?"You are required to set ECC_DOCKER_PASS (eccenca docker registry password) environment variable."}
