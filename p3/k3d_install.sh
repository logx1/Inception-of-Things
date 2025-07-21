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

# Verify installations
docker --version
k3d --version