#!/bin/bash
set -eux
echo "User data started at $(date)"

dnf install -y docker
systemctl enable --now docker
systemctl start docker
usermod -aG docker ec2-user

docker pull nginx
docker run -d -p 8080:80 --name nginx nginx

echo "User data finished at $(date)"