# enable IPv4 forwarding until reboot (safe, easy to revert)
set -eux

# Assumes the following permanent setup:
# sudo firewall-cmd --new-policy qvm-nat --permanent
# sudo firewall-cmd --reload

sudo sysctl -w net.ipv4.ip_forward=1
sudo firewall-cmd --permanent --zone=public --add-masquerade
sudo firewall-cmd --policy qvm-nat --add-ingress-zone internal
sudo firewall-cmd --policy qvm-nat --add-egress-zone public

# Add interface to the internal zone
ifname="${1:-tap0}"
if ! ip link show "${ifname}" &> /dev/null; then
  echo "Interface ${ifname} must be created before it can be added to the internal zone."
  exit 1
fi

sudo firewall-cmd --zone=internal --add-interface=tap0
