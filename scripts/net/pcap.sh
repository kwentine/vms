#!/bin/env bash
if [[ "${1:-dhcp}" == dhcp ]]; then
  sudo tcpdump -nn -i qvm0 -e '(net 10.42.0.0/24 or ip broadcast) and port 67 or 68'
fi
