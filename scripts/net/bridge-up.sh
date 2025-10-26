#!/bin/bash
set -eu

# Adapted from:
# https://wiki.archlinux.org/title/QEMU/Advanced_networking

br_addr="10.42.0.1/24"
br_name="${1:-qvm0}"
if ! ip link show "${br_name}" &> /dev/null ; then
  sudo ip link add name "${br_name}" type bridge &> /dev/null
  sudo ip addr add "${br_addr}" dev "${br_name}"
  sudo ip link set dev "${br_name}" up
fi

declare -i nports n
declare port_name
nports="${2:-1}"
for (( n=0 ; n < nports; n++ )); do
  printf -v port_name '%stap%d' "${br_name}" "${n}"
  if ! ip link show "${port_name}" &> /dev/null; then
    echo "Create TAP device ${port_name}, plugged into bridge ${br_name}"
    sudo ip tuntap add mode tap "${port_name}" user "${USER}"
    sudo ip link set dev "${port_name}" master "${br_name}"
    sudo ip link set dev "${port_name}" up
  fi
done
unset port_name n nports

# Additional veth pairs to plug into the bridge.
# Only one for now, put into a separate namespace.

create_netns=1
netns_name=qvm
if ((create_netns)) && ! ip netns list | grep "${netns_name}"; then
  echo "INFO: Creating network namespace ${qvm}"
  sudo ip netns add "${netns_name}"
fi

sudo ip link add veth0 type veth peer name veth0p
sudo ip link set dev veth0 master "${br_name}"
sudo ip link set veth0p netns qvm
sudo ip -n qvm set veth0p name eth0
sudo ip -n qvm addr add 10.42.0.2/24 dev eth0
sudo ip -n qvm route add default via 10.42.0.1
sudo ip -n qvm link set dev eth0 up

teardown=0
if ((teardown)) ; then
  sudo ip addr del dev "${br_name}" "${br_addr}"
  sudo ip link set dev "${br_name}" down
  sudo ip link delete "${br_name}" type bridge
fi
