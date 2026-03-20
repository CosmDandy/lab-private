# ══════════════════════════════════════════════
# VPN
# ══════════════════════════════════════════════

resource "github_repository_environment" "vpn" {
  for_each    = var.vpn_servers
  repository  = var.github_repository
  environment = "vpn-${each.key}"
}

# Per-server VPN secrets (unique)

resource "random_uuid" "vless" {
  for_each = var.vpn_servers
}

resource "random_password" "hy2" {
  for_each = var.vpn_servers
  length   = 32
  special  = false
}

resource "random_password" "salamander" {
  for_each = var.vpn_servers
  length   = 32
  special  = false
}

resource "random_password" "tuic" {
  for_each = var.vpn_servers
  length   = 32
  special  = false
}

resource "random_password" "shadowtls" {
  for_each = var.vpn_servers
  length   = 32
  special  = false
}

resource "random_bytes" "ss" {
  for_each = var.vpn_servers
  length   = 16
}

resource "random_password" "trojan" {
  for_each = var.vpn_servers
  length   = 32
  special  = false
}

resource "random_bytes" "ss_plain" {
  for_each = var.vpn_servers
  length   = 16
}

locals {
  vpn_env_secrets = {
    for name, _ in var.vpn_servers : name => {
      VLESS_UUID          = random_uuid.vless[name].result
      REALITY_PRIVATE_KEY = var.reality_private_key
      REALITY_SHORT_ID    = var.reality_short_id
      HY2_PASSWORD        = random_password.hy2[name].result
      SALAMANDER_PASSWORD = random_password.salamander[name].result
      TUIC_PASSWORD       = random_password.tuic[name].result
      SHADOWTLS_PASSWORD  = random_password.shadowtls[name].result
      SS_PASSWORD         = random_bytes.ss[name].base64
      TROJAN_PASSWORD     = random_password.trojan[name].result
      SS_PLAIN_PASSWORD   = random_bytes.ss_plain[name].base64
    }
  }

  vpn_flat_secrets = merge([
    for server, secrets in local.vpn_env_secrets : {
      for key, value in secrets :
      "${server}/${key}" => {
        environment = "vpn-${server}"
        key         = key
        value       = value
      }
    }
  ]...)
}

resource "github_actions_environment_secret" "vpn" {
  for_each        = local.vpn_flat_secrets
  repository      = var.github_repository
  environment     = each.value.environment
  secret_name     = each.value.key
  plaintext_value = each.value.value

  depends_on = [github_repository_environment.vpn]
}

resource "github_actions_environment_variable" "vpn_reality_public_key" {
  for_each      = var.vpn_servers
  repository    = var.github_repository
  environment   = "vpn-${each.key}"
  variable_name = "REALITY_PUBLIC_KEY"
  value         = var.reality_public_key

  depends_on = [github_repository_environment.vpn]
}

resource "github_actions_environment_variable" "vpn_server_address" {
  for_each      = var.vpn_servers
  repository    = var.github_repository
  environment   = "vpn-${each.key}"
  variable_name = "SERVER_ADDRESS"
  value         = module.vpn_server[each.key].fqdn

  depends_on = [github_repository_environment.vpn]
}

resource "github_actions_environment_variable" "vpn_server_ipv4" {
  for_each      = var.vpn_servers
  repository    = var.github_repository
  environment   = "vpn-${each.key}"
  variable_name = "SERVER_IPV4"
  value         = module.vpn_server[each.key].ipv4_address

  depends_on = [github_repository_environment.vpn]
}

resource "github_actions_environment_variable" "vpn_acme_email" {
  for_each      = var.vpn_servers
  repository    = var.github_repository
  environment   = "vpn-${each.key}"
  variable_name = "ACME_EMAIL"
  value         = var.acme_email

  depends_on = [github_repository_environment.vpn]
}

resource "github_actions_environment_variable" "vpn_caddy_user" {
  for_each      = var.vpn_servers
  repository    = var.github_repository
  environment   = "vpn-${each.key}"
  variable_name = "CADDY_USER"
  value         = "vpn-${each.key}"

  depends_on = [github_repository_environment.vpn]
}

resource "github_actions_environment_secret" "vpn_caddy_hash" {
  for_each        = var.vpn_servers
  repository      = var.github_repository
  environment     = "vpn-${each.key}"
  secret_name     = "CADDY_HASH"
  plaintext_value = var.caddy_hash

  depends_on = [github_repository_environment.vpn]
}

# ══════════════════════════════════════════════
# Mesh
# ══════════════════════════════════════════════

resource "github_repository_environment" "mesh" {
  for_each    = var.mesh_servers
  repository  = var.github_repository
  environment = "mesh-${each.key}"
}

resource "random_password" "mesh_cookie_secret" {
  for_each = var.mesh_servers
  length   = 32
  special  = false
}

locals {
  mesh_env_secrets = {
    for name, _ in var.mesh_servers : name => {
      COOKIE_SECRET = random_password.mesh_cookie_secret[name].result
      CADDY_HASH    = var.caddy_hash
    }
  }

  mesh_flat_secrets = merge([
    for server, secrets in local.mesh_env_secrets : {
      for key, value in secrets :
      "${server}/${key}" => {
        environment = "mesh-${server}"
        key         = key
        value       = value
      }
    }
  ]...)
}

resource "github_actions_environment_secret" "mesh" {
  for_each        = local.mesh_flat_secrets
  repository      = var.github_repository
  environment     = each.value.environment
  secret_name     = each.value.key
  plaintext_value = each.value.value

  depends_on = [github_repository_environment.mesh]
}

resource "github_actions_environment_variable" "mesh_server_address" {
  for_each      = var.mesh_servers
  repository    = var.github_repository
  environment   = "mesh-${each.key}"
  variable_name = "SERVER_ADDRESS"
  value         = module.mesh_server[each.key].fqdn

  depends_on = [github_repository_environment.mesh]
}

resource "github_actions_environment_variable" "mesh_server_ipv4" {
  for_each      = var.mesh_servers
  repository    = var.github_repository
  environment   = "mesh-${each.key}"
  variable_name = "SERVER_IPV4"
  value         = module.mesh_server[each.key].ipv4_address

  depends_on = [github_repository_environment.mesh]
}

resource "github_actions_environment_variable" "mesh_acme_email" {
  for_each      = var.mesh_servers
  repository    = var.github_repository
  environment   = "mesh-${each.key}"
  variable_name = "ACME_EMAIL"
  value         = var.acme_email

  depends_on = [github_repository_environment.mesh]
}

resource "github_actions_environment_variable" "mesh_caddy_user" {
  for_each      = var.mesh_servers
  repository    = var.github_repository
  environment   = "mesh-${each.key}"
  variable_name = "CADDY_USER"
  value         = "mesh-${each.key}"

  depends_on = [github_repository_environment.mesh]
}
