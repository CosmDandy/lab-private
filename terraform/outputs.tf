output "vpn_servers" {
  value = {
    for name, s in module.vpn_server : name => {
      ipv4 = s.ipv4_address
      ipv6 = s.ipv6_address
      fqdn = s.fqdn
    }
  }
}

output "mesh_servers" {
  value = {
    for name, s in module.mesh_server : name => {
      ipv4 = s.ipv4_address
      ipv6 = s.ipv6_address
      fqdn = s.fqdn
    }
  }
}
