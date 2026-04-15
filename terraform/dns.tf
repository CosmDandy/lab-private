resource "cloudflare_dns_record" "panel" {
  zone_id = var.cloudflare_zone_id
  name    = "vpn"
  type    = "CNAME"
  content = "${local.control_server}.${var.domain}"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "mesh" {
  zone_id = var.cloudflare_zone_id
  name    = "mesh"
  type    = "A"
  content = module.server[local.control_server].ipv4_address
  ttl     = 300
  proxied = false
}
