#!/bin/bash

# Update the package index
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Initialize Docker Swarm
sudo docker swarm init

# Install Docker Compose
DOCKER_COMPOSE_VERSION="1.29.2" # Change this to the desired version
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installations
echo "Docker version:"
docker --version
echo "Node.js version:"
node -v
echo "npm version:"
npm -v
echo "Docker Compose version:"
docker-compose --version
