#!/bin/bash

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install Git
sudo apt install git -y

# Install Docker
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# Install Java 17
sudo apt install openjdk-17-jdk -y

# Install Maven
sudo apt install maven -y

# Install unzip (needed for AWS CLI)
sudo apt install unzip -y

# Install AWS CLI (fixed way for Ubuntu)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify AWS CLI version
aws --version

# Install kubectl (fixed way)
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify kubectl version
kubectl version --client

# Install Trivy
sudo apt install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y

# Verify Trivy version
trivy --version
echo "All tools installed successfully on Ubuntu"
