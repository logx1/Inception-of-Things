#!/bin/bash

k3d cluster delete k3s-default
k3d cluster create -p 443:443 --port "8888:8888@loadbalancer"
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


kubectl apply -k . -n argocd 
kubectl apply -f ingress.yaml -n argocd

kubectl wait --for=condition=available --timeout=60s deployment/argocd-server -n argocd


PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)  # Fixed variable assignment


# # LOGIN TO ARGOCD
argocd login localhost:443 --username admin --password "$PASSWORD" --insecure

sleep 5 


argocd app create my-app \
  --repo https://github.com/logx1/Inception-of-Things.git \
  --path p3/app-conf \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated

echo "ArgoCD Password: $PASSWORD"
