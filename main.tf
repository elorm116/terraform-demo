# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# 1. Create VPC and Subnet
resource "aws_vpc" "myapp-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Good practice for EC2 access
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.public_subnets[0]
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}

# 2. Internet Gateway & Routing
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = var.route_cidr # Traffic heading to internet
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-route-table"
  }
}

resource "aws_route_table_association" "myapp-subnet-association" {
  subnet_id      = aws_subnet.myapp-subnet.id
  route_table_id = aws_route_table.myapp-route-table.id
}

# 3. Security Group
resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting to your IP
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

# 4. SSH Key and AMI
resource "aws_key_pair" "ssh-key" {
  key_name   = "server_key"
  public_key = file(var.key_location)
}

data "aws_ami" "amazon_linux_image_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# 5. EC2 Instance & Ansible Trigger
resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.amazon_linux_image_2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.myapp-subnet.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.availability_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.env_prefix}-instance"
  }

  provisioner "remote-exec" {
    inline = ["echo 'SSH is up, starting Ansible...'"]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_location)
      host        = self.public_ip
    }
  }

  # Provisioner to trigger Ansible
  provisioner "local-exec" {
    working_dir = "/Users/anthonyzottor/DevOpsLearning/ansible-project/ec2-server-config"
    command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.private_key_location} --user ec2-user --vault-password-file .vault_pass docker-deploy.yaml"
  }
}