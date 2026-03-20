local blockTags = ['geosite-ads'];
local directTags = ['geosite-ru', 'geoip-ru', 'geosite-yandex', 'geosite-mailru', 'geosite-gov-ru'];

local rules = [
  { action: 'sniff' },
  { protocol: 'dns', action: 'hijack-dns' },
  { ip_cidr: ['${SERVER_IPV4}/32'], action: 'route', outbound: 'direct' },
  { ip_is_private: true, action: 'route', outbound: 'direct' },
  { rule_set: blockTags, action: 'reject' },
  { rule_set: directTags, action: 'route', outbound: 'direct' },
];

local ruleSet(tag, repo, path) = {
  type: 'remote',
  tag: tag,
  format: 'binary',
  url: 'https://raw.githubusercontent.com/SagerNet/sing-' + repo + '/rule-set/' + path + '.srs',
  download_detour: 'proxy',
};

local ruleSets = [
  ruleSet('geosite-ru', 'geosite', 'geosite-category-ru'),
  ruleSet('geoip-ru', 'geoip', 'geoip-ru'),
  ruleSet('geosite-yandex', 'geosite', 'geosite-yandex'),
  ruleSet('geosite-mailru', 'geosite', 'geosite-mailru'),
  ruleSet('geosite-gov-ru', 'geosite', 'geosite-category-gov-ru'),
  ruleSet('geosite-ads', 'geosite', 'geosite-category-ads-all'),
];

local excludeAddresses = [
  '100.64.0.0/10',
  '10.0.0.0/8',
  '172.16.0.0/12',
  '192.168.0.0/16',
];

{
  excludeAddresses:: excludeAddresses,

  dnsRules:: [
    { rule_set: blockTags, action: 'reject' },
    { rule_set: directTags, server: 'local' },
  ],

  dnsRulesLegacy:: [
    { rule_set: blockTags, server: 'block' },
    { rule_set: directTags, server: 'local' },
  ],

  base(extra={}):: {
    rules: rules,
    rule_set: ruleSets,
    auto_detect_interface: true,
    final: 'proxy',
  } + extra,
}
