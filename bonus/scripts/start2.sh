#!/bin/bash

k3d cluster delete --all
k3d cluster create -p 443:443 --port "8888:8888@loadbalancer" --port "8080:8080@loadbalancer" --port "8443:8443@loadbalancer" --port "2222:2222@loadbalancer"
kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


kubectl apply -k . -n argocd 
kubectl apply -f ingress.yaml -n argocd

kubectl wait --for=condition=available --timeout=60s deployment/argocd-server -n argocd


PASSWORD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)  # Fixed variable assignment

sleep 10
# # LOGIN TO ARGOCD
argocd login localhost:443 --username admin --password "$PASSWORD" --insecure

sleep 5 


# argocd app create my-app \
#   --repo https://github.com/logx1/Inception-of-Things.git \
#   --path p3/app-conf \
#   --dest-server https://kubernetes.default.svc \
#   --dest-namespace dev \
#   --sync-policy automated \
#   --auto-prune \
#   --self-heal


argocd app create gitlab \
  --repo https://github.com/logx1/Inception-of-Things.git \
  --path bonus/gitlab \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace gitlab \
  --sync-policy automated \
  --auto-prune \
  --self-heal

echo "ArgoCD Password: $PASSWORD"

# keep curl http://localhost:8080/ after he response with 200 OK
while true; do
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/users/sign_in
)
  if [ "$RESPONSE" -eq 200 ]; then
    echo "ArgoCD is ready!"
    break
  else
    echo "Waiting for ArgoCD to be ready... (HTTP status: $RESPONSE)"
    sleep 5
  fi
done

sleep 10

kubectl cp /Users/abdel-ou/Desktop/Inception-of-Things/bonus/gitlab/script.sh gitlab/gitlab-pod:/etc/gitlab/script.sh

kubectl cp /Users/abdel-ou/Desktop/Inception-of-Things/bonus/app-conf/pod.yaml gitlab/gitlab-pod:/etc/gitlab/pod.yaml

sleep 5

kubectl exec -n gitlab -it gitlab-pod -- bash -c "chmod +x /etc/gitlab/script.sh && /etc/gitlab/script.sh"

sleep 10

argocd login localhost:443 --username admin --password "$PASSWORD" --insecure

argocd app create my-app \
  --repo http://localhost:8080/abdel-ou/django-app-gitlab.git \
  --path config \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated \
  --auto-prune \
  --self-heal