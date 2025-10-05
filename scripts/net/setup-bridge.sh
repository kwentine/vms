#!/bin/bash
set -eu

# Adapted from:
# https://wiki.archlinux.org/title/QEMU/Advanced_networking

br_addr="10.42.0.1/24"
br_name="${1:-qvm0}"
if ! ip link show "${br_name}" &> /dev/null ; then
    sudo ip link add name "${br_name}" type bridge &> /dev/null
    sudo ip link set dev "${br_name}" up
    sudo ip addr add "${br_addr}" dev "${br_name}"
fi

declare -i nports n
declare port_name
nports="${2:-1}"
for (( n=0 ; n < nports; n++ )); do
  printf -v port_name 'qvmtap%d' ${n}
  if ! ip link show "${port_name}" &> /dev/null; then
    echo "Create TAP device ${port_name}, plugged into bridge ${br_name}"
    sudo ip tuntap add mode tap "${port_name}" user "${USER}"
    sudo ip link set dev "${port_name}" master "${br_name}"
  fi
done
unset port_name n nports

teardown=0
if ((teardown)) ; then
  sudo ip addr del dev "${br_name}" "${br_addr}"
  sudo ip link set dev "${br_name}" down
  sudo ip link delete "${br_name}" type bridge
fi
