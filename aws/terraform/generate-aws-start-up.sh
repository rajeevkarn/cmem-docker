#!/bin/bash

cat  << EOF
#!/bin/bash

# Check that all the ENV vars are set
export DOCKER_USER=${ECC_DOCKER_USER}
export DOCKER_PASS=${ECC_DOCKER_PASS}
export DEPLOYHOST=\${AWS_PUBLIC_DNS}
export DEPLOYPROTOCOL=http

docker login -u \${DOCKER_USER} -p \${DOCKER_PASS} https://docker-registry.eccenca.com
make clean pull start
EOF
