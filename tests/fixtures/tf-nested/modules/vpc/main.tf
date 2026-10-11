# Minimal VPC module with no resources
terraform {
  required_version = ">= 0.13"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
