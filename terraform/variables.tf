variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_owner" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "domain" {
  type    = string
  default = "cosmdandy.dev"
}

variable "ssh_public_keys" {
  type = list(string)
}

variable "reality_private_key" {
  type      = string
  sensitive = true
}

variable "reality_public_key" {
  type = string
}

variable "reality_short_id" {
  type = string
}

variable "vpn_servers" {
  type = map(object({
    location  = string
    type      = string
    tcp_ports = list(number)
    udp_ports = list(number)
    image     = optional(string, "ubuntu-24.04")
    labels    = optional(map(string), {})
  }))
}

variable "acme_email" {
  type = string
}

variable "caddy_hash" {
  type      = string
  sensitive = true
}

variable "warp_private_key" {
  type      = string
  sensitive = true
}

variable "warp_address_v4" {
  type = string
}

variable "warp_address_v6" {
  type = string
}

variable "servers" {
  type = map(object({
    location  = string
    type      = string
    roles     = list(string)
    tcp_ports = list(number)
    udp_ports = list(number)
    image     = optional(string, "ubuntu-24.04")
    labels    = optional(map(string), {})
  }))
  default = {}
}
