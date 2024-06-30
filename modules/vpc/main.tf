provider "aws" {
 region = "us-east-1"
}
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

variable "environment" {

description = "The environment to deploy to"

type = string

default = "dev"

}

resource "aws_subnet" "subnet" {

count = var.environment == "prod" ? 2 : 1

vpc_id = aws_vpc.main.id

cidr_block = var.environment == "prod" ? element(["10.0.1.0/24", "10.0.2.0/24"], count.index) : "10.0.1.0/24"

availability_zone = element(data.aws_availability_zones.available.names, count.index)

map_public_ip_on_launch = true

tags = {
   Name = "Public Subnet"
 }

}

data "aws_availability_zones" "available" {

state = "available"

}


locals {

subnet_names = [for i in aws_subnet.subnet : "subnet-${i.availability_zone}"]

}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "my-igw"
 }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_as" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public_rt.id
}


