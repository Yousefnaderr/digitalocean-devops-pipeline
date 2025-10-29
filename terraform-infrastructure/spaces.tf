###################################################
# DigitalOcean Spaces (Object Storage) - Media/App
###################################################

resource "digitalocean_spaces_bucket" "media_bucket" {
  name   = var.space_name
  region = var.region
  acl    = "private" # can be 'public-read' for public assets/CDN

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
  }

  versioning {
    enabled = false
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

output "space_name" {
  value = digitalocean_spaces_bucket.media_bucket.name
}

output "space_endpoint" {
  value = "${var.space_name}.${var.region}.digitaloceanspaces.com"
}

