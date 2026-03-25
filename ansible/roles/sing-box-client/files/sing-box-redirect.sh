#!/bin/sh
set -e
CHAIN="SING_BOX_REDIRECT"
PORT="${REDIRECT_PORT:-7891}"

case "$1" in
  start)
    iptables -t nat -N "$CHAIN" 2>/dev/null || iptables -t nat -F "$CHAIN"
    iptables -t nat -A "$CHAIN" -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A "$CHAIN" -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A "$CHAIN" -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A "$CHAIN" -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A "$CHAIN" -d 100.64.0.0/10 -j RETURN
    iptables -t nat -A "$CHAIN" -p tcp -j REDIRECT --to-port "$PORT"
    iptables -t nat -C PREROUTING -s 172.16.0.0/12 -j "$CHAIN" 2>/dev/null || \
      iptables -t nat -A PREROUTING -s 172.16.0.0/12 -j "$CHAIN"
    ;;
  stop)
    while iptables -t nat -D PREROUTING -s 172.16.0.0/12 -j "$CHAIN" 2>/dev/null; do :; done
    iptables -t nat -F "$CHAIN" 2>/dev/null || true
    iptables -t nat -X "$CHAIN" 2>/dev/null || true
    ;;
  *)
    echo "Usage: $0 {start|stop}" >&2
    exit 1
    ;;
esac
