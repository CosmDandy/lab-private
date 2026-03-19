# Configuration for the Headplane server and web application
server:
  host: "0.0.0.0"
  port: 3000

  # The secret used to encode and decode web sessions
  # Ensure that this is exactly 32 characters long
  cookie_secret: "${COOKIE_SECRET}"

  # Should the cookies only work over HTTPS?
  # Set to false if running via HTTP without a proxy
  # (I recommend this is true in production)
  cookie_secure: true

# Headscale specific settings to allow Headplane to talk
# to Headscale and access deep integration features
headscale:
  # The URL to your Headscale instance
  # (All API requests are routed through this URL)
  # (THIS IS NOT the gRPC endpoint, but the HTTP endpoint)
  #
  # IMPORTANT: If you are using TLS this MUST be set to `https://`
  url: "http://headscale:8080"

  # Path to the Headscale configuration file
  config_path: "/etc/headscale/config.yaml"

  # Headplane internally validates the Headscale configuration
  config_strict: true

# Integration configurations for Headplane to interact with Headscale
integration:
  docker:
    enabled: true
    container_name: "headscale"
  kubernetes:
    enabled: false
    validate_manifest: true
    pod_name: "headscale"
  proc:
    enabled: false
