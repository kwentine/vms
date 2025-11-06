#!/bin/env bash
if [[ "${1:-dhcp}" == dhcp ]]; then
  sudo tcpdump -v -v -v -nn -i qvm0  '(net 10.42.0.0/24 or host 255.255.255.255) and (udp dst port 67 or udp dst port 68)'
fi
