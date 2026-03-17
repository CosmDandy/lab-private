local outbounds = import 'lib/outbounds.libsonnet';
local route = import 'lib/route.libsonnet';

{
  log: { level: 'info', timestamp: true },
  dns: {
    servers: [
      { address: 'https://1.1.1.1/dns-query', tag: 'remote', address_resolver: 'local' },
      { address: 'local', tag: 'local' },
      { address: 'rcode://success', tag: 'block' },
    ],
    rules: route.dnsRulesLegacy,
    strategy: 'ipv4_only',
  },
  inbounds: [
    {
      type: 'tun',
      tag: 'tun-in',
      address: ['172.19.0.1/30', 'fdfe:dcba:9876::1/126'],
      mtu: 1400,
      auto_route: true,
      strict_route: true,
      stack: 'mixed',
      route_exclude_address: route.excludeAddresses,
    },
  ],
  local vlessTags = [o.tag for o in outbounds.allGrpcVariants] + ['vless-reality-httpupgrade'],
  outbounds:
    [outbounds.selector(outbounds.allTags)]
    + [outbounds.urltest(outbounds.allTags, '10m')]
    + [outbounds.urltest(vlessTags, '10m', 'vless-auto')]
    + [outbounds.urltest(outbounds.udpTags, '10m', 'udp-auto')]
    + [outbounds.urltest(outbounds.tcpTags, '10m', 'tcp-auto')]
    + outbounds.allGrpcVariants
    + outbounds.commonProtocols
    + [outbounds.direct()],
  route: route.base(),
}
