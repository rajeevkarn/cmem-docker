provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
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

resource "tls_private_key" "cmem" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.cmem.public_key_openssh}"
}

resource "random_id" "security_group" {
  byte_length = 8
}

resource "aws_security_group" "default" {
  name        = "${random_id.security_group.hex}"
  description = "Allow HTTP and SSH to everyone"
  vpc_id      = "${aws_default_vpc.default.id}"

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
  ami           = "${data.aws_ami.cmem.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  
  provisioner "file" {
    connection {
      user = "ubuntu"
      private_key = "${tls_private_key.cmem.private_key_pem}"
    }
    source      = "/cmem-docker/aws/terraform/aws-start-up.sh"
    destination = "/home/ubuntu/cmem-docker/aws-start-up.sh"
  }
  
  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      private_key = "${tls_private_key.cmem.private_key_pem}"
    }
    inline = [
      "chmod +x /home/ubuntu/cmem-docker/aws-start-up.sh",
      "cd /home/ubuntu/cmem-docker/ && ECC_DOCKER_USER=${var.docker_user} ECC_DOCKER_PASS='${var.docker_pass}' AWS_PUBLIC_DNS=${aws_instance.cmem.public_dns} ./aws-start-up.sh"
    ]
}
}
