# Define Variables
variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"  
}
variable "availability_zone" {
  description = "The availability zone for the subnet"
}
variable "env_prefix" {
  description = "The environment where resources will be created"
}
variable "instance_type" {
  description = "The EC2 instance type"
}

variable "key_location" {
  description = "The location of the SSH public key"
}
variable "private_key_location" {
  description = "The location of the SSH private key"
}

variable "route_cidr" {
  description = "The destination CIDR block for the route"
  type        = string
  default     = "0.0.0.0/0"
}
