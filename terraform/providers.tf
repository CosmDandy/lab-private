terraform {
  required_version = ">= 1.9"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }

  # Раскомментировать для remote state в Terraform Cloud:
  # cloud {
  #   organization = "cosmdandy"
  #   workspaces {
  #     name = "lab-private-hetzner"
  #   }
  # }

  # Или S3-compatible (Hetzner Object Storage):
  # backend "s3" {
  #   endpoint                    = "https://fsn1.your-objectstorage.com"
  #   bucket                      = "tf-state"
  #   key                         = "hetzner/terraform.tfstate"
  #   region                      = "main"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   force_path_style            = true
  # }
}

provider "hcloud" {
  token = var.hcloud_token
}
