#!/bin/bash
set -eu

main() {
  local cloud_init=0
  local uefi=0

  while getopts ie opt; do
    case "${opt}" in
      i) cloud_init=1 ;;
      e) uefi=1 ;;
      \?) >&2 echo "Unknown option: ${opt}" && exit 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local drive="${1}"
  local format="${drive##*.}"

  local -a quemu_args=(
    -accel kvm
    -cpu host
    -smp 4 -m 8G
    -drive file="${drive}",if=virtio,format="${format}"
    -nic user,hostfwd=tcp::2222-:22
  )

  if ((cloud_init)); then
    >&2 echo "Running with cloud-init enabled"
    quemu_args+=(-smbios type=1,serial=ds='nocloud;s=http://10.0.2.2:8000/')
  fi

  if ((uefi)); then
    >&2 echo "Booting with UEFI"
    quemu_args+=(-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/ovmf/OVMF_CODE.fd)
  fi

  qemu-system-x86_64 "${quemu_args[@]}"
}

main "$@"
