#!/usr/bin/env bash
set -euo pipefail

# Protocol benchmark script for sing-box
# Measures latency (TTFB) and throughput for each configured outbound
#
# Usage: ./bench-protocols.sh [sing-box-config.json]
# Requires: sing-box running with API enabled, curl

SING_BOX_API="${SING_BOX_API:-http://127.0.0.1:9090}"
TEST_URL="${TEST_URL:-https://speed.cloudflare.com/__down?bytes=10485760}"
LATENCY_URL="${LATENCY_URL:-https://www.gstatic.com/generate_204}"
ITERATIONS="${ITERATIONS:-3}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

header() { printf "\n${CYAN}=== %s ===${NC}\n" "$1"; }

# Get list of outbounds from sing-box API
get_outbounds() {
    curl -s "${SING_BOX_API}/outbounds" | jq -r '.[].tag' 2>/dev/null \
        | grep -vE '^(direct|dns-out|proxy|auto|block)$'
}

# Select outbound via API
select_outbound() {
    local tag="$1"
    curl -s -X PUT "${SING_BOX_API}/outbounds/proxy" \
        -H 'Content-Type: application/json' \
        -d "{\"tag\":\"${tag}\"}" >/dev/null 2>&1
}

# Measure latency (average TTFB over N iterations)
measure_latency() {
    local total=0 success=0
    for ((i = 1; i <= ITERATIONS; i++)); do
        local ttfb
        ttfb=$(curl -so /dev/null -w '%{time_starttransfer}' \
            --max-time 10 "$LATENCY_URL" 2>/dev/null) || continue
        total=$(echo "$total + $ttfb" | bc)
        ((success++))
    done
    if ((success > 0)); then
        echo "scale=0; ($total / $success) * 1000" | bc
    else
        echo "timeout"
    fi
}

# Measure throughput (download 10MB, report Mbps)
measure_throughput() {
    local speed
    speed=$(curl -so /dev/null -w '%{speed_download}' \
        --max-time 30 "$TEST_URL" 2>/dev/null) || { echo "timeout"; return; }
    echo "scale=1; $speed * 8 / 1048576" | bc
}

main() {
    header "sing-box Protocol Benchmark"
    echo "Latency URL:    $LATENCY_URL"
    echo "Throughput URL:  $TEST_URL"
    echo "Iterations:      $ITERATIONS"

    local outbounds
    outbounds=$(get_outbounds)

    if [[ -z "$outbounds" ]]; then
        echo "Error: no outbounds found. Is sing-box API running on ${SING_BOX_API}?"
        echo ""
        echo "Add to your sing-box config:"
        echo '  "experimental": { "clash_api": { "external_controller": "127.0.0.1:9090" } }'
        exit 1
    fi

    printf "\n${YELLOW}%-35s %12s %12s${NC}\n" "OUTBOUND" "LATENCY(ms)" "SPEED(Mbps)"
    printf '%.0s-' {1..62}; echo

    for tag in $outbounds; do
        printf "%-35s " "$tag"

        select_outbound "$tag"
        sleep 1

        local latency throughput
        latency=$(measure_latency)
        throughput=$(measure_throughput)

        if [[ "$latency" == "timeout" ]]; then
            printf "${RED}%12s %12s${NC}\n" "timeout" "-"
        else
            local color="$GREEN"
            ((latency > 300)) && color="$YELLOW"
            ((latency > 800)) && color="$RED"
            printf "${color}%12s${NC} " "${latency}ms"

            color="$GREEN"
            local speed_int=${throughput%.*}
            ((speed_int < 20)) && color="$YELLOW"
            ((speed_int < 5)) && color="$RED"
            printf "${color}%11s${NC}\n" "${throughput}Mbps"
        fi
    done

    echo ""
}

main "$@"
