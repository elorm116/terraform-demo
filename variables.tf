variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "availability_zone" {}
variable "env_prefix" {}
variable "instance_type" {}
variable "key_location" {}
variable "route_cidr" {}
variable "private_key_location" {}