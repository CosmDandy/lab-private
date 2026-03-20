output "server_id" {
  value = hcloud_server.this.id
}

output "ipv4_address" {
  value = hcloud_server.this.ipv4_address
}

output "ipv6_address" {
  value = hcloud_server.this.ipv6_address
}

output "fqdn" {
  value = "${var.dns_name}.${var.domain}"
}

output "name" {
  value = var.name
}
