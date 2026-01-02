variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "env_prefix" {
  description = "The environment prefix"
  type        = string
}

variable "route_cidr" {
  description = "The CIDR block for the route"
  type        = string
}

variable "key_location" {
  description = "The file path to the public key"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone"
  type        = string
}