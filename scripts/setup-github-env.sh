#!/usr/bin/env bash
# Usage: ./scripts/setup-github-env.sh <env-name> [.env-file]
#
# Creates/updates a GitHub Actions environment with secrets and variables.
# env-name examples: production, vds-vpn-nl-01, vds-mesh-mos-01
#
# With .env-file: values are read from KEY=value lines.
# Without .env-file: prompted interactively.
set -euo pipefail

ENV=${1:?Usage: $0 <env-name> [.env-file]}
ENV_FILE=${2:-}

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# ── load .env file if provided ────────────────────────────────────────────────
declare -A LOADED
if [[ -n "$ENV_FILE" && -f "$ENV_FILE" ]]; then
  while IFS='=' read -r key value; do
    [[ "$key" =~ ^[[:space:]]*# || -z "${key// }" ]] && continue
    LOADED["${key// }"]="${value}"
  done < "$ENV_FILE"
  echo "Loaded values from $ENV_FILE"
fi

# ── helpers ───────────────────────────────────────────────────────────────────
get_secret() { local k=$1; if [[ -v LOADED[$k] ]]; then printf '%s' "${LOADED[$k]}"; return; fi; read -rsp "$k: " v; echo >&2; printf '%s' "$v"; }
get_var()    { local k=$1; if [[ -v LOADED[$k] ]]; then printf '%s' "${LOADED[$k]}"; return; fi; read -rp  "$k: " v; printf '%s' "$v"; }

set_secret() { get_secret "$1" | gh secret   set "$1" --env "$ENV" --repo "$REPO"; echo "  secret  $1"; }
set_var()    { gh variable set "$1" --env "$ENV" --body "$(get_var "$1")" --repo "$REPO"; echo "  var     $1"; }

# ── create environment ────────────────────────────────────────────────────────
gh api "repos/$REPO/environments/$ENV" --method PUT --silent
echo "── Environment: $ENV  ($REPO)"

if [[ "$ENV" == *vpn* ]]; then
  echo "── VPN secrets"
  for s in \
    VLESS_UUID REALITY_PRIVATE_KEY REALITY_SHORT_ID \
    HY2_PASSWORD SALAMANDER_PASSWORD TUIC_PASSWORD \
    SHADOWTLS_PASSWORD SS_PASSWORD TROJAN_PASSWORD SS_PLAIN_PASSWORD \
    CADDY_USER CADDY_HASH
  do
    set_secret "$s"
  done

  echo "── VPN variables"
  for v in DOMAIN ACME_EMAIL VPN_SERVER_IP REALITY_PUBLIC_KEY; do
    set_var "$v"
  done
fi

if [[ "$ENV" == *mesh* ]]; then
  echo "── Mesh secrets"
  for s in CADDY_USER CADDY_HASH COOKIE_SECRET; do
    set_secret "$s"
  done

  echo "── Mesh variables"
  for v in DOMAIN SERVER_IP ACME_EMAIL; do
    set_var "$v"
  done
fi

echo "── Done"
