module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  create_vpc = false
  manage_default_route_table = false
  manage_default_security_group = false
  manage_default_network_acl = false
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}
