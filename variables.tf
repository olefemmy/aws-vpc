variable "environment" {
  description = "Environment name"
}

variable "service_name" {
  description = "Name of project or service that this VPC infrastructure relates to."
  default     = ""
}

variable "account" {
  description = "The name of the account the VPC will be created in"
  default     = ""
}

variable "vpc_cidr_block" {
  description = "VPC Cidr Block. This is related to the vpc_subnet_bitmask variable."
}

variable "az_limit" {
  description = "A limit of availability zones to deploy to."
  default     = 2
}

variable "enable_flow_log" {
  description = "Enable flow log for the VPC?"
  default     = 0
}

variable "delete_default_sg_rules" {
  description = "Delete all rules from the default security group?"
  default     = 0
}

variable "tags" {
  description = "A map of additional tags to apply to resources in this module"
  default     = {}
}

variable "flow_log_retention_in_days" {
  description = "Number of days to retain flow logs in CloudWatch"
  default     = 7
}
