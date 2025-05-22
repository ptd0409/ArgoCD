

locals {
  azs        = length(data.aws_availability_zones.available.names)
  account_id = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source = "./_modules/network"

  create_vpc      = false
  existing_vpc_id = var.existing_vpc_id  
  vpc_name        = "my-existing-vpc"        
  vpc_cidr        = "10.0.0.0/16"            

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #intra_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids
  enable_nat_gateway                     = false
  single_nat_gateway                     = false
  enable_dns_hostnames                   = true
  create_database_subnet_group           = false
  create_database_subnet_route_table     = false
  create_database_internet_gateway_route = false
  enable_flow_log                        = false
  create_flow_log_cloudwatch_iam_role    = false
  create_flow_log_cloudwatch_log_group   = false

  cluster_name = var.eks_config.cluster_name
  default_tags = var.default_tags
}


#CREATE THE EKS CLUSTER
module "eks" {
  depends_on = [
    module.vpc
  ]
  source                                         = "./_modules/eks"
  existing_vpc_id                                = var.existing_vpc_id
  vpc_id                                         = var.existing_vpc_id
  private_subnet_ids                             = module.vpc.vpc_private_subnet_ids
  intranet_subnet_ids                            = module.vpc.intra_subnet_ids
  env_prefix                                     = var.env_prefix
  cluster_name                                   = var.eks_config.cluster_name
  cluster_version                                = var.eks_config.cluster_version
  min_size                                       = var.eks_config.min_size
  max_size                                       = var.eks_config.max_size
  eks_managed_node_group_defaults_instance_types = var.eks_config.eks_managed_node_group_defaults_instance_types
  manage_aws_auth_configmap                      = var.eks_config.manage_aws_auth_configmap
  instance_types                                 = var.eks_config.instance_types
  endpoint_public_access                         = var.eks_config.endpoint_public_access
  cluster_endpoint_public_access_cidrs           = var.eks_config.cluster_endpoint_public_access_cidrs
  eks_cw_logging                                 = var.eks_config.eks_cw_logging
  default_tags                                   = var.default_tags
}


#CALLING MODULE EC2 TO CREATE THE EC2 INSTANCE 

module "ec2" {
  depends_on = [
    module.vpc
  ]
  source                      = "./_modules/ec2"
  for_each                    = var.bastion_definition
  vpc_id                      = module.vpc.vpc_id
  bastion_instance_class      = each.value.bastion_instance_class
  bastion_name                = each.value.bastion_name
  bastion_public_key          = each.value.bastion_public_key
  trusted_ips                 = toset(each.value.trusted_ips)
  user_data_base64            = each.value.user_data_base64
  bastion_ami                 = each.value.bastion_ami
  associate_public_ip_address = each.value.associate_public_ip_address
  public_subnet_id = module.vpc.vpc_public_subnet_ids[0] # just hardcode index or map it
  bastion_security_group_ids  = each.value.bastion_security_group_ids
  bastion_monitoring          = each.value.bastion_monitoring
  default_tags = merge(
    var.default_tags,
    each.value.ext-tags,
    {
      "ext-env" : terraform.workspace
    }
  )

}

#CALLING MODULE API GATEWAY
module "apigateway" {
  source                               = "./_modules/apigateway"
  for_each                             = var.api_gateways
  aws_api_gateway_rest_api_name        = each.value.aws_api_gateway_rest_api_name
  aws_api_gateway_rest_api_description = each.value.aws_api_gateway_rest_api_description
  api_gateway_protocol                 = each.value.api_gateway_protocol
  create_domain_name                   = each.value.create_domain_name
  authorizers                          = each.value.authorizers
  routes                               = each.value.routes
  allow_methods                        = each.value.allow_methods
  allow_headers                        = each.value.allow_headers
  allow_origins                        = each.value.allow_origins
  fail_on_warnings                     = each.value.fail_on_warnings
  access_log_settings = {
    destination_arn = each.value.stage_access_log_settings.destination_arn
    format          = each.value.stage_access_log_settings.format
  }
  tags = merge(
    var.default_tags,
    each.value.ext-tags,
    {
      "ext-env" : terraform.workspace
    }
  )
}
