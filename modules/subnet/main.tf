resource "aws_subnet" "myapp-subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# Create Default Route Table with Route
resource "aws_default_route_table" "myapp-default-route-table" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-default-route-table"
  }
  
}
