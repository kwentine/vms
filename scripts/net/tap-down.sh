#!/usr/bin/env bash
set -eu
echo "$(basename $0) called with arguments: $@"

# Usage: ./tap-down.sh [ifname]
ifname="${1:-tap0}"

if ip link show "${ifname}" &>/dev/null; then
  # best effort: down + delete
  sudo ip link set "${ifname}" down || true
  sudo ip addr flush dev "${ifname}" || true
  sudo ip link delete "${ifname}" || true
  echo "TAP ${ifname} removed."
else
  echo "TAP ${ifname} does not exist, nothing to do."
fi
