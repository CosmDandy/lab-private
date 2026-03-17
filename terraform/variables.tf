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
