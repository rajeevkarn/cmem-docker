#!/bin/bash

cat  << EOF
{
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": "",
    "image_version": ""
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user \`aws_access_key\`}}",
    "secret_key": "{{user \`aws_secret_key\`}}",
    "region": "$AWS_REGION",
    "source_ami_filter": {
      "filters": {
      "virtualization-type": "hvm",
      "name": "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*",
      "root-device-type": "ebs"
      },
      "owners": ["099720109477"],
      "most_recent": true
    },
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "CMEM Corporate Demo {{user \`image_version\`}}"
  }],
  "provisioners": [
    {
    "type": "shell",
    "inline": [
      "set -uex",
      "echo \"Cloning cmem-docker\" ",
      "sudo apt-get update",
      "sudo apt-get install -y git jq unzip",
      "cd /home/ubuntu && git clone https://github.com/earthquakesan/cmem-docker",
      "cd /home/ubuntu/cmem-docker && git checkout feature/aws-deployment",
      "echo \"Installing Docker\" ",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable\" ",
      "sudo apt-get update",
      "sudo apt-get -y install docker-ce",
      "sudo usermod -aG docker ubuntu",
      "echo \"Installing docker-compose\" ",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "echo \"Installing make\" ",
      "sudo apt-get install -y make"
      ]
    },
    {
      "type": "file",
      "source": "../conf/stardog/stardog-license-key.bin",
      "destination": "/home/ubuntu/cmem-docker/conf/stardog/"
    },
    {
    "type": "shell",
    "inline": [
      "set -uex",
      "echo \"Initializing CMEM\" ",
      "cd /home/ubuntu/cmem-docker && /bin/bash aws-install-script.sh"
      ]
    }
  ]
}
EOF
