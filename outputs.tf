# Print Outputs
output "aws_vpc_id" {
  value = aws_vpc.myapp-vpc.id
}
output "aws_subnet_id" {
  value = module.myapp-subnet.subnet
}
output "aws_ami_id" {
  value = module.myapp-webserver.ami_id
}
output "aws_instance_public_ip" {
  value = module.myapp-webserver.instance_public_ip
}