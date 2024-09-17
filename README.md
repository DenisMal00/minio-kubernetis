# MinIO Kubernetes Deployment with Admin User Creation Script

This repository provides a Kubernetes setup for MinIO

## Prerequisites

- Minikube.
- Helm installed for deploying MinIO.
- `kubectl` configured to interact with your Kubernetes cluster.

## Setup and Run

### Step 1: Start Minikube

- Start Minikube with a custom configuration to ensure enough resources for MinIO:

     ```bash
     minikube start --cpus=4 --memory=7000
     ```

   This starts Minikube with 4 CPUs and 8 GB of memory, which is typically enough for running MinIO.

### Step 2: Install MinIO Operator and Tenant
- Add the MinIO Operator Helm repository:

```bash
helm repo add minio-operator https://operator.min.io/
helm repo update
```
- Install the MinIO Operator:

```bash
Copia codice
helm install minio-operator minio-operator/minio-operator \
    --namespace minio-operator --create-namespace
```

- Create the minio namespace:
  
```bash
kubectl create namespace minio
```

- Deploy the MinIO Tenant: Install the MinIO Tenant using Helm and the provided values.yaml configuration:

```bash
helm install minio-tenant minio-operator/minio-tenant \
    --namespace minio -f values.yaml
```

### Step 2: Apply tls secret
- To ensure proper SSL/TLS handling, you need to make sure the MinIO Tenant's CA certificate is trusted.

```bash
kubectl apply -f secret-minio-tls.yaml
```
### Step 3: Run Minio
- Add miniostorage.com to /etc/hosts as localhost

- Enable ingress addon
  
```bash
minikube addons enable ingress
```

- Create a Minikube Tunnel
```bash
minikube tunnel
```

- Type on your browser
```bash
https://miniostorage.com
```
