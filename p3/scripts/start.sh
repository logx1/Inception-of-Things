#!/bin/bash

k3d cluster delete --all
k3d cluster create -p 443:443 --port "8888:8888@loadbalancer"
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


kubectl apply -k ../confs -n argocd 
kubectl apply -f ../confs/ingress.yaml -n argocd

kubectl wait --for=condition=available --timeout=60s deployment/argocd-server -n argocd


PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)  # Fixed variable assignment

sleep 10
# # LOGIN TO ARGOCD

echo "Waiting for ArgoCD to be ready..."

echo "ArgoCD Password: $PASSWORD"

echo "Logging in to ArgoCD..."
argocd login localhost:443 --username admin --password "$PASSWORD" --insecure

sleep 5 


argocd app create my-app \
  --repo https://github.com/logx1/k8s_app_abdel-ou.git \
  --path app-conf \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated \
  --auto-prune \
  --self-heal

echo "ArgoCD Password: $PASSWORD"
