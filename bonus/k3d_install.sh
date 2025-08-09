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
# k3d cluster create mycluster --port 80:80@loadbalancer --port 443:443@loadbalancer --port 8080:8080@loadbalancer --port 8000:8000@loadbalancer

k3d cluster create mycluster --port 80:80 --port "443:443@loadbalancer" --port 8080:8080 --port 8000:8000 --port 32080:32080 --port 32443:32443

# sudo kubectl apply -f /vagrant/pod.yaml

# helm installation

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# # Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=60s deployment/argocd-server -n argocd

USERNAME=admin  # Fixed variable assignment
PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)  # Fixed variable assignment

kubectl port-forward -n argocd svc/argocd-server 8080:443 &

