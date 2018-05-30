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

resource "aws_instance" "confluent" {
  ami      = "${data.aws_ami.perceive_base_ami.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.perceive_confluent_sg.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "perceive_confluent_sg" {
  name = "security_group_for_confluent"
  ingress {
    from_port = 9092
    to_port = 9092
    protocol = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "confluent_ip" {
  value = "${aws_instance.confluent.private_ip}"
}