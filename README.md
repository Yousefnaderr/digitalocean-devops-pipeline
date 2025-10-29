# Swipebay DevOps Infrastructure

This repository contains the complete DevOps infrastructure for the Swipebay ERP platform, including automated CI/CD pipelines, Kubernetes deployments, monitoring stack, and supporting automation scripts.  
The goal is to ensure a fully automated, observable, and secure environment for both backend and frontend applications.

---

## 1. Overview

Swipebay’s infrastructure is designed to operate in a cloud-native environment powered by DigitalOcean Kubernetes.  
All components—from build pipelines to deployment, monitoring, and automation—are integrated to achieve continuous delivery with high reliability and visibility.

Key technologies used:
- **GitHub Actions** for CI/CD
- **Docker & Multi-Stage Builds** for containerization
- **Kubernetes** (DigitalOcean Managed Cluster)
- **Terraform** for infrastructure provisioning
- **Prometheus, Grafana, Loki, and Promtail** for observability
- **cert-manager** for TLS automation
- **Slack Integration** for alerting and notifications
- **Bash scripting** for automation tasks

---


### Folder Descriptions

- **cert-manager-files/**  
  Contains YAML manifests to install and configure cert-manager, including cluster issuers and certificate templates.

- **deployment-files/**  
  Kubernetes manifests for deploying backend, frontend, and monitoring workloads.

- **devops-tools/**  
  YAML configurations and scripts related to utility deployments such as n8n, Prometheus alerts, and custom DevOps tasks.

- **ingress-files/**  
  Ingress definitions for backend and frontend applications with TLS certificates issued by cert-manager.

- **invoice-cron/**  
  Contains the Bash automation script responsible for generating and uploading DigitalOcean invoices to Slack automatically.

- **monitoring/**  
  Includes configurations for Prometheus, Grafana, Loki, Promtail, and ServiceMonitors for metric collection and visualization.

- **services-files/**  
  Service definitions for backend and frontend workloads inside Kubernetes.

---

## 3. CI/CD Workflows

### 3.1 Continuous Integration (Backend)

The backend CI pipeline runs on **GitHub Actions**, performing:
- Code checkout and dependency installation
- Unit and e2e test execution
- Coverage reporting
- Snyk security scanning
- Slack notification on success or failure

Each push or pull request triggers this automated build and test process.  
This ensures code security and stability before any deployment step.

### 3.2 Continuous Deployment (Backend)

The CD workflow is triggered automatically after a successful CI run.  
Steps include:
- Building and tagging a Docker image using commit SHA
- Pushing the image to **DigitalOcean Container Registry**
- Deploying the new image to the **Kubernetes cluster** in the corresponding namespace
- Notifying via Slack after deployment success

The workflow is dependency-aware; if the CI or Snyk scan fails, the CD pipeline is skipped automatically to prevent unstable code from being released.

---

## 4. Kubernetes Infrastructure

### 4.1 Namespaces
Namespaces are used to isolate environments logically:
- `backend`
- `frontend`
- `monitoring`
- `cert-manager`
- `test-env`

The script `create-namespaces.sh` automates namespace creation during cluster initialization.

### 4.2 Deployments
Each microservice has its own deployment YAML file stored in `deployment-files/`.  
Deployments reference SHA-tagged Docker images hosted in the private registry.  
Resource limits and requests are defined to ensure predictable workload behavior.

### 4.3 Services
ClusterIP and LoadBalancer services are configured to expose applications internally and externally when required.  
For example:
- `backend-service` exposes port 3000 internally
- `frontend-service` serves the Next.js UI
- Ingress-NGINX handles external traffic routing via HTTPS

### 4.4 Ingress and TLS
Ingress resources are configured in `ingress-files/` and use cert-manager for certificate issuance.  
Verified TLS certificates exist in both frontend and backend namespaces to guarantee secure communication.

---

## 5. Monitoring and Observability

Monitoring is implemented using **Prometheus**, **Grafana**, **Loki**, and **Promtail**.

### 5.1 Prometheus
Prometheus collects metrics from all workloads, including:
- Node-level metrics (CPU, memory, filesystem)
- Pod-level metrics
- Application-level metrics exposed from `/metrics` endpoints

### 5.2 Grafana
Grafana visualizes Prometheus metrics via customized dashboards for:
- Node resource utilization (CPU, RAM, Pods per node)
- Application request rate and latency
- Storage and network usage
- Alerts integration with Slack

Example dashboard views include detailed CPU/RAM usage, node uptime, and pod-level breakdown.

### 5.3 Loki and Promtail
Promtail collects logs from all pods and forwards them to Loki.  
Grafana visualizes these logs in real-time, enabling central log management with search and filtering.

### 5.4 Alerting
Prometheus Alertmanager sends alerts to a Slack channel when threshold breaches occur, such as high CPU or memory usage, pod restarts, or failed deployments.

---

## 6. Automation and Scripts

### 6.1 create-namespaces.sh
A startup automation script that creates and labels namespaces for the project environment.

### 6.2 install-cert-manager.sh
Installs cert-manager using Helm, applies ClusterIssuer, and validates readiness before proceeding.

### 6.3 remove-old-image.sh
Automatically deletes unused images from DigitalOcean Container Registry to optimize storage and reduce cost.

### 6.4 deploy-monitoring.sh
Deploys or updates the monitoring stack (Prometheus, Grafana, Loki, Promtail) within the `monitoring` namespace.

### 6.5 invoice-cron.sh
A fully automated Bash script that:
- Downloads the latest DigitalOcean invoice
- Uploads it to a DigitalOcean Space
- Sends a Slack message containing the invoice link and monthly cost summary

Slack output example:
> "DigitalOcean Invoice uploaded successfully — view it here: https://spaces.swipebay.tech/invoices/invoice-2025-10.pdf"

---

## 7. Security

- TLS certificates issued and renewed automatically by cert-manager.
- Secrets stored as Kubernetes `Secret` objects or SealedSecrets.
- Private Docker registry access controlled via `imagePullSecrets`.
- Snyk integrated into CI pipeline to detect vulnerabilities early.
- Slack notifications ensure visibility for all build and deploy outcomes.

---

## 8. Observability Example Output

Grafana dashboards provide a full overview of node health and resource usage:
- Node CPU usage around 25%
- Memory utilization ~80%
- 24 pods distributed across namespaces
- Automated alerts configured for threshold breaches

Additionally, verified active TLS certificates across `frontend` and `backend` namespaces confirm secure ingress configurations.

---

## 9. Summary

This project represents a complete DevOps implementation integrating modern CI/CD, containerization, Kubernetes orchestration, observability, and automation practices.

It delivers:
- **Automated build, test, and deployment pipelines**
- **Secure and observable Kubernetes environments**
- **Cost and performance automation via Bash and Slack integrations**
- **Cloud-native scalability with DigitalOcean’s managed infrastructure**

The infrastructure design can be easily adapted to other cloud providers (AWS, GCP, Azure) by modifying Terraform modules and GitHub workflow environment variables.

---

## 10. Author

**Youssef Nader**  
DevOps Engineer | Certified Kubernetes & Red Hat Specialist  
email: Youssefnaderr2002@gmail.com  
LinkedIn: www.linkedin.com/in/youssef-nader-devops

---

