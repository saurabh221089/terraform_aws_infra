variable "region" {
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "remote_state_bucket" {
  default     = "terraform-sub"
  description = "Bucket name storing remote state"
}

variable "remote_state_key" {
  default     = "tfstate"
  description = "Path of the file storing remote state"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Type of EC2 instance"
}

variable "keypair" {
  default     = "prod-instance"
  description = "Name of the SSH keypair"
}

variable "max_instance_size" {
  default     = "3"
  description = "Maximum number of instances"
}

variable "min_instance_size" {
  default     = "1"
  description = "Minimum number of instances"
}

