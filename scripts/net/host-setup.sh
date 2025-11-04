#!/bin/sh
set -eu

if sudo nft -f "$(dirname $0)/qvm.nft"; then
  sudo nft list table inet qvm
fi

sudo sysctl -w net.ipv4.ip_forward=1

# DNS resolution
sudo resolvectl dns qvm0 10.42.0.1
sudo resolvectl domain qvm0 "qvm0.lan"
sudo resolvectl default-route qvm0 no
