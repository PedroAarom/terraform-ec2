resource "aws_security_group" "allow_tls" {

name_prefix = "allow_tls_"

vpc_id = var.myvpc

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {

description = "TLS from VPC"

from_port = 443

to_port = 443

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]

}

egress {

from_port = 0

to_port = 0

protocol = "-1"

cidr_blocks = ["0.0.0.0/0"]

}

}

resource "aws_instance" "app" {

ami = "ami-01b799c439fd5516a" # Amazon Linux 2 AMI

instance_type = var.environment == "prod" ? "t2.medium" : "t2.micro"

subnet_id = element(var.subnet, 0)

key_name = "vockey"

vpc_security_group_ids = [aws_security_group.allow_tls.id]

tags = {

Name = "MyAppInstance"

}

root_block_device {

volume_size = var.environment == "prod" ? 50 : 20

volume_type = "gp2"

}

}