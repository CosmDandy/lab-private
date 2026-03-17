locals {
  dns_records = {
    for r in var.dns_records : r.name => r
  }
}

# A-записи для VPN-сервера
resource "cloudflare_record" "vpn" {
  for_each = local.dns_records

  zone_id = var.cloudflare_zone_id
  name    = each.key
  content = hcloud_server.vpn.ipv4_address
  type    = "A"
  ttl     = 1       # 1 = auto (только при proxied = false)
  proxied = false   # VPN-протоколы не идут через Cloudflare proxy
  comment = each.value.comment
}
