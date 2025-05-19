
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
      userarn  = "arn:aws:iam::376129850044:user/DE000057"
      username = "eks-ops"
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
    bastion_ami                 = "ami-01938df366ac2d954"
    bastion_instance_class      = "t2.micro"
    bastion_monitoring          = true
    bastion_name                = "bastion"
    bastion_public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOb1npdg0OO8/I5XIpXH2046TV1ppr8WiHb2gxYLJMSwMOkr5H7eDkXd5iSGecGrAPwElQ5CBu5XERWub6BSOrgqi2bMFc6oLqxG24ARToqb99rZP4xtGSlkxTOedajP4juzhc6t0we4QtO/NiKZtSbtntAXXaw0tuZrdxhypGagJRC3pS1iqBecEnCDgiYopvLFnZsi8NQzVsgxcXnhvyWL7vqtTDrXIfpz6G7NuwA03kB0KjtGJolkACeRv/389yFgnddbbqstmYDIvqnkbOHNqhpaCPB7cdT30XsjmWSMoiEiyp06wz5Oew2fZGkis5GTxSzxSoem2FLJi9gl0VfVKiqzFd0S40Yhw8O/lkswTwZNJCtK7BDSwznJRcg4NEUmrAUPx8HpOclXmFsfeEg0M/Z4YshXVaGEjHxBHrtfbvs/hw3Qtoz/7TsMrhJVoc5DEQvluRF06VSCaBJHENtluIYvt3FSaLnAOV+CeVpU0A+Hq+cVZP7jx6YiTtluEKSOefus8F9DEtlgAO6c3FCPnBkRVfvvFisD4el6JhSHXR09PvPzpbUmbW6VPYEgwDFFxOPz4gMmgQucFzSWpxpdS9+lxOoHvBiOw5IQX1e/VTH1J0wlIdlEgxsQqQ4Qc1KJCk7K5SXSOzVmc0nzyeJvQ/KznIqQWMj56bqtqcaw== dev@dev-System-Product-Name"
    trusted_ips                 = ["0.0.0.0/0"]
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
      "func" = "demo-tf"
    }
  }
}
