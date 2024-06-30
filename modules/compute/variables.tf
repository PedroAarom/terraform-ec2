variable "myvpc" {
  description = "ID of the VPC"
}
variable "subnet" {
  description = "ID of the public subnet"
  
}
variable "environment" {

description = "The environment to deploy to"

type = string

default = "dev"

}