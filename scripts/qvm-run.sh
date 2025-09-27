#!/bin/bash
set -eu

help_msg="
Run a VM from a disk in QVM_DIR/machines.
Foward host SSH_PORT (defaut: 2222) to port 22 on the guest.
Optionally enable cloud-init served over HTTP,
assuming a server is listening on host CI_PORT (default: 8000).

Usage: $(basename "$0") [-n] [-e] [-i CI_PORT] [-p SSH_PORT] DISK_NAME
"

declare -r MACHINES_DIR="${QVM_DIR:-$(pwd)}/machines"

declare dry_run cloud_init \
        uefi ssh_port \
        cloud_init_port detach
dry_run=0
detach=0
cloud_init=0
uefi=0
ssh_port=2222

while getopts ehnp:i:d opt; do
  case "${opt}" in
    n)
      dry_run=1 ;;
    h)
      echo "${help_msg}"
      exit ;;
    i)
      cloud_init=1
      cloud_init_port="${OPTARG}" ;;
    e)
      uefi=1 ;;
    p)
      ssh_port="${OPTARG}" ;;
    d)
      detach=1 ;;
    *) exit 1 ;;
  esac
done
shift $((OPTIND - 1))

declare drive="${1:-}"

if [[ -z "${drive}" ]]; then
  echo "ERROR: required argument: DISK_NAME"
  exit 1
fi

if ! [[ -f "${MACHINES_DIR}/${drive}" ]]; then
  echo "ERROR: ${drive} not found in ${MACHINES_DIR}"
  exit
fi

declare -a cmd args
if ((dry_run)); then
  cmd=(echo)
fi
cmd+=(qemu-system-x86_64)

declare -a args=(
  -accel kvm
  -cpu host
  -smp 4
  -m 8G
  -drive "file=${MACHINES_DIR}/${drive},if=virtio"
  -nic "user,hostfwd=tcp::${ssh_port}-:22"
)

if ((cloud_init)); then
  echo "INFO: Running with cloud-init, served on port ${cloud_init_port}"
  args+=(-smbios "type=1,serial=ds=nocloud;s=http://10.0.2.2:${cloud_init_port}")
fi

if ((uefi)); then
  echo "INFO: Booting with UEFI"
  args+=(-drive "if=pflash,format=raw,readonly=on,file=/usr/share/edk2/ovmf/OVMF_CODE.fd")
fi

if ((detach)); then
  args+=(
    -display none
    -serial pty
  )
fi

"${cmd[@]}" "${args[@]}"
