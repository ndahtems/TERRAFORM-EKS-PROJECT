provider "aws" {
  region = "eu-central-1"

}


data "aws_availability_zones" "azs" {
}


module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name            = "myapp-vpc"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets  = var.public_subnets_cidr_blocks
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  # enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"

  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernets.io/role/elb"                   = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernets.io/role/internal-elb"          = 1
  }

}