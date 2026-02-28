{
  "log": { "level": "info", "timestamp": true },
  "dns": {
    "servers": [
      { "type": "https", "tag": "remote", "server": "1.1.1.1", "domain_resolver": "local" },
      { "type": "local", "tag": "local" }
    ],
    "strategy": "ipv4_only"
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "interface_name": "sing-tun",
      "address": ["172.19.0.1/30"],
      "mtu": 1300,
      "auto_route": true,
      "strict_route": false,
      "stack": "system",
      "route_exclude_address": [
        "100.64.0.0/24",
        "192.168.0.0/16"
      ]
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
    { "type": "direct", "tag": "direct" }
  ],
  "route": {
    "default_domain_resolver": "local",
    "rules": [
      { "action": "sniff" },
      { "protocol": "dns", "action": "hijack-dns" },
      { "ip_is_private": true, "action": "route", "outbound": "direct" }
    ],
    "auto_detect_interface": true,
    "final": "proxy"
  }
}
