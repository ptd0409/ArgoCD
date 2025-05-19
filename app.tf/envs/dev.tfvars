
env_prefix                             = "dev"
vpc_name                               = "dev_env"
cidrvpc                                = "10.0.0.0/16"
enable_nat_gateway                     = true
single_nat_gateway                     = true
enable_dns_hostnames                   = true
create_database_subnet_group           = true
create_database_subnet_route_table     = true
create_database_internet_gateway_route = true
enable_flow_log                        = true
create_flow_log_cloudwatch_iam_role    = true
create_flow_log_cloudwatch_log_group   = true
eks_config = {
  cluster_name                                   = "ptdeks"
  cluster_version                                = "1.30"
  min_size                                       = 3
  max_size                                       = 9
  eks_managed_node_group_defaults_instance_types = ["t2.medium", "t2.large"]
  instance_type                                  = "t2.medium"
  instance_types                                 = ["t2.medium", "t2.large"]
  manage_aws_auth_configmap                      = true
  endpoint_public_access                         = true
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::376129850044:DE000057/eks-ops"
      username = "eks-ops"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::376129850044:DE000057/devops"
      username = "devops"
      groups   = ["system:masters"]
    },
  ]
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"],
  eks_cw_logging                       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
vm-config = {
  vm1 = {
    instance_type = "t2.small",
    tags = {
      "ext-name" = "vm2"
      "funct"    = "purpose test"
    }
  },
  vm2 = {
    instance_type = "t2.medium",
    tags          = {}
  }
}
bastion_definition = {
  "bastion" = {
    associate_public_ip_address = false
    bastion_ami                 = ""
    bastion_instance_class      = "t2.micro"
    bastion_monitoring          = true
    bastion_name                = "bastion"
    bastion_public_key          = ""
    trusted_ips                 = [""]
    user_data_base64            = null
    ext-tags = {
      "fucnt" = "demo-tf"
    }
  }
}
cluster_endpoint_public_access = true

api_gateways = {
  "rest_weather" = {
    aws_api_gateway_rest_api_name        = "blooperry-simple"
    aws_api_gateway_rest_api_description = "porpose for test the blooperry"
    api_gateway_protocol                 = "HTTP"
    authorizers                          = {}
    allow_methods                        = ["POST", "GET"]
    allow_origins                        = ["*"]
    allow_headers                        = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    fail_on_warnings                     = false
    create_domain_name                   = false
    routes = {
      "GET /" = {
        integration = {
          type   = "HTTP_PROXY"
          uri    = "https://blooperry.com"
          method = "GET"
        }
      }
    }
    ext-tags = {
      "fucnt" = "demo-tf"
    }
  }
}
