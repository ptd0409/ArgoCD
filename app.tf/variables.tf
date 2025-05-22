variable "vpc_name" {
  default = "tien-dung-cluster-vpc"
}
variable "env_prefix" {

}
variable "cidrvpc" {
  default = "10.0.0.0/16"
}

variable "default_tags" {
  default = {
    Owner = "dungpt"
  }
}

variable "create_s3_bucket" {
  default = true
}

variable "vm-config" {
  default = {}
}


variable "bastion_definition" {
  description = "The definition of bastion instance"
  default     = {}
}
variable "api_gateways" {
  type = map(object({
    aws_api_gateway_rest_api_name        = string
    aws_api_gateway_rest_api_description = string
    api_gateway_protocol                 = string
    create_domain_name                   = bool
    authorizers                          = map(any)
    allow_methods                        = list(string)
    allow_origins                        = list(string)
    allow_headers                        = list(string)
    fail_on_warnings                     = bool
    stage_access_log_settings = object({
      create_log_group            = bool
      destination_arn             = string
      format                      = string
      log_group_name              = string
      log_group_skip_destroy      = bool
      log_group_retention_in_days = number
      log_group_kms_key_id        = string
      log_group_class             = string
      log_group_tags              = map(string)
    })
    routes   = map(any)
    ext-tags = map(string)
  }))
}

variable "cluster_endpoint_public_access" {

}
variable "single_nat_gateway" {

}
variable "enable_nat_gateway" {

}
variable "enable_dns_hostnames" {

}
variable "create_database_subnet_group" {

}
variable "create_database_subnet_route_table" {

}
variable "create_database_internet_gateway_route" {

}
variable "enable_flow_log" {

}
variable "create_flow_log_cloudwatch_iam_role" {

}

variable "create_flow_log_cloudwatch_log_group" {

}
variable "eks_config" {

}
variable "public_subnet_ids" {
  description = "List of public subnet IDs (used when create_vpc = false)"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (used when create_vpc = false)"
  type        = list(string)
  default     = []
}

variable "intra_subnet_ids" {
  description = "List of intra subnet IDs (used when create_vpc = false)"
  type        = list(string)
  default     = []
}
variable "existing_vpc_id" {
  description = "The ID of an existing VPC to use when create_vpc = false"
  type        = string
  default     = ""
}
variable "bastion_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the bastion host"
}
