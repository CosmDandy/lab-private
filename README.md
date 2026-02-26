# lab-private

Docker Compose infrastructure for VPS servers. Auto-deploy via GitHub Actions with self-hosted runners.

## Architecture

| Server | Runner label | Services |
|--------|-------------|----------|
| NL (VPN_SERVER_IP_PLACEHOLDER) | `vds-vpn-nl-01` | sing-box (VLESS + Hysteria2) |
| MOS | `vds-mesh-mos-01` | headscale + headplane + caddy |

## Workflows

- `deploy-singbox.yml` — deploy on push to `configs/sing-box/**`, `docker-compose/sing-box.yaml`
- `deploy-mesh.yml` — deploy on push to `configs/headscale/**`, `configs/headplane/**`, `configs/caddy/**`
- `setup-server.yml` — install dependencies (manual trigger)

## Setting up a new runner

### 1. Create user (as root)

```bash
useradd -m -s /bin/bash github-runner
usermod -aG docker github-runner
```

### 2. Configure sudoers (as root)

```bash
echo 'github-runner ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/bin/mkdir, /usr/bin/chown' | tee /etc/sudoers.d/github-runner
```

### 3. Install runner (as github-runner)

Follow the instructions from GitHub: repo Settings → Actions → Runners → New self-hosted runner → Linux.

```bash
su - github-runner
mkdir actions-runner && cd actions-runner
# Download and extract (commands from GitHub UI)
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz
tar xzf actions-runner-linux-x64.tar.gz
```

Register with labels matching the server:

```bash
./config.sh \
  --url https://github.com/ExampleUser/lab-private \
  --token <TOKEN_FROM_GITHUB> \
  --name <server-hostname> \
  --labels <server-hostname> \
  --work _work
```

### 4. Install as systemd service (as root)

```bash
cd /home/github-runner/actions-runner
./svc.sh install github-runner
./svc.sh start
```

Verify:

```bash
systemctl status actions.runner.*
```

### 5. Install dependencies

Run `setup-server.yml` workflow from GitHub: Actions → Setup server dependencies → Run workflow → select server.

This installs: `rsync`, `jq`, `gettext-base` (envsubst).

### 6. Prepare deploy directory (done by setup-server workflow)

If running manually:

```bash
mkdir -p /opt/lab-private
chown -R github-runner:github-runner /opt/lab-private
```

### 7. TLS certificates (NL server only)

For Hysteria2 self-signed certificate:

```bash
su - github-runner
mkdir -p /opt/lab-private/configs/sing-box/tls
cd /opt/lab-private/configs/sing-box/tls
openssl req -x509 -newkey ec \
  -pkeyopt ec_paramgen_curve:prime256v1 -days 3650 -nodes \
  -keyout hysteria2.key -out hysteria2.crt -subj "/CN=bing.com"
```

## GitHub Secrets

Required secrets (repo Settings → Secrets → Actions):

| Secret | Used by |
|--------|---------|
| `VLESS_UUID` | sing-box |
| `REALITY_PRIVATE_KEY` | sing-box |
| `REALITY_SHORT_ID` | sing-box |
| `HY2_PASSWORD` | sing-box |
| `SALAMANDER_PASSWORD` | sing-box |
