# Inception of Things

This project is a collection of hands-on labs for learning about cloud-native technologies, with a focus on Kubernetes and GitOps. The project is divided into several parts, each demonstrating a different aspect of modern application deployment and management.

The labs progress from basic Kubernetes cluster setup to advanced GitOps workflows with CI/CD integration. The technologies used include:

- **Virtualization and Containerization:** Vagrant, Docker
- **Kubernetes:** k3s, k3d
- **Configuration Management:** Kustomize
- **CI/CD and GitOps:** ArgoCD, GitLab
- **Application Development:** Django

---

## Part 1: Basic 2-Node K3s Cluster with Vagrant

The `p1` directory contains a Vagrantfile and provisioning scripts to create a simple 2-node k3s cluster.

- **Master Node:** `abdel-ouS` (192.168.56.10)
- **Worker Node:** `abdel-ouSW` (192.168.56.11)

### Usage

1.  Navigate to the `p1` directory:
    ```bash
    cd p1
    ```
2.  Start the Vagrant environment:
    ```bash
    vagrant up
    ```

This will create and provision two virtual machines, a master and a worker, and automatically join the worker to the master's cluster.

---

## Part 2: Application Deployment with Vagrant and K3s

The `p2` directory demonstrates how to deploy multiple applications to a single-node k3s cluster. The provisioning script in this part automatically deploys three sample applications and sets up an Ingress to route traffic to them.

### Deployed Applications

- **app1:** A "hello-kubernetes" application, accessible at `http://app1.com`.
- **app2:** Another "hello-kubernetes" application, accessible at `http://app2.com`.
- **app3:** A third "hello-kubernetes" application, which acts as the default backend for any other traffic.

### Usage

1.  Navigate to the `p2` directory:
    ```bash
    cd p2
    ```
2.  Start the Vagrant environment:
    ```bash
    vagrant up
    ```

### Note on the `volumes` Directory

The `p2` directory contains a `volumes` directory with `index.html` files for three nginx applications. However, the deployed applications use the `paulbouwer/hello-kubernetes` image, not nginx. This directory is not currently used by the Kubernetes configuration and appears to be a remnant of a previous or alternative implementation.

---

## Part 3: GitOps with K3d, Docker, and ArgoCD

The `p3` directory showcases a complete GitOps workflow for deploying a custom Django application.

### Workflow

1.  **Local Development:** The `simple-app` directory contains the source code for a Django application and a `Dockerfile` to containerize it.
2.  **Cluster Setup:** The `scripts/start.sh` script automates the creation of a k3d cluster.
3.  **ArgoCD Installation:** The script then installs ArgoCD into the cluster.
4.  **Application Deployment:** Finally, it configures ArgoCD to watch a GitHub repository. ArgoCD automatically deploys the Django application based on the manifests in the `p3/app-conf` directory of the repository.

### Usage

1.  Navigate to the `p3/scripts` directory:
    ```bash
    cd p3/scripts
    ```
2.  Run the `start.sh` script:
    ```bash
    ./start.sh
    ```

This will set up the entire environment and deploy the application. The ArgoCD password will be printed to the console, and the ArgoCD UI will be accessible at `localhost:8080`. The Django application will be available at `localhost:8888`.

---

## Bonus: Self-Contained CI/CD and GitOps with GitLab

The `bonus` directory extends the GitOps workflow from `p3` by introducing GitLab into the mix. This creates a fully self-contained platform for CI/CD and GitOps.

### Workflow

The `bonus` section automates the deployment of GitLab within the Kubernetes cluster. A script is then used to:

1.  Create a new user and an access token in GitLab.
2.  Create a new public repository.
3.  Push the application's Kubernetes manifests to the new repository.

ArgoCD is then configured to watch this new GitLab repository instead of the public GitHub repository. This means that the entire lifecycle of the application, from source code management to deployment, is handled within the local cluster.

### Usage

The scripts in the `bonus` directory are designed to be used in a similar way to `p3`, but they require a running GitLab instance. The `gitlab/gitlab.yaml` file can be used to deploy GitLab to the cluster. The `gitlab/script.sh` is intended to be run within the GitLab pod to configure the repository.

---

## Conclusion

This project provides a comprehensive, hands-on introduction to a variety of cloud-native tools and practices. By working through the different parts of this project, you can gain practical experience with Kubernetes, GitOps, and CI/CD, and learn how to build and deploy applications in a modern, automated fashion.
