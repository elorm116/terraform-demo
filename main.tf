# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC and Subnets
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
/*resource "aws_subnet" "myapp-subnet" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}*/

/*resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}*/
# Create SSH Key Pair

# Create Default Route Table with Route
/*resource "aws_default_route_table" "myapp-default-route-table" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-default-route-table"
  }
  
}
*/

# Use Subnet Module
module "myapp-subnet" {
  source = "./modules/subnet"

  subnet_cidr           = var.subnet_cidr
  availability_zone     = var.availability_zone
  env_prefix            = var.env_prefix
  route_cidr            = var.route_cidr
  vpc_id                = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  
}

module "myapp-webserver" {
  source = "./modules/webserver"
    vpc_id            = aws_vpc.myapp-vpc.id
    subnet_id         = module.myapp-subnet.subnet
    env_prefix        = var.env_prefix
    route_cidr        = var.route_cidr
    key_location      = var.key_location
    instance_type     = var.instance_type
    availability_zone = var.availability_zone
  
}



# Associate Route Table with Subnet
/*resource "aws_route_table_association" "myapp-subnet-association" {
  subnet_id      = aws_subnet.myapp-subnet.id
  route_table_id = aws_route_table.myapp-route-table.id
}*/

