#!/bin/bash

# Update package list
sudo apk update

# Install required packages
sudo apk add curl bash docker

# Enable and start Docker service
sudo rc-update add docker default
sudo service docker start

# Install k3d
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify installation
k3d --version
kubectl version --client

# Create a k3d cluster
k3d cluster create mycluster --port 80:80@loadbalancer

sudo kubectl apply -f /vagrant/pod.yaml

