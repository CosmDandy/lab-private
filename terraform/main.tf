locals {
  firewall_rules = [
    { protocol = "tcp", port = "22",    description = "SSH" },
    { protocol = "tcp", port = "80",    description = "Caddy config server" },
    { protocol = "tcp", port = "443",   description = "VLESS Reality gRPC" },
    { protocol = "tcp", port = "2053",  description = "VLESS Reality gRPC" },
    { protocol = "tcp", port = "2083",  description = "VLESS Reality gRPC" },
    { protocol = "tcp", port = "64444", description = "VLESS Reality gRPC" },
    { protocol = "tcp", port = "2087",  description = "VLESS Reality HTTPUpgrade" },
    { protocol = "tcp", port = "8446",  description = "VLESS Reality Vision" },
    { protocol = "udp", port = "8443",  description = "Hysteria2 + Salamander" },
    { protocol = "udp", port = "8444",  description = "TUIC v5" },
    { protocol = "tcp", port = "8388",  description = "ShadowTLS + Shadowsocks" },
    { protocol = "tcp", port = "8445",  description = "Trojan" },
    { protocol = "tcp", port = "8389",  description = "Shadowsocks plain" },
  ]
}

resource "hcloud_ssh_key" "main" {
  name       = var.server_name
  public_key = var.ssh_public_key
}

resource "hcloud_firewall" "vpn" {
  name = "${var.server_name}-fw"

  dynamic "rule" {
    for_each = local.firewall_rules
    content {
      direction   = "in"
      protocol    = rule.value.protocol
      port        = rule.value.port
      source_ips  = ["0.0.0.0/0", "::/0"]
      description = rule.value.description
    }
  }
}

resource "hcloud_server" "vpn" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.location
  image       = var.image

  ssh_keys = [hcloud_ssh_key.main.id]

  firewall_ids = [hcloud_firewall.vpn.id]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ssh_keys]
  }
}
