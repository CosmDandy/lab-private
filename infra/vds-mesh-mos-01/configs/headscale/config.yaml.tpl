# headscale will look for a configuration file named `config.yaml` (or `config.json`) in the following order:
#
# - `/etc/headscale`
# - `~/.headscale`
# - current working directory
# The url clients will connect to.
# Typically this will be a domain like:
#
# https://myheadscale.example.com:443
#
server_url: https://${DOMAIN}/
# Address to listen to / bind to on the server
#
# For production:
listen_addr: 0.0.0.0:8080
# Address to listen to /metrics and /debug, you may want
# to keep this endpoint private to your internal network
metrics_listen_addr: 0.0.0.0:9090
# Address to listen for gRPC.
# gRPC is used for controlling a headscale server
# remotely with the CLI
# Note: Remote access _only_ works if you have
# valid certificates.
#
# For production:
grpc_listen_addr: 0.0.0.0:50443
# Allow the gRPC admin interface to run in INSECURE
# mode. This is not recommended as the traffic will
# be unencrypted. Only enable if you know what you
# are doing.
grpc_allow_insecure: false
# The Noise section includes specific configuration for the
# TS2021 Noise protocol
noise:
  # The Noise private key is used to encrypt the traffic between headscale and
  # Tailscale clients when using the new Noise-based protocol. A missing key
  # will be automatically generated.
  private_key_path: /var/lib/headscale/noise_private.key
# List of IP prefixes to allocate tailaddresses from.
# Each prefix consists of either an IPv4 or IPv6 address,
# and the associated prefix length, delimited by a slash.
# It must be within IP ranges supported by the Tailscale
# client - i.e., subnets of 100.64.0.0/10 and fd7a:115c:a1e0::/48.
# See below:
# IPv6: https://github.com/tailscale/tailscale/blob/22ebb25e833264f58d7c3f534a8b166894a89536/net/tsaddr/tsaddr.go#LL81C52-L81C71
# IPv4: https://github.com/tailscale/tailscale/blob/22ebb25e833264f58d7c3f534a8b166894a89536/net/tsaddr/tsaddr.go#L33
# Any other range is NOT supported, and it will cause unexpected issues.
prefixes:
  v4: 100.64.0.0/10
  v6: fd7a:115c:a1e0::/48
  # Strategy used for allocation of IPs to nodes, available options:
  # - sequential (default): assigns the next free IP from the previous given IP.
  # - random: assigns the next free IP from a pseudo-random IP generator (crypto/rand).
  allocation: sequential
# DERP is a relay system that Tailscale uses when a direct
# connection cannot be established.
# https://tailscale.com/blog/how-tailscale-works/#encrypted-tcp-relays-derp
#
# headscale needs a list of DERP servers that can be presented
# to the clients.
derp:
  server:
    # If enabled, runs the embedded DERP server and merges it into the rest of the DERP config
    # The Headscale server_url defined above MUST be using https, DERP requires TLS to be in place
    enabled: true
    # Region ID to use for the embedded DERP server.
    # The local DERP prevails if the region ID collides with other region ID coming from
    # the regular DERP config.
    region_id: 1777
    # Region code and name are displayed in the Tailscale UI to identify a DERP region
    region_code: "headscale"
    region_name: "Headscale Embedded DERP"
    # Listens over UDP at the configured address for STUN connections - to help with NAT traversal.
    # When the embedded DERP server is enabled stun_listen_addr MUST be defined.
    #
    # For more details on how this works, check this great article: https://tailscale.com/blog/how-tailscale-works/
    # Only allow clients associated with this server access
    verify_clients: true
    stun_listen_addr: "0.0.0.0:3478"
    # Private key used to encrypt the traffic between headscale DERP and
    # Tailscale clients. A missing key will be automatically generated.
    private_key_path: /var/lib/headscale/derp_server_private.key
    # This flag can be used, so the DERP map entry for the embedded DERP server is not written automatically,
    # it enables the creation of your very own DERP map entry using a locally available file with the parameter DERP.paths
    # If you enable the DERP server and set this to false, it is required to add the DERP server to the DERP map using DERP.paths
    automatically_add_embedded_derp_region: true
    # For better connection stability (especially when using an Exit-Node and DNS is not working),
    # it is possible to optionally add the public IPv4 and IPv6 address to the Derp-Map using:
    ipv4: ${SERVER_IP}
  # List of externally available DERP maps encoded in JSON
  urls:
    - https://controlplane.tailscale.com/derpmap/default
  # Locally available DERP map files encoded in YAML
  #
  # This option is mostly interesting for people hosting
  # their own DERP servers:
  # https://tailscale.com/kb/1118/custom-derp-servers/
  #
  # paths:
  #   - /etc/headscale/derp-example.yaml
  paths: []
  # If enabled, a worker will be set up to periodically
  # refresh the given sources and update the derpmap
  # will be set up.
  auto_update_enabled: true
  # How often should we check for DERP updates?
  update_frequency: 24h
# Disables the automatic check for headscale updates on startup
disable_check_updates: false
# Time before an inactive ephemeral node is deleted?
ephemeral_node_inactivity_timeout: 30m
database:
  # Database type. Available options: sqlite, postgres
  # Please note that using Postgres is highly discouraged as it is only supported for legacy reasons.
  # All new development, testing and optimisations are done with SQLite in mind.
  type: sqlite
  # Enable debug mode. This setting requires the log.level to be set to "debug" or "trace".
  debug: false
  # GORM configuration settings.
  gorm:
    # Enable prepared statements.
    prepare_stmt: true
    # Enable parameterized queries.
    parameterized_queries: true
    # Skip logging "record not found" errors.
    skip_err_record_not_found: true
    # Threshold for slow queries in milliseconds.
    slow_threshold: 1000
  # SQLite config
  sqlite:
    path: /var/lib/headscale/db.sqlite
    # Enable WAL mode for SQLite. This is recommended for production environments.
    # https://www.sqlite.org/wal.html
    write_ahead_log: true
    # Maximum number of WAL file frames before the WAL file is automatically checkpointed.
    # https://www.sqlite.org/c3ref/wal_autocheckpoint.html
    # Set to 0 to disable automatic checkpointing.
    wal_autocheckpoint: 1000
log:
  # Output formatting for logs: text or json
  format: text
  level: info
## Policy
# headscale supports Tailscale's ACL policies.
# Please have a look to their KB to better
# understand the concepts: https://tailscale.com/kb/1018/acls/
policy:
  # The mode can be "file" or "database" that defines
  # where the ACL policies are stored and read from.
  mode: database
  # If the mode is set to "file", the path to a
  # HuJSON file containing ACL policies.
  path: "/etc/headscale/acl.json"
## DNS
#
# headscale supports Tailscale's DNS configuration and MagicDNS.
# Please have a look to their KB to better understand the concepts:
#
# - https://tailscale.com/kb/1054/dns/
# - https://tailscale.com/kb/1081/magicdns/
# - https://tailscale.com/blog/2021-09-private-dns-with-magicdns/
#
dns:
  magic_dns: true
  base_domain: hamster
  override_local_dns: true
  nameservers:
    global:
      - 1.1.1.1
      - 1.0.0.1
      - 2606:4700:4700::1111
      - 2606:4700:4700::1001
    split: {}
  search_domains: []
  extra_records: []

unix_socket: /var/run/headscale/headscale.sock
unix_socket_permission: "0770"

logtail:
  enabled: false
randomize_client_port: false
taildrop:
  enabled: true
