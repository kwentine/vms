#!/bin/bash
set -eu

main() {
  local iso disk size
  local nographics=0
  while getopts i:d:s:t opt; do
    case "${opt}" in
      i) iso="${OPTARG}" ;;
      d) disk="${OPTARG}" ;;
      s) size="${OPTARG}" ;;
      t) nographics=1 ;;
      \?) >&2 echo "Invalid option: ${opt}"
    esac
  done

  [[ -n "${iso:-}" ]] || { >&2 echo "Specify iso file with -i"; exit 1; }

  local -a qemu_args=(
    -cpu host
    -accel kvm
    -smp 4
    -m 8G
    -k sv
    -cdrom "${iso}"
    -boot d
    -nic user,model=virtio
  )

  if ((nographics)); then
    # TODO Also redirect console to tty
    qemu_args+=(-nographic)
  fi

  if [[ -n "${disk:-}" ]]; then
    if ! [[ -f "${disk:-}" ]]; then
      >&2 echo "Creating disk ${disk} (${size:-8G})"
      truncate -s "${size:-8G}" "${disk}"
    fi
    qemu_args+=(-drive file="${disk}",if=virtio)
  fi

  qemu-system-x86_64 "${qemu_args[@]}"
}

main "$@"
