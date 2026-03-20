#!/usr/bin/env bash
set -euo pipefail

# Required env vars: S3_ACCESS_KEY, S3_SECRET_KEY, S3_BUCKET, S3_ENDPOINT

for var in S3_ACCESS_KEY S3_SECRET_KEY S3_BUCKET S3_ENDPOINT; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: $var is not set" >&2
    exit 1
  fi
done

VOLUME_PATH=$(docker volume inspect headscale_data --format '{{ .Mountpoint }}')
TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
TMP_DIR=$(mktemp -d)
BACKUP_DIR="$TMP_DIR/headscale"
ARCHIVE="headscale-${TIMESTAMP}.tar.gz"

trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "$BACKUP_DIR"

# Consistent SQLite backup (no container stop needed)
sqlite3 "$VOLUME_PATH/db.sqlite" ".backup '$BACKUP_DIR/db.sqlite'"

# Copy key files
for key in noise_private.key derp_server_private.key; do
  if [[ -f "$VOLUME_PATH/$key" ]]; then
    cp "$VOLUME_PATH/$key" "$BACKUP_DIR/"
  fi
done

tar -czf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR" headscale

# Configure rclone via env vars (no config file needed)
export RCLONE_CONFIG_S3_TYPE=s3
export RCLONE_CONFIG_S3_PROVIDER=Other
export RCLONE_CONFIG_S3_ACCESS_KEY_ID="$S3_ACCESS_KEY"
export RCLONE_CONFIG_S3_SECRET_ACCESS_KEY="$S3_SECRET_KEY"
export RCLONE_CONFIG_S3_ENDPOINT="https://$S3_ENDPOINT"
export RCLONE_CONFIG_S3_REGION="hel1"

# Upload as latest (always current)
rclone copyto "$TMP_DIR/$ARCHIVE" "s3:$S3_BUCKET/headscale/latest.tar.gz"

# Upload timestamped archive
rclone copy "$TMP_DIR/$ARCHIVE" "s3:$S3_BUCKET/headscale/archive/"

# Cleanup archives older than 30 days
rclone delete "s3:$S3_BUCKET/headscale/archive/" --min-age 30d

echo "Backup complete: $ARCHIVE"
