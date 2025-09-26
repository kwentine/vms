# Installation DVD
iso_path           = "/path/to/iso"
iso_checksum_type  = "sha256"
iso_checksum_value = "edce2dd6f8e1d1b2ff0b204f89b0659bc9e320d175beb7caad60712957a19608"

# User credentials
root_allow_login      = true
root_password_crypted = "$6$sugar$sdfsdfsd.EgQwcVX5AaPCyCDe9fZ1GYBW1ULT8wTueJV2.xqGbJ0dBZvHwSE4yRQA06uZ8b/LReljnr4HtDSJT1"
user_name             = "guest"
user_password_crypted = "$6$sugar$sdfsdfsdfsdfsdf/u5255EiDtHSc5KRrq0WmSNULgI.BzWz7QMODAh2oOOm7j.3iOooUO/RiyHgA5hLVHY.cqW/"
user_ssh_public_key   = "ssh-ed25519 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWxleK9RNC9lxZotL95FttjZkgwrlc5TUsdfwresdfsdffrew"

# System registration
register_system     = false
rhel_org            = "foo"
rhel_activation_key = "bar"

# Disk
disk_size             = 8
disk_name             = "server-base"
disk_output_directory = "/path/to/vm/templates"

# Installation parameters
install_headless = false
install_ks_path  = "ks.pkrtpl.hcl"
