resource "digitalocean_vpc" "dev_vpc" {
  name        = "swipebay-${var.environment}-vpc"
  region      = var.region
  description = "Private VPC network for ${var.environment} environment"
}

