
env_prefix                             = "dev"
vpc_name                               = "tien-dung-cluster-vpc"
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
    bastion_public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1W4D3jQZ6HTPFwAgNEDdyUmPiTl92JwzomBLFnSEK6xBC0K9QCsOT0sItASrnAkSywmRAMrJ90dvIFLzAcegMaR2s0bEIUxYFoTS5mYNXSWF5TBkj1eeIhYx9x6KcGRnleId0oaukwGcgjnNZ+08hgkB7+xfUofJsTboJkkKXpEHQ1uN9kVXIMzLibfd2wrrppjqBhY5figAnZktaP4GJYM4gaUa/M6qA3IujWvfGwUDn89yCy3Ra/nkiT48/gAOo6Uh45/56C3IP93c+ct9X4fxR/F5Yq4Wh5TNr427QbleXfBx1vSIVu947kBOhHEsNGJaFmz31n7Y0QJ+q+cviSgCydd3FvMwdRYAv6UVGsykM1jn3YW8dPNwXmznyrpZd5mLi6vlzIxB7DZJr6AA8HPM/7hCW8kaqwshxjxjNftsWMSzAraxoNYCuXfQhU1NrwbDpqs+sTqolOa2/nxHQ1IxqR5r8xc3GzXvLYn76qwbrTwAJm2FHaLzYiT1mexM= ptdzung@DESKTOP-78QNPM6"
    trusted_ips                 = ["0.0.0.0/0"]
    bastion_security_group_ids  = ["sg-0f8f54f75767af3f4"]
    user_data_base64            = null
    ext-tags = {
      "fucnt" = "demo-tf"
    }
  }
}
cluster_endpoint_public_access = true

api_gateways = {
  "bloop" = {
    aws_api_gateway_rest_api_name        = "blooperry-simple"
    aws_api_gateway_rest_api_description = "porpose for test the blooperry"
    api_gateway_protocol                 = "HTTP"
    authorizers                          = {}
    allow_methods                        = ["POST", "GET"]
    allow_origins                        = ["*"]
    allow_headers                        = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    fail_on_warnings                     = false
    create_domain_name                   = false
    stage_access_log_settings = {
      create_log_group      = false
      destination_arn       = "arn:aws:logs:ap-southeast-1:376129850044:log-group:/aws/apigateway/blooperry-simple/default"
      format                = null
      log_group_name        = "/aws/apigateway/blooperry-simple/default"
      log_group_skip_destroy = true
      log_group_retention_in_days = null
      log_group_kms_key_id  = null
      log_group_class       = "STANDARD"
      log_group_tags        = {}
    }
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

# Use an existing VPC
create_vpc      = false
existing_vpc_id = "vpc-07b082b227fc686bc"

# Add manually mapped subnet IDs
public_subnet_ids = [
  "subnet-0dad9d6b4ce07697b",  
  "subnet-02dab95285425bbbc",
  "subnet-06f3d717589fc8d2e"
]

private_subnet_ids = [
  "subnet-0f42ab9aee7c981b6",
  "subnet-0122879fbc140c937", 
  "subnet-061f3cdd451d77a55"
]

