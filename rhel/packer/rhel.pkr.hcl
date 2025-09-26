packer {
  required_version = ">= 1.7.0"
  required_plugins {
    qemu = {
      version = "~> 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

locals {
  build_time     = timestamp()
  install_ks     = templatefile("${var.install_ks_path}", var)
}

source "qemu" "base" {
  efi_boot = true
  # General
  vm_name = "${var.disk_name}-${local.build_time}.qcow2"
  communicator = "none"
  # Machine Configuration
  iso_url            = var.iso_path
  iso_checksum       = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  output_directory   = "${var.disk_output_directory}"
  disk_size          = "${var.disk_size}G"
  format             = "qcow2"
  accelerator        = "kvm"
  cpus               = 4
  memory             = 8192
  net_device         = "virtio-net"
  disk_interface     = "virtio"
  headless           = var.install_headless
  cpu_model          = "host"

  # Boot Configuration
  http_content = {
    "/ks.cfg" = local.install_ks
  }
  boot_wait          = "1s"
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    "<wait><leftCtrlOn>x<leftCtrlOff>"
  ]
 shutdown_timeout = "30m"

}

build {
  name = "rhel"
  sources = ["source.qemu.base"]
}
