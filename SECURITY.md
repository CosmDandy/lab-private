# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do not** open a public issue
2. Email: [create a private security advisory](https://github.com/CosmDandy/vpn-infra/security/advisories/new)

## Scope

This project manages VPN infrastructure as code. Security-relevant areas include:

- Terraform state and secrets management
- cloud-init provisioning scripts
- Docker Compose configurations
- GitHub Actions workflows and self-hosted runner setup
- sing-box server/client configurations

## Design Principles

- All secrets managed via Terraform Cloud variables and GitHub Actions environments
- No hardcoded credentials in repository
- Secret scanning and push protection enabled
- Server hardened via cloud-init (SSH, kernel tuning, unattended-upgrades)
