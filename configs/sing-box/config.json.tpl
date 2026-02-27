{
  "log": { "level": "info", "timestamp": true },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-reality",
      "listen": "::",
      "listen_port": 443,
      "users": [{ "uuid": "${VLESS_UUID}", "flow": "" }],
      "tls": {
        "enabled": true,
        "server_name": "www.microsoft.com",
        "reality": {
          "enabled": true,
          "handshake": { "server": "www.microsoft.com", "server_port": 443 },
          "private_key": "${REALITY_PRIVATE_KEY}",
          "short_id": ["${REALITY_SHORT_ID}"]
        }
      },
      "transport": { "type": "grpc", "service_name": "grpc" }
    },
    {
      "type": "hysteria2",
      "tag": "hysteria2",
      "listen": "::",
      "listen_port": 444,
      "users": [{ "password": "${HY2_PASSWORD}" }],
      "tls": {
        "enabled": true,
        "certificate_path": "/etc/sing-box/tls/hysteria2.crt",
        "key_path": "/etc/sing-box/tls/hysteria2.key"
      },
      "obfs": { "type": "salamander", "password": "${SALAMANDER_PASSWORD}" }
    }
  ],
  "outbounds": [{ "type": "direct", "tag": "direct" }],
  "route": {
    "default_domain_resolver": "local"
  },
  "dns": {
    "servers": [
      { "type": "local", "tag": "local" }
    ]
  }
}
