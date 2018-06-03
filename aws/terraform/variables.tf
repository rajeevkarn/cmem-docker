variable "aws_access_key" {
  description = "AWS access key."
}

variable "aws_secret_key" {
  description = "AWS secret key." 
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "AWS instance type."
  default     = "t2.large"
}

variable "key_name" {
  description = "AWS key name."
  default = "cmemkey"
}

variable "docker_pass" {
  description = "Eccenca docker registry password."
}

variable "docker_user" {
  description = "Eccenca docker registry user."
}