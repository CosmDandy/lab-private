variable "hcloud_token" {
  description = "Hetzner Cloud API token (generate in project → Security → API Tokens)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for server access"
  type        = string
}

variable "server_name" {
  description = "Server hostname"
  type        = string
  default     = "vds-vpn-hel-01"
}

variable "server_type" {
  description = "Hetzner server type (cpx11, cpx22, cpx32, ...)"
  type        = string
  default     = "cpx22"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "hel1"
}

variable "image" {
  description = "OS image"
  type        = string
  default     = "ubuntu-24.04"
}

# Cloudflare
variable "cloudflare_api_token" {
  description = "Cloudflare API token (Zone:DNS:Edit permissions)"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID (Dashboard → your domain → right sidebar)"
  type        = string
}

variable "dns_records" {
  description = "DNS A-records to create for the VPN server"
  type = list(object({
    name    = string
    comment = string
  }))
  default = [
    { name = "vpn", comment = "VPN server (Helsinki)" },
  ]
}
