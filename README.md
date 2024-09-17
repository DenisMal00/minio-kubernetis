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
minikube start --cpus=4 --memory=7192
```

   This starts Minikube with 4 CPUs and 7 GB of memory, which is typically enough for running MinIO.

### Step 2: Install MinIO Operator
- Add the MinIO Operator Helm repository:

```bash
helm repo add minio-operator https://operator.min.io/
helm repo update
```
- Install the MinIO Operator:

```bash
helm install \
  --namespace minio-operator \
  --create-namespace \
  operator minio-operator/operator
```
### Step 3: Install MinIO Tenant
- Create the minio namespace:
  
```bash
kubectl create namespace minio
```
- Apply tls secret
  To ensure proper SSL/TLS handling, you need to make sure the MinIO Tenant's CA (myCA.crt in certs) certificate is trusted.

```bash
kubectl apply -f secret-minio-tls.yaml
```

- Deploy the MinIO Tenant: Install the MinIO Tenant using Helm and the provided values.yaml configuration:

```bash
helm install minio-tenant minio-operator/tenant \
    --namespace minio -f values.yaml
```
Wait until all the pods are running
### Step 4: Run Minio
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
user: minio
password: minio123


## Monitoring Kubernetes with Prometheus and Grafana 

- Add the Prometheus Operator Helm chart repository and install it:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
- Install the Prometheus Operator chart (which includes Grafana):

```bash
helm install prometheus-operator prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

### Accessing Prometheus Using Port Forwarding

```bash
kubectl port-forward --namespace monitoring svc/prometheus-operated 8000:9090
```
This will allow you to access Prometheus on your local machine at http://localhost:8000


### Accessing Grafana Using Port Forwarding
```bash
kubectl --namespace monitoring port-forward svc/prometheus-operator-grafana 3000:80
```
Then, access Grafana at http://localhost:3000

#### Get the Grafana Admin Credentials
```bash
kubectl get secret --namespace monitoring prometheus-operator-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
