# TODO Duplicate in qvm-run
macs=(
  cp "52:54:3b:7b:ca:11"
  wk-1 "52:54:50:67:15:55"
  wk-2 "52:54:0b:a0:c2:15"
)

ips=(
  cp 10
  wk-1 11
  wk-2 12
)

opts=(
  # Debugging
  --no-daemon
  --log-queries
  --log-dhcp
  # Interface
  --interface=qvm0
  --local-service=net
  --bind-interfaces
  # Ignore /etc/hosts for now
  --no-hosts
  # Specify upstreams directly
  --no-resolv
  -S 1.1.1.1 -S 8.8.8.8
  # Hard-coded hosts, probably not the best idea
  --host-record=cp.qvm0.lan,10.42.0.10
  --host-record=wk-1.qvm0.lan,10.42.0.11
  # Another fancier variant
  --dynamic-host=wk-2.qvm0.lan,0.0.0.12,qvm0
  # A friendly TXT record
  --txt-record=gw.qvm0,"Your gateway to the world."
  # CNAME records
  --cname=cp,cp.qvm0,cp.qvm0.lan
  --cname=wk-1,wk-1.qvm0,wk-1.qvm0.lan
  --cname=wk-2,wk-2.qvm0,wk-2.qvm0.lan
  # Derive an A record from an interface address
  --interface-name=gw.qvm0.lan,qvm0/4
  # extra-1.qvm0.lan returns 10.42.0.101
  --synth-domain=qvm0.lan,10.42.0.100,10.42.0.110,"extra-*"
  # dump packets for debugging
  --dumpfile "${QVM_DIR:-/var/vms}/run/dnsmasq.pcap"
  # zone of authority
  --auth-zone=qvm0.lan
  # DHCP
  --dhcp-authoritative
  --domain=qvm0.lan
  # Range for extra nodes
  --dhcp-range=tag:extra,10.42.0.100,10.42.0.110
  # Could also try something like:
  # --dhcp-range=tag:services,10.42.0.2,10.42.0.9
  --dhcp-host="${macs[cp]},cp,10.42.0.${ips[cp]}"
  --dhcp-host="${macs[wk-1]},wk-1,10.42.0.${ips[wk-1]}"
  --dhcp-host="${macs[wk-2]},wk-2,10.42.0.${ips[wk-2]}"
)
sudo dnsmasq
