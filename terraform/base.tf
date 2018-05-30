variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "ap-southeast-2"
}

data "aws_ami" "perceive_base_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["perceive-base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["752524387579"]
}