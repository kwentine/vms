#!/bin/sh
set -eu

firewall="${1:-nft}"
if [[ "${firewall}" == firewalld ]]; then
  sudo firewall-cmd --state
  policy_name="qvm-nat"
  if ! sudo firewall-cmd --info-policy="${policy_name}" &> /dev/null; then
    echo "Creating policy ${policy_name}"
    sudo firewall-cmd --permanent --new-policy="${policy_name}"
    sudo firewall-cmd --permanent --policy="${policy_name}" --set-target=ACCEPT
    sudo firewall-cmd --permanent --policy="${policy_name}" --set-short="Forward and NAT traffic from internal to public"
    sudo firewall-cmd --reload
  fi

  {
    sudo firewall-cmd --policy "${policy_name}" --add-ingress-zone internal
    sudo firewall-cmd --policy "${policy_name}" --add-egress-zone public
    sudo firewall-cmd --policy="${policy_name}" --add-masquerade
  } &> /dev/null

  # Add interface to the internal zone
  ifname="${1:-qvm0}"
  if ! ip link show "${ifname}" &> /dev/null; then
    echo "Interface ${ifname} does not exist."
  else
    sudo firewall-cmd --zone=internal --add-interface="${ifname}"
  fi
  sudo firewall-cmd --info-policy="${policy_name}"
elif [[ "${firewall}" == nft ]]; then
  if sudo nft -f "$(dirname $0)/qvm.nft"; then
    sudo nft list table inet qvm
  fi
else
  echo "ERROR: Invalid argument ${0}"
  echo "Usage: ${0} {firewalld | nft}"
  exit 1
fi

sudo sysctl -w net.ipv4.ip_forward=1
