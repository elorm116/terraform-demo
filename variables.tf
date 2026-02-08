variable "key_location" {
  description = "Path to public SSH key"
  type        = string
}

variable "private_key_location" {
  description = "Path to private SSH key"
  type        = string
}

variable "availability_zone" {
  description = "Preferred availability zone"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix"
  type        = string
}

variable "instance_type" {
  description = "Default instance type"
  type        = string
}

variable "route_cidr" {
  description = "Default route CIDR"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "myapp-eks-cluster"
}

variable "aws_region" {
  description = "AWS region for the EKS cluster"
  type        = string
  default     = "us-east-1"
}

