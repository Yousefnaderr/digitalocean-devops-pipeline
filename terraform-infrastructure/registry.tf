#############################################
# DigitalOcean Container Registry
#############################################

resource "digitalocean_container_registry" "registry" {
  name                   = "swipebay-registry"
  region                 = var.region
  subscription_tier_slug = "basic" #The cost is $5 
}

