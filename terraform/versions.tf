terraform {
  required_version = ">= 1.10"

  cloud {
    organization = "CosmDandy"
    workspaces {
      name = "lab-private"
    }
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.60"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    minio = {
      source  = "aminueza/minio"
      version = "~> 3.3"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "minio" {
  minio_server   = "hel1.your-objectstorage.com"
  minio_user     = var.hetzner_s3_access_key
  minio_password = var.hetzner_s3_secret_key
  minio_ssl      = true
  minio_region   = "hel1"
}
