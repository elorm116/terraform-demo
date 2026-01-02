# Define Variables
variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
}
variable "availability_zone" {
  description = "The availability zone for the subnet"
}
variable "env_prefix" {
  description = "The environment where resources will be created"
}
variable "route_cidr" {
  description = "The destination CIDR block for the route"
  type        = string
  default     = "0.0.0.0/0"
}
variable "vpc_id" {
  description = "The ID of the VPC"
}
variable "default_route_table_id" {
  description = "The ID of the default route table"
}