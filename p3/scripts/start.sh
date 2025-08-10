#!/bin/bash

k3d cluster create mycluster --port "8888:8888@loadbalancer"
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# # Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=60s deployment/argocd-server -n argocd

USERNAME=admin  # Fixed variable assignment
PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)  # Fixed variable assignment

kubectl port-forward -n argocd svc/argocd-server 8080:443 &

sleep 5  # Wait for port-forwarding to establish

# # LOGIN TO ARGOCD
argocd login localhost:8080 --username admin --password "$PASSWORD" --insecure

argocd app create my-app \
  --repo https://github.com/logx1/Inception-of-Things.git \
  --path p3/app-conf \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated \
  --auto-prune automated \
  --self-heal automated

echo "ArgoCD Password: $PASSWORD"