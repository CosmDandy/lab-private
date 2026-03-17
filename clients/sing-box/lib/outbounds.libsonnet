{
  vlessRealityGrpc(tag, port, sni, fingerprint='chrome', serviceName='grpc'):: {
    type: 'vless',
    tag: tag,
    server: '${VPN_SERVER_IP}',
    server_port: port,
    uuid: '${VLESS_UUID}',
    flow: '',
    tls: {
      enabled: true,
      server_name: sni,
      utls: { enabled: true, fingerprint: fingerprint },
      reality: {
        enabled: true,
        public_key: '${REALITY_PUBLIC_KEY}',
        short_id: '${REALITY_SHORT_ID}',
      },
    },
    transport: { type: 'grpc', service_name: serviceName },
  },

  vlessRealityHttpupgrade():: {
    type: 'vless',
    tag: 'vless-reality-httpupgrade',
    server: '${VPN_SERVER_IP}',
    server_port: 2087,
    uuid: '${VLESS_UUID}',
    flow: '',
    tls: {
      enabled: true,
      server_name: 'www.logitech.com',
      utls: { enabled: true, fingerprint: 'chrome' },
      reality: {
        enabled: true,
        public_key: '${REALITY_PUBLIC_KEY}',
        short_id: '${REALITY_SHORT_ID}',
      },
    },
    transport: { type: 'httpupgrade', path: '/upgrade' },
  },

  hysteria2Salamander():: {
    type: 'hysteria2',
    tag: 'hysteria2-salamander',
    server: '${VPN_SERVER_IP}',
    server_port: 8443,
    password: '${HY2_PASSWORD}',
    tls: { enabled: true, server_name: 'bing.com', insecure: true },
    obfs: { type: 'salamander', password: '${SALAMANDER_PASSWORD}' },
  },

  tuic():: {
    type: 'tuic',
    tag: 'tuic',
    server: '${VPN_SERVER_IP}',
    server_port: 8444,
    uuid: '${VLESS_UUID}',
    password: '${TUIC_PASSWORD}',
    congestion_control: 'bbr',
    tls: { enabled: true, server_name: 'bing.com', insecure: true },
  },

  ssShadowtls():: {
    type: 'shadowsocks',
    tag: 'ss-shadowtls',
    method: '2022-blake3-aes-128-gcm',
    password: '${SS_PASSWORD}',
    detour: 'shadowtls-out',
  },

  shadowtlsOut():: {
    type: 'shadowtls',
    tag: 'shadowtls-out',
    server: '${VPN_SERVER_IP}',
    server_port: 8388,
    version: 3,
    password: '${SHADOWTLS_PASSWORD}',
    tls: {
      enabled: true,
      server_name: 'www.apple.com',
      utls: { enabled: true, fingerprint: 'firefox' },
    },
  },

  trojan():: {
    type: 'trojan',
    tag: 'trojan',
    server: '${VPN_SERVER_IP}',
    server_port: 8445,
    password: '${TROJAN_PASSWORD}',
    tls: { enabled: true, server_name: 'bing.com', insecure: true },
  },

  ssPlain():: {
    type: 'shadowsocks',
    tag: 'ss-plain',
    server: '${VPN_SERVER_IP}',
    server_port: 8389,
    method: '2022-blake3-aes-128-gcm',
    password: '${SS_PLAIN_PASSWORD}',
  },

  direct():: { type: 'direct', tag: 'direct' },

  // Predefined gRPC variants
  allGrpcVariants:: [
    self.vlessRealityGrpc('vless-reality-grpc', 443, 'www.microsoft.com'),
    self.vlessRealityGrpc('vless-reality-grpc-2053', 2053, 'dl.google.com'),
    self.vlessRealityGrpc('vless-reality-grpc-2083', 2083, 'www.samsung.com'),
    self.vlessRealityGrpc('vless-reality-grpc-64444', 64444, 'learn.microsoft.com'),
  ],

  linuxGrpcVariants:: [
    self.vlessRealityGrpc('vless-reality-grpc', 443, 'www.microsoft.com', 'chrome', 'grpc'),
  ],

  // Common protocol outbounds (non-gRPC)
  commonProtocols:: [
    self.vlessRealityHttpupgrade(),
    self.hysteria2Salamander(),
    self.tuic(),
    self.ssShadowtls(),
    self.shadowtlsOut(),
    self.trojan(),
    self.ssPlain(),
  ],

  // All outbound tags for selector/urltest (with all 4 gRPC)
  allTags:: [o.tag for o in self.allGrpcVariants + self.commonProtocols if o.tag != 'shadowtls-out'],

  // Linux outbound tags (1 gRPC)
  linuxTags:: [o.tag for o in self.linuxGrpcVariants + self.commonProtocols if o.tag != 'shadowtls-out'],

  udpTags:: ['hysteria2-salamander', 'tuic'],
  tcpTags:: ['ss-shadowtls', 'trojan', 'ss-plain'],

  selector(tags):: {
    type: 'selector',
    tag: 'proxy',
    outbounds: ['auto', 'vless-auto', 'udp-auto', 'tcp-auto'] + tags,
    default: 'hysteria2-salamander',
  },

  urltest(tags, interval='1m', tag='auto'):: {
    type: 'urltest',
    tag: tag,
    outbounds: tags,
    url: 'https://www.gstatic.com/generate_204',
    interval: interval,
    tolerance: 150,
    interrupt_exist_connections: true,
  },
}
