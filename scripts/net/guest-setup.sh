# set static IP, gateway via host tap, and public DNS

conn_settings=(
     ipv4.method manual
     ipv4.addresses 10.42.0.10/24
     ipv4.gateway 10.42.0.1
     ipv4.dns 1.1.1.1
)

sudo nmcli con add type ethernet \
     ifname ens3 \
     con-name ens3-static \
     "${conn_settings[@]}"

sudo nmcli con up ens3-static
