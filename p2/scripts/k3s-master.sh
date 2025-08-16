#!/bin/bash
curl -sfL https://get.k3s.io | sh -

# Wait for the K3s server to start
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    echo "Waiting for k3s server to start..."
    sleep 2
done

echo "K3s server started successfully."

# Wait for the Kubernetes API server to be ready
echo "Waiting for Kubernetes API server to be ready..."
until sudo k3s kubectl get nodes &> /dev/null; do
    sleep 10
done

# Wait for default service account to be created
echo "Waiting for default service account to be created..."
until sudo k3s kubectl get serviceaccount default &> /dev/null; do
    sleep 2
done

echo "Kubernetes API server is ready."

# Deploy applications
sudo k3s kubectl apply -f /vagrant/confs/app1.yaml
sudo k3s kubectl apply -f /vagrant/confs/app2.yaml
sudo k3s kubectl apply -f /vagrant/confs/app3.yaml
sudo k3s kubectl apply -f /vagrant/confs/ingress.yaml

sudo echo "192.168.56.110 app1.com" | sudo tee -a /etc/hosts
sudo echo "192.168.56.110 app2.com" | sudo tee -a /etc/hosts

echo "Applications deployed successfully."