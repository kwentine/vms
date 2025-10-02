#!/usr/bin/env bash
set -eu

# Bring up tap interface
addr=10.42.0.1/24
ifname="${1:-tap0}"
if ip tuntap list | grep "${ifname}" > /dev/null; then
  echo "Interface ${ifname} already exists"
  exit
fi

# Not exactly sure about user/group options
sudo ip tuntap add mode tap user "$(id -u)" "${ifname}"
sudo ip addr add "${addr}" dev "${ifname}"
sudo ip link set "${ifname}" up

echo "TAP tap0 is up with address ${addr}"
