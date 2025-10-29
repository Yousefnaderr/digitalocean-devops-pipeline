# Infrastructure (Terraform on DigitalOcean)

This Terraform configuration provisions a full development environment on DigitalOcean, including:

- Private VPC network for isolation
- Highly available Kubernetes cluster (3 worker nodes)
- Private container registry for application images
- Object storage (Spaces) for application media/assets
- Project grouping and tagging for cost/visibility

## High-level design

- `digitalocean_vpc`: isolates all traffic inside a dedicated VPC
- `digitalocean_kubernetes_cluster`: managed Kubernetes cluster used to run the application
- `digitalocean_container_registry`: stores versioned Docker images built by CI/CD
- `digitalocean_spaces_bucket`: used for media uploads and static assets (S3-like)

## How to use

```bash
terraform init
terraform fmt
terraform plan -out dev.plan

