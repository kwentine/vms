#!/bin/sh
set -eu

if sudo nft -f "$(dirname $0)/qvm.nft"; then
  sudo nft list table inet qvm
fi

sudo sysctl -w net.ipv4.ip_forward=1
