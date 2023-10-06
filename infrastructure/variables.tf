variable "region" {
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "tf_public_subnet1_cidr" {
  default     = "10.0.1.0/24"
  description = "Public Subnet 1 CIDR"
}

variable "tf_public_subnet2_cidr" {
  default     = "10.0.2.0/24"
  description = "Public Subnet 2 CIDR"
}