output "server_ip" {
  description = "Server public IPv4"
  value       = hcloud_server.vpn.ipv4_address
}

output "server_ipv6" {
  description = "Server public IPv6 (prefix)"
  value       = hcloud_server.vpn.ipv6_address
}

output "server_name" {
  description = "Server hostname"
  value       = hcloud_server.vpn.name
}

output "dns_records" {
  description = "Created DNS records"
  value = {
    for k, r in cloudflare_record.vpn : k => r.hostname
  }
}

output "ansible_inventory_snippet" {
  description = "Paste this into ansible/inventory/hosts.yml"
  value = <<-EOT
    vds-vpn-hel-01:
      ansible_host: ${hcloud_server.vpn.ipv4_address}
      ansible_user: root
      tailscale_ip: "vds-vpn-hel-01.hamster"
  EOT
}
