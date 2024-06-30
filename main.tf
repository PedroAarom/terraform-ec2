module "vpc" {
    source = "./modules/vpc"
}

module "compute" {
    source = "./modules/compute"
    myvpc = module.vpc.vpc_id
    subnet = module.vpc.subnet_id
}
output "subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.subnet_id
}

output "subnet_names" {
    value = module.vpc.subnet_names
}