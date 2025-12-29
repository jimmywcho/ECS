provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
}

module "services" {
  source = "./modules/services"

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  public_subnets  = module.network.public_subnets
}