#!/bin/bash
# Fix routing conflict between sing-box tun and Tailscale
# sing-box's route_exclude_address doesn't properly exclude Tailscale on macOS

TS_IF=$(ifconfig | grep -B5 "inet 100.64" | grep "^utun" | head -1 | cut -d: -f1)

if [ -z "$TS_IF" ]; then
    echo "Tailscale interface not found"
    exit 1
fi

# Remove conflicting route from LAN gateway if exists
route delete -net 100.64.0.0/10 192.168.20.1 2>/dev/null

# Add route via Tailscale interface
route add -net 100.64.0.0/10 -interface "$TS_IF"

echo "Route 100.64.0.0/10 → $TS_IF"
