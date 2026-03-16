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
      "stack": "mixed",
      "route_exclude_address": ["100.64.0.0/10"],
      "exclude_interface": ["utun4"]
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "proxy",
      "outbounds": ["auto", "vless-reality-grpc", "vless-reality-grpc-2053", "vless-reality-grpc-2083", "vless-reality-grpc-64444", "vless-reality-httpupgrade", "hysteria2-salamander", "tuic", "ss-shadowtls", "trojan", "ss-plain"],
      "default": "hysteria2-salamander"
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": ["vless-reality-grpc", "vless-reality-grpc-2053", "vless-reality-grpc-2083", "vless-reality-grpc-64444", "vless-reality-httpupgrade", "hysteria2-salamander", "tuic", "ss-shadowtls", "trojan", "ss-plain"],
      "url": "https://www.gstatic.com/generate_204",
      "interval": "3m",
      "tolerance": 50,
      "interrupt_exist_connections": true
    },
    {
      "type": "vless",
      "tag": "vless-reality-grpc",
      "server": "${VPN_SERVER_IP}",
      "server_port": 443,
      "uuid": "${VLESS_UUID}",
      "flow": "",
      "tls": {
        "enabled": true,
        "server_name": "www.microsoft.com",
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
      "type": "vless",
      "tag": "vless-reality-grpc-2053",
      "server": "${VPN_SERVER_IP}",
      "server_port": 2053,
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
      "type": "vless",
      "tag": "vless-reality-grpc-2083",
      "server": "${VPN_SERVER_IP}",
      "server_port": 2083,
      "uuid": "${VLESS_UUID}",
      "flow": "",
      "tls": {
        "enabled": true,
        "server_name": "www.samsung.com",
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
      "type": "vless",
      "tag": "vless-reality-grpc-64444",
      "server": "${VPN_SERVER_IP}",
      "server_port": 64444,
      "uuid": "${VLESS_UUID}",
      "flow": "",
      "tls": {
        "enabled": true,
        "server_name": "learn.microsoft.com",
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
      "type": "vless",
      "tag": "vless-reality-httpupgrade",
      "server": "${VPN_SERVER_IP}",
      "server_port": 2087,
      "uuid": "${VLESS_UUID}",
      "flow": "",
      "tls": {
        "enabled": true,
        "server_name": "www.logitech.com",
        "utls": { "enabled": true, "fingerprint": "chrome" },
        "reality": {
          "enabled": true,
          "public_key": "${REALITY_PUBLIC_KEY}",
          "short_id": "${REALITY_SHORT_ID}"
        }
      },
      "transport": { "type": "httpupgrade", "path": "/upgrade" }
    },
    {
      "type": "hysteria2",
      "tag": "hysteria2-salamander",
      "server": "${VPN_SERVER_IP}",
      "server_port": 8443,
      "password": "${HY2_PASSWORD}",
      "tls": { "enabled": true, "server_name": "bing.com", "insecure": true },
      "obfs": { "type": "salamander", "password": "${SALAMANDER_PASSWORD}" }
    },
    {
      "type": "tuic",
      "tag": "tuic",
      "server": "${VPN_SERVER_IP}",
      "server_port": 8444,
      "uuid": "${VLESS_UUID}",
      "password": "${TUIC_PASSWORD}",
      "congestion_control": "bbr",
      "tls": { "enabled": true, "server_name": "bing.com", "insecure": true }
    },
    {
      "type": "shadowsocks",
      "tag": "ss-shadowtls",
      "method": "2022-blake3-aes-128-gcm",
      "password": "${SS_PASSWORD}",
      "detour": "shadowtls-out"
    },
    {
      "type": "shadowtls",
      "tag": "shadowtls-out",
      "server": "${VPN_SERVER_IP}",
      "server_port": 8388,
      "version": 3,
      "password": "${SHADOWTLS_PASSWORD}",
      "tls": {
        "enabled": true,
        "server_name": "www.apple.com",
        "utls": { "enabled": true, "fingerprint": "chrome" }
      }
    },
    {
      "type": "trojan",
      "tag": "trojan",
      "server": "${VPN_SERVER_IP}",
      "server_port": 8445,
      "password": "${TROJAN_PASSWORD}",
      "tls": { "enabled": true, "server_name": "bing.com", "insecure": true }
    },
    {
      "type": "shadowsocks",
      "tag": "ss-plain",
      "server": "${VPN_SERVER_IP}",
      "server_port": 8389,
      "method": "2022-blake3-aes-128-gcm",
      "password": "${SS_PLAIN_PASSWORD}"
    },
    { "type": "direct", "tag": "direct" }
  ],
  "route": {
    "default_domain_resolver": "local",
    "rules": [
      { "action": "sniff" },
      { "protocol": "dns", "action": "hijack-dns" },
      { "ip_is_private": true, "action": "route", "outbound": "direct" },
      { "rule_set": ["geosite-ru", "geoip-ru"], "action": "route", "outbound": "direct" }
    ],
    "rule_set": [
      {
        "type": "remote",
        "tag": "geosite-ru",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-category-ru.srs",
        "download_detour": "proxy"
      },
      {
        "type": "remote",
        "tag": "geoip-ru",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-ru.srs",
        "download_detour": "proxy"
      }
    ],
    "auto_detect_interface": true,
    "final": "proxy"
  }
}
