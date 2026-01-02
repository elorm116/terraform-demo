output "ami_id" {
  value = data.aws_ami.amazon_linux_image_2023.id
}

output "instance_public_ip" {
  value = aws_instance.myapp-server.public_ip
}