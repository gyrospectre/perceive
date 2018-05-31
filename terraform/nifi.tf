resource "aws_instance" "nifi" {
  ami      = "${data.aws_ami.perceive_base_ami.id}"
  instance_type = "t2.small"
  key_name = "main"
  vpc_security_group_ids = ["${aws_security_group.perceive_nifi_sg.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "perceive_nifi_sg" {
  name = "security_group_for_nifi"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 9092
    to_port = 9092
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
  }

  egress {
    from_port = 9200
    to_port = 9200
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "nifi_ip" {
  value = "${aws_instance.nifi.private_ip}"
}