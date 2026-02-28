# Tailscale Role

Static binary install + authorize via authkey.

## Tasks

- `install.yml` — copy archive, extract, install binaries + systemd, enable + start
- `authorize.yml` — `tailscale up --reset` with all flags from inventory/defaults
- `uninstall.yml` — down → stop → remove files → daemon reload

## Tags

| Tag | What it does |
|-----|-------------|
| `install` | Install binaries only |
| `authorize` | (Re)authorize only |
| `uninstall` | Remove tailscale |
| `reinstall` | uninstall → install → authorize |

## Commands

Run from `ansible/` directory:

```bash
# Full reinstall on work VMs
ansible-playbook playbooks/tailscale.yml \
  -e target_hosts=vm_work --tags reinstall --ask-vault-pass

# Re-apply settings (routes, dns, etc.)
ansible-playbook playbooks/tailscale.yml \
  -e target_hosts=pve --tags authorize --ask-vault-pass

# Uninstall from local proxmox
ansible-playbook playbooks/tailscale.yml \
  -e target_hosts=pve_local --tags uninstall --ask-vault-pass

# Install on all proxmox (default target_hosts=pve_work)
ansible-playbook playbooks/tailscale.yml \
  --tags install --ask-vault-pass
```

## Host Variables

Set per-host in inventory:

- `ts_hostname` — tailscale hostname (default: `inventory_hostname`)
- `ts_advertise_routes` — subnets to advertise (e.g. `"192.168.20.0/24,192.168.82.0/24"`)
- `ts_advertise_exit_node` — advertise as exit node (`false`)
- `ts_accept_dns` / `ts_accept_routes` — accept from peers (`true`)
