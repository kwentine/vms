# set static IP, gateway via host tap, and public DNS
sudo nmcli con mod ens3 \
  ipv4.method manual ipv4.addresses 10.42.0.10/24 \
  ipv4.gateway 10.42.0.1 \
  ipv4.dns 1.1.1.1

sudo nmcli con down ens3
sudo nmcli con up ens3
