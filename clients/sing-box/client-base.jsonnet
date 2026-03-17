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
      route_exclude_address: route.excludeAddresses,
      exclude_interface: ['utun4'],
    },
  ],
  local vlessTags = outbounds.vlessTagsList,
  outbounds:
    [outbounds.selector(outbounds.allTags)]
    + [outbounds.urltest(outbounds.allTags)]
    + [outbounds.urltest(vlessTags, tag='vless-auto')]
    + [outbounds.urltest(outbounds.udpTags, tag='udp-auto')]
    + [outbounds.urltest(outbounds.tcpTags, tag='tcp-auto')]
    + outbounds.allGrpcVariants
    + outbounds.commonProtocols
    + [outbounds.direct()],
  route: route.base({ default_domain_resolver: 'local' }),
  experimental: {
    clash_api: {
      external_controller: '127.0.0.1:9090',
      external_ui: 'ui',
      external_ui_download_url: 'https://github.com/MetaCubeX/metacubexd/archive/gh-pages.zip',
      external_ui_download_detour: 'direct',
    },
    cache_file: { enabled: true, path: 'cache.db' },
  },
}
