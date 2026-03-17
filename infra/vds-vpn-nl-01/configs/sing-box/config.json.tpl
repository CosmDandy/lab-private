{
  "log": { "level": "info", "timestamp": true },
  "inbounds":
    [
      {
        "type": "vless",
        "tag": "vless-reality",
        "listen": "::",
        "listen_port": 443,
        "users": [{ "uuid": "${VLESS_UUID}", "flow": "" }],
        "tls":
          {
            "enabled": true,
            "server_name": "www.microsoft.com",
            "reality":
              {
                "enabled": true,
                "handshake":
                  { "server": "www.microsoft.com", "server_port": 443 },
                "private_key": "${REALITY_PRIVATE_KEY}",
                "short_id": ["${REALITY_SHORT_ID}"],
              },
          },
        "transport": { "type": "grpc", "service_name": "grpc" },
      },
      {
        "type": "vless",
        "tag": "vless-reality-2053",
        "listen": "::",
        "listen_port": 2053,
        "users": [{ "uuid": "${VLESS_UUID}", "flow": "" }],
        "tls":
          {
            "enabled": true,
            "server_name": "dl.google.com",
            "reality":
              {
                "enabled": true,
                "handshake": { "server": "dl.google.com", "server_port": 443 },
                "private_key": "${REALITY_PRIVATE_KEY}",
                "short_id": ["${REALITY_SHORT_ID}"],
              },
          },
        "transport": { "type": "grpc", "service_name": "grpc" },
      },
      {
        "type": "vless",
        "tag": "vless-reality-2083",
        "listen": "::",
        "listen_port": 2083,
        "users": [{ "uuid": "${VLESS_UUID}", "flow": "" }],
        "tls":
          {
            "enabled": true,
            "server_name": "www.samsung.com",
            "reality":
              {
                "enabled": true,
                "handshake":
                  { "server": "www.samsung.com", "server_port": 443 },
                "private_key": "${REALITY_PRIVATE_KEY}",
                "short_id": ["${REALITY_SHORT_ID}"],
              },
          },
        "transport": { "type": "grpc", "service_name": "grpc" },
      },
      {
        "type": "vless",
        "tag": "vless-reality-64444",
        "listen": "::",
        "listen_port": 64444,
        "users": [{ "uuid": "${VLESS_UUID}", "flow": "" }],
        "tls":
          {
            "enabled": true,
            "server_name": "learn.microsoft.com",
            "reality":
              {
                "enabled": true,
                "handshake":
                  { "server": "learn.microsoft.com", "server_port": 443 },
                "private_key": "${REALITY_PRIVATE_KEY}",
                "short_id": ["${REALITY_SHORT_ID}"],
              },
          },
        "transport": { "type": "grpc", "service_name": "grpc" },
      },
      {
        "type": "vless",
        "tag": "vless-reality-httpupgrade",
        "listen": "::",
        "listen_port": 2087,
        "users": [{ "uuid": "${VLESS_UUID}", "flow": "" }],
        "tls":
          {
            "enabled": true,
            "server_name": "www.logitech.com",
            "reality":
              {
                "enabled": true,
                "handshake":
                  { "server": "www.logitech.com", "server_port": 443 },
                "private_key": "${REALITY_PRIVATE_KEY}",
                "short_id": ["${REALITY_SHORT_ID}"],
              },
          },
        "transport": { "type": "httpupgrade", "path": "/upgrade" },
      },
      {
        "type": "hysteria2",
        "tag": "hysteria2",
        "listen": "::",
        "listen_port": 8443,
        "users": [{ "password": "${HY2_PASSWORD}" }],
        "tls":
          {
            "enabled": true,
            "certificate_path": "/etc/sing-box/tls/hysteria2.crt",
            "key_path": "/etc/sing-box/tls/hysteria2.key",
          },
        "obfs": { "type": "salamander", "password": "${SALAMANDER_PASSWORD}" },
      },
      {
        "type": "tuic",
        "tag": "tuic",
        "listen": "::",
        "listen_port": 8444,
        "users": [{ "uuid": "${VLESS_UUID}", "password": "${TUIC_PASSWORD}" }],
        "congestion_control": "bbr",
        "tls":
          {
            "enabled": true,
            "certificate_path": "/etc/sing-box/tls/hysteria2.crt",
            "key_path": "/etc/sing-box/tls/hysteria2.key",
          },
      },
      {
        "type": "shadowtls",
        "tag": "shadowtls-in",
        "listen": "::",
        "listen_port": 8388,
        "version": 3,
        "users": [{ "name": "user", "password": "${SHADOWTLS_PASSWORD}" }],
        "handshake": { "server": "www.apple.com", "server_port": 443 },
        "strict_mode": true,
        "detour": "shadowsocks-in",
      },
      {
        "type": "shadowsocks",
        "tag": "shadowsocks-in",
        "listen": "127.0.0.1",
        "listen_port": 18388,
        "method": "2022-blake3-aes-128-gcm",
        "password": "${SS_PASSWORD}",
      },
      {
        "type": "trojan",
        "tag": "trojan-in",
        "listen": "::",
        "listen_port": 8445,
        "users": [{ "password": "${TROJAN_PASSWORD}" }],
        "tls":
          {
            "enabled": true,
            "certificate_path": "/etc/sing-box/tls/hysteria2.crt",
            "key_path": "/etc/sing-box/tls/hysteria2.key",
          },
      },
      {
        "type": "shadowsocks",
        "tag": "shadowsocks-plain-in",
        "listen": "::",
        "listen_port": 8389,
        "method": "2022-blake3-aes-128-gcm",
        "password": "${SS_PLAIN_PASSWORD}",
      },
      {
        "type": "vless",
        "tag": "vless-reality-vision",
        "listen": "::",
        "listen_port": 8446,
        "users": [{ "uuid": "${VLESS_UUID}", "flow": "xtls-rprx-vision" }],
        "tls": {
          "enabled": true,
          "server_name": "www.microsoft.com",
          "reality": {
            "enabled": true,
            "handshake": { "server": "www.microsoft.com", "server_port": 443 },
            "private_key": "${REALITY_PRIVATE_KEY}",
            "short_id": ["${REALITY_SHORT_ID}"],
          },
        },
      },
    ],
  "outbounds":
    [
      {
        "type": "direct",
        "tag": "direct",
        "domain_resolver": { "server": "local", "strategy": "ipv4_only" },
      },
    ],
  "route": {
    "rules": [
      { "action": "sniff", "timeout": "300ms" }
    ],
    "default_domain_resolver": "local"
  },
  "dns": { "servers": [{ "type": "local", "tag": "local" }] },
}
