#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/opt/backups/headscale"
DB_PATH="/var/lib/docker/volumes/headscale_data/_data/db.sqlite"
RETENTION_WEEKS=8
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/headscale-${TIMESTAMP}.db"

REMOTE_HOST="${BACKUP_REMOTE_HOST:-}"
REMOTE_DIR="${BACKUP_REMOTE_DIR:-/opt/backups/headscale}"
REMOTE_USER="${BACKUP_REMOTE_USER:-root}"

mkdir -p "$BACKUP_DIR"

sqlite3 "$DB_PATH" ".backup '$BACKUP_FILE'"
gzip "$BACKUP_FILE"
BACKUP_FILE="${BACKUP_FILE}.gz"
echo "Backup: $BACKUP_FILE ($(du -h "$BACKUP_FILE" | cut -f1))"

if [[ -n "$REMOTE_HOST" ]]; then
  ssh "${REMOTE_USER}@${REMOTE_HOST}" "mkdir -p ${REMOTE_DIR}"
  scp "$BACKUP_FILE" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"
  ssh "${REMOTE_USER}@${REMOTE_HOST}" \
    "find ${REMOTE_DIR} -name 'headscale-*.db.gz' -mtime +$((RETENTION_WEEKS * 7)) -delete"
fi

find "$BACKUP_DIR" -name "headscale-*.db.gz" -mtime +$((RETENTION_WEEKS * 7)) -delete
