# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Create VPC and Subnets
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "dev-vpc"
    }
}
resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "dev-subnet"
  }
}
#"10.0.1.0/24"
# data "aws_vpc" "default" {
#   default = true
# }
# resource "aws_subnet" "dev-subnet-1" {
#   vpc_id            = data.aws_vpc.default.id
#   cidr_block        = "172.31.16.0/20"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "dev-subnet-1"
#     }
# }

#Print Outputs
output "aws_vpc_id" {
  value = aws_vpc.dev-vpc.id
}
output "aws_subnet_id" {
  value = aws_subnet.dev-subnet.id
}