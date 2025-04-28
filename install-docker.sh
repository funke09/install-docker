#!/bin/bash

# Update package index
sudo apt-get update -y

# Install prerequisite packages
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
sudo apt-get update -y

# Install Docker Engine, containerd, and Docker Compose Plugin
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

# Install standalone Docker Compose (for compatibility)
DOCKER_COMPOSE_VERSION="v2.24.5"
sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installations
sudo docker --version
sudo docker-compose --version  # Standalone version
docker compose version        # Plugin version

# Test Docker with hello-world
sudo docker run hello-world

# Add current user to docker group
sudo usermod -aG docker $USER

# Configure Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Docker and Docker Compose installation complete!"
echo "Please log out and back in for group changes to take effect."
