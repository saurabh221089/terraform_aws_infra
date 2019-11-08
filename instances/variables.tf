variable "region" {
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "remote_state_bucket" {
  default     = "fileversion"
  description = "Bucket name storing remote state"
}

variable "remote_state_key" {
  default     = "infrastructure/terraform.tfstate"
  description = "Path of the file storing remote state"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Type of EC2 instance"
}

variable "keypair" {
  default     = "ec2-ssh-key"
  description = "Name of the SSH keypair"
}

variable "max_instance_size" {
  default     = "10"
  description = "Maximum number of instances"
}

variable "min_instance_size" {
  default     = "2"
  description = "Minimum number of instances"
}

variable "PHONE_NUMBER" {
  default = "+919953509598"
}

