variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "spaces_access_id" {
  description = "DigitalOcean Spaces Access Key ID"
  type        = string
  sensitive   = true
}

variable "spaces_secret_key" {
  description = "DigitalOcean Spaces Secret Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region for all resources"
  type        = string
  default     = "fra1"
}

variable "environment" {
  description = "Environment name (dev / staging / prod)"
  type        = string
  default     = "dev"
}

variable "k8s_version" {
  description = "DigitalOcean Kubernetes version"
  type        = string
  default     = "1.33.1-do.4"
}

variable "space_name" {
  description = "DO Spaces bucket name"
  type        = string
  default     = "swipebay-media"
}

