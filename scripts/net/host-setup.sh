#!/bin/sh
set -eu

sudo sysctl -w net.ipv4.ip_forward=1

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
  sudo firewall-cmd --info-policy="${policy_name}"
} &> /dev/null

# Add interface to the internal zone
ifname="${1:-tap0}"
if ! ip link show "${ifname}" &> /dev/null; then
  echo "Interface ${ifname} does not exist."
else
  sudo firewall-cmd --zone=internal --add-interface="${ifname}"
fi
