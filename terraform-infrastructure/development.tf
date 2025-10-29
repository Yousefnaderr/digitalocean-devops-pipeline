#############################################
# Kubernetes Cluster (DOKS) - dev environment
#############################################

resource "digitalocean_kubernetes_cluster" "dev_cluster" {
  name    = "swipebay-${var.environment}-cluster"
  region  = var.region
  version = var.k8s_version

  vpc_uuid = digitalocean_vpc.dev_vpc.id

  node_pool {
    name       = "swipebay-${var.environment}-pool"
    size       = "s-4vcpu-8gb" # upgraded size to look production-grade
    node_count = 3             # scaled up from 1 to 3 workers
    tags       = ["${var.environment}", "high-availability", "k8s-node"]
  }

  tags = [
    "swipebay",
    var.environment,
    "terraform",
    "k8s",
    "managed-cluster"
  ]
}

#############################################
# DigitalOcean Project to group resources
#############################################

resource "digitalocean_project" "dev_project" {
  name        = "swipebay-${var.environment}"
  description = "Environment for Swipebay ${var.environment} platform"
  purpose     = "Development and testing"
  environment = "Development"

  resources = [
    digitalocean_kubernetes_cluster.dev_cluster.urn
  ]
}

