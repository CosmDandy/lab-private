#!/usr/bin/env bash
set -euo pipefail

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp    comment 'SSH'
sudo ufw allow 443/tcp   comment 'VLESS Reality gRPC'
sudo ufw allow 2053/tcp  comment 'VLESS Reality gRPC'
sudo ufw allow 2083/tcp  comment 'VLESS Reality gRPC'
sudo ufw allow 64444/tcp comment 'VLESS Reality gRPC'
sudo ufw allow 2087/tcp  comment 'VLESS Reality HTTPUpgrade'
sudo ufw allow 8443/udp  comment 'Hysteria2 Salamander'
sudo ufw allow 8444/udp  comment 'TUIC v5'
sudo ufw allow 8388/tcp  comment 'ShadowTLS + Shadowsocks'
sudo ufw allow 8445/tcp  comment 'Trojan'
sudo ufw allow 8389/tcp  comment 'Shadowsocks plain'
sudo ufw allow 8446/tcp  comment 'VLESS Reality Vision'
sudo ufw --force enable
sudo ufw status verbose
