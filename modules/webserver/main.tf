resource "aws_key_pair" "ssh-key" {
  key_name   = "server_key"
  public_key = file(var.key_location)
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.route_cidr] #Best practice is to limit the number of IP ranges that can access your resources.
  }
    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.route_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.route_cidr] 
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

data "aws_ami" "amazon_linux_image_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
# Launch EC2 Instance
resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.amazon_linux_image_2023.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.availability_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("${path.module}/entry-script.sh") #best practice to use user data scripts for initial setup

  tags = {
    Name = "${var.env_prefix}-instance"
  }
}