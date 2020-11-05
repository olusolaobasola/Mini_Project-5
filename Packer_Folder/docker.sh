#! /bin/bash
sudo yum update
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo cp /usr/local/bin/docker-compose  /usr/bin/