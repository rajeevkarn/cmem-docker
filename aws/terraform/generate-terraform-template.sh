#!/bin/bash

cat  << EOF
provider "aws" {
  access_key = "$AWS_ACCESS_KEY"
  secret_key = "$AWS_SECRET_KEY"
  region     = "\${var.aws_region}"
}

data "aws_ami" "cmem" {
    most_recent = true

    filter {
        name   = "name"
        values = ["CMEM Corporate Demo 1.0.0"]
    }

    owners = ["self"] # Private images
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "default" {
  name        = "cmem_security_group"
  description = "Allow HTTP and SSH to everyone"
  vpc_id      = "\${aws_default_vpc.default.id}"

  # http access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cmem" {
  ami           = "\${data.aws_ami.cmem.id}"
  instance_type = "$AWS_INSTANCE_TYPE"
  key_name = "\${var.key_name}"
  vpc_security_group_ids = ["\${aws_security_group.default.id}"]
  
  provisioner "file" {
    connection {
      user = "ubuntu"
      private_key = "\${file("$PATH_TO_PRIVATE_SSH_KEY")}"
    }
    source      = "aws-start-up.sh"
    destination = "/home/ubuntu/cmem-docker/aws-start-up.sh"
  }

  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      private_key = "\${file("$PATH_TO_PRIVATE_SSH_KEY")}"
    }
    inline = [
      "chmod +x /home/ubuntu/cmem-docker/aws-start-up.sh",
      "cd /home/ubuntu/cmem-docker && AWS_PUBLIC_DNS=\${aws_instance.cmem.public_dns} ./aws-start-up.sh",
    ]
}
}
EOF
