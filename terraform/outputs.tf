output "vpn_servers" {
  value = {
    for name, s in module.vpn_server : name => {
      ipv4 = s.ipv4_address
      ipv6 = s.ipv6_address
      fqdn = s.fqdn
    }
  }
}

output "servers" {
  value = {
    for name, s in module.server : name => {
      ipv4  = s.ipv4_address
      ipv6  = s.ipv6_address
      fqdn  = s.fqdn
      roles = var.servers[name].roles
    }
  }
}
