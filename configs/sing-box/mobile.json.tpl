{
  "log": { "level": "info", "timestamp": true },
  "dns": {
    "servers": [
      { "tag": "remote", "address": "https://1.1.1.1/dns-query", "detour": "proxy" },
      { "tag": "local", "address": "https://1.1.1.1/dns-query", "detour": "direct" }
    ],
    "rules": [{ "outbound": "any", "server": "local" }],
    "strategy": "ipv4_only"
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "inet4_address": "172.19.0.1/30",
      "inet6_address": "fdfe:dcba:9876::1/126",
      "mtu": 1300,
      "auto_route": true,
      "strict_route": true,
      "sniff": true,
      "stack": "mixed"
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "proxy",
      "outbounds": ["auto", "vless-reality-grpc", "hysteria2-salamander"],
      "default": "auto"
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": ["vless-reality-grpc", "hysteria2-salamander"],
      "url": "https://www.gstatic.com/generate_204",
      "interval": "3m",
      "tolerance": 50,
      "interrupt_exist_connections": true
    },
    {
      "type": "vless",
      "tag": "vless-reality-grpc",
      "server": "VPN_SERVER_IP_PLACEHOLDER",
      "server_port": 443,
      "uuid": "${VLESS_UUID}",
      "flow": "",
      "tls": {
        "enabled": true,
        "server_name": "dl.google.com",
        "utls": { "enabled": true, "fingerprint": "chrome" },
        "reality": {
          "enabled": true,
          "public_key": "${REALITY_PUBLIC_KEY}",
          "short_id": "${REALITY_SHORT_ID}"
        }
      },
      "transport": { "type": "grpc", "service_name": "grpc" }
    },
    {
      "type": "hysteria2",
      "tag": "hysteria2-salamander",
      "server": "VPN_SERVER_IP_PLACEHOLDER",
      "server_port": 8443,
      "password": "${HY2_PASSWORD}",
      "tls": { "enabled": true, "server_name": "bing.com", "insecure": true },
      "obfs": { "type": "salamander", "password": "${SALAMANDER_PASSWORD}" }
    },
    { "type": "direct", "tag": "direct" },
    { "type": "block", "tag": "block" },
    { "type": "dns", "tag": "dns-out" }
  ],
  "route": {
    "rules": [
      { "protocol": "dns", "outbound": "dns-out" },
      { "ip_is_private": true, "outbound": "direct" }
    ],
    "auto_detect_interface": true,
    "final": "proxy"
  }
}
