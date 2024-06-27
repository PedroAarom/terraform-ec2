provider "aws" {
  region = var.aws_region  # Cambia esto a tu región preferida
}

resource "aws_instance" "web" {
  ami           = var.ami  # AMI de Amazon Linux 2
  instance_type = var.instance_type
  key_name      = var.key_name  # Cambia esto al nombre de tu par de claves SSH
 
  tags = {
    Name = "WebServer"
  }
 
  # Define el Security Group para permitir tráfico HTTP y SSH
  vpc_security_group_ids = [aws_security_group.web_sg.id]
 
  provisioner "file" {
    source      = var.provisioner_file_source
    destination = "/tmp/install_apache.sh"
  }
 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "sudo /tmp/install_apache.sh"
    ]
  }
 
  connection {
    type        = var.connection_type
    user        = var.connection_user
    private_key = file(var.connection_private_key)  # Ruta a tu clave privada
    host        = self.public_ip
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH traffic"
 
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
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

