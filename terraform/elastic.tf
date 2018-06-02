resource "aws_instance" "elastic" {
  ami      = "${data.aws_ami.perceive_base_ami.id}"
  instance_type = "t2.small"
  key_name = "main"
  vpc_security_group_ids = ["${aws_security_group.perceive_elastic_sg.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "perceive_elastic_sg" {
  name = "security_group_for_elastic"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }

  ingress {
    from_port = 9200
    to_port = 9200
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
  }

  ingress {
    from_port = 5601
    to_port = 5601
    protocol = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
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

  lifecycle {
    create_before_destroy = true
  }
}

output "elastic_ip" {
  value = "${aws_instance.elastic.private_ip}"
}