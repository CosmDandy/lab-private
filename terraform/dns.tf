resource "cloudflare_dns_record" "panel" {
  count   = local.control_server != null ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "vpn"
  type    = "CNAME"
  content = "${local.control_server}.${var.domain}"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "traefik" {
  count   = local.control_server != null ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "traefik"
  type    = "CNAME"
  content = "${local.control_server}.${var.domain}"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "mesh" {
  count   = local.control_server != null ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "mesh"
  type    = "A"
  content = module.server[local.control_server].ipv4_address
  ttl     = 300
  proxied = false
}
