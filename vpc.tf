/* Get all zones of region */
data "aws_availability_zones" "available" {}

/* Module VPC */
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name            = var.name_vpc
  cidr            = "10.0.0.0/20"                               // 4094 free ips
  azs             = data.aws_availability_zones.available.names //Deploy en all availability zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]              // "10.0.3.0/24" recomendation has free subnets .... only 254 free ips
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]              // "10.0.6.0/24"
  // add support to database database_subnets     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  // in this challenge does not need database subnet 
  // create_database_subnet_group = true

  // it's possible custome each tags
  tags = var.tags

  public_subnet_tags = var.tags

  private_subnet_tags = var.tags
}