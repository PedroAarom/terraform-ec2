module "compute" {
    source = "./modules/compute"
    aws_region = "us-east-1"
    ami = "ami-01b799c439fd5516a"
    instance_type = "t2.micro"
    key_name = "vockey"
    connection_type = "ssh"
    connection_user = "ec2-user"
    connection_private_key = "./modules/compute/ssh.pem"
    provisioner_file_source = "./modules/compute/install_apache.sh"
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.compute.ec2_instance_id
}

output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.compute.ec2_instance_public_ip
}