local outbounds = import 'lib/outbounds.libsonnet';
local route = import 'lib/route.libsonnet';

{
  log: { level: 'info', timestamp: true },
  dns: {
    servers: [
      { type: 'https', tag: 'remote', server: '1.1.1.1', domain_resolver: 'local' },
      { type: 'local', tag: 'local' },
    ],
    rules: route.dnsRules,
    strategy: 'ipv4_only',
  },
  inbounds: [
    {
      type: 'tun',
      tag: 'tun-in',
      interface_name: 'sing-tun',
      address: ['172.19.0.1/30'],
      mtu: 1400,
      auto_route: true,
      strict_route: false,
      stack: 'mixed',
      exclude_interface: ['docker0'],
      route_exclude_address: route.excludeAddresses,
    },
    {
      type: 'mixed',
      tag: 'mixed-in',
      listen: '172.17.0.1',
      listen_port: 7890,
    },
  ],
  local vlessTags = [o.tag for o in outbounds.linuxGrpcVariants] + ['vless-reality-httpupgrade'],
  outbounds:
    [outbounds.selector(outbounds.linuxTags)]
    + [outbounds.urltest(outbounds.linuxTags)]
    + [outbounds.urltest(vlessTags, tag='vless-auto')]
    + [outbounds.urltest(outbounds.udpTags, tag='udp-auto')]
    + [outbounds.urltest(outbounds.tcpTags, tag='tcp-auto')]
    + outbounds.linuxGrpcVariants
    + outbounds.commonProtocols
    + [outbounds.direct()],
  route: route.base({ default_domain_resolver: 'local' }),
}
