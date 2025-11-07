sudo subscription-manager config --rhsm.manage_repos=0

cat <<EOF > /etc/yum.repos.d/dvd.repo
[rhel-baseos]
name=RHEL BaseOS
baseurl=file:///mnt/dvd/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///mnt/dvd/RPM-GPG-KEY-redhat-release

[rhel-appstream]
name=RHEL AppStream
baseurl=file:///mnt/dvd/AppStream
enabled=1
gpgcheck=1
gpgkey=file:///mnt/dvd/RPM-GPG-KEY-redhat-release
EOF

echo "/dev/cdrom /mnt/dvd iso9660 ro,defaults 0 0" | sudo tee -a /etc/fstab
