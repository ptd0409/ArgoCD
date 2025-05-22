variable "vpc_name" {}
variable "vpc_cidr" {}

variable "enable_nat_gateway" {}
variable "single_nat_gateway" {}
variable "enable_dns_hostnames" {}

variable "create_database_subnet_group" {}
variable "create_database_subnet_route_table" {}
variable "create_database_internet_gateway_route" {}

variable "enable_flow_log" {}
variable "create_flow_log_cloudwatch_iam_role" {}
variable "create_flow_log_cloudwatch_log_group" {}

variable "default_tags" {}
variable "cluster_name" {

}
variable "existing_vpc_id" {
  description = "The ID of an existing VPC to use"
  type        = string
}
variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = ""
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "intra_subnets" {
  type    = list(string)
  default = []
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
