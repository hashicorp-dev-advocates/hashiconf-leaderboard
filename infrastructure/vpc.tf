data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  subnets = cidrsubnets(var.vpc_cidr_block, 8, 8, 8, 8, 8, 8, 8, 8, 8)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name            = var.name
  cidr            = var.vpc_cidr_block
  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(local.subnets, 0, 3)
  public_subnets  = slice(local.subnets, 3, 6)

  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  database_subnets                   = slice(local.subnets, 6, 9)
  manage_default_route_table         = true
  default_route_table_tags           = { DefaultRouteTable = true }

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.name}-leaderboard"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.database.id]
}