variable "project_a_id" {
  type        = string
  description = "GCP Project ID"
}

variable "project_b_id" {
  type        = string
  description = "GCP Project ID"
}

variable "vpc_a_name" {
  type        = string
  description = "VPC A Name. Default = vpc_a"
  default     = "vpc-a"
}

variable "vpc_b_name" {
  type        = string
  description = "VPC B Name. Default = vpc_b"
  default     = "vpc-b"
}

variable "vpc_a_subnet_name" {
  type        = string
  description = "VPC A Subnet Name. Default = vpc_a_subnet_a"
  default     = "vpc-a-subnet-a"
}

variable "vpc_a_subnet_region" {
  type        = string
  description = "VPC A Subnet Region. Default = us-central1"
  default     = "us-central1"
}

variable "vpc_a_subnet_cidr" {
  type        = string
  description = "VPC A Subnet CIDR. Default = 10.10.10.0/24"
  default     = "10.10.10.0/24"
}

variable "vpc_b_subnet_name" {
  type        = string
  description = "VPC B Subnet Name. Default = vpc_b_subnet_b"
  default     = "vpc-b-subnetb"
}

variable "vpc_b_subnet_region" {
  type        = string
  description = "VPC B Subnet Region. Default = us-central1"
  default     = "us-central1"
}

variable "vpc_b_subnet_cidr" {
  type        = string
  description = "VPC B Subnet CIDR. Default = 10.10.20.0/24"
  default     = "10.10.20.0/24"
}

variable "mtu" {
  type        = number
  description = "VCP MTU. Options 1460 or 1500. Default = 1500"
  default     = 1500
}

variable "ad_peering_name_a" {
  type        = string
  description = "Name for managed AD Peering. Default = my-peering-a"
  default     = "my-peering-a"
}

variable "ad_peering_name_b" {
  type        = string
  description = "Name for managed AD Peering. Default = my-peering-b"
  default     = "my-peering-b"
}

variable "ad_trust_secret" {
  type        = string
  description = "Active Directory trust secret"
}

variable "ad_trust_type" {
  type        = string
  description = "Active Directory Trust Type. Options 'FOREST' or 'EXTERNAL'. Default = 'FOREST'"
  default     = "FOREST"
}
