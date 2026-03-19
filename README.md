# Inception of Things

This repository is a learning project that walks through progressively more advanced Kubernetes setups using lightweight tooling (K3s/K3d) and GitOps (ArgoCD). It is split into three parts:

## Part 1 (p1) — Basic K3s Cluster
- Uses Vagrant to create two Alpine Linux VMs: a **master** and a **worker**.
- Installs **K3s** on the master and joins the worker to the cluster.
- Goal: understand a minimal multi-node K3s setup.

Key files:
- `p1/Vagrantfile`
- `p1/k3s-master.sh`
- `p1/k3s-worker.sh`

## Part 2 (p2) — Multi-App Deployment + Ingress
- Uses a single K3s VM.
- Deploys three sample apps and exposes them through a Kubernetes **Ingress**.
- Demonstrates services, deployments, and routing by hostname.

Key files:
- `p2/app1.yaml`, `p2/app2.yaml`, `p2/app3.yaml`
- `p2/ingress.yaml`
- `p2/k3s-master.sh`

## Part 3 (p3) — GitOps with K3d + ArgoCD
- Uses **k3d** (K3s-in-Docker) and **ArgoCD** for GitOps.
- Builds a small Django app container and deploys it via ArgoCD sync.
- Demonstrates declarative deployments and automated reconciliation.

Key files:
- `p3/k3d_install.sh`
- `p3/scripts/start.sh`
- `p3/app-conf/pod.yaml`
- `p3/simple-app/Dockerfile`

---

## Prerequisites
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- (For p3) Docker installed on the VM for k3d

## Quick Start
Each part is independent and runs its own VM:

```bash
cd p1
vagrant up
```

```bash
cd p2
vagrant up
```

```bash
cd p3
vagrant up
./scripts/start.sh
```

For p2, add a hosts entry so local DNS resolves the ingress:
```
192.168.56.10 app1.com app2.com
```

---

## What You Learn
- Setting up K3s clusters (single and multi-node)
- Deploying multiple apps and routing traffic with Ingress
- Managing deployments with GitOps workflows using ArgoCD
