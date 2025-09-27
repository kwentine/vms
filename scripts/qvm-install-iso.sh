#!/usr/bin/env bash
set -eu

help_msg="
Install an operating system from an ISO image on a disk file.
The disk file is created if it does not exist
Usage: $(basename "$0") [-s SIZE] ISO_FILE DISK_FILE
Options:
  -h      Display this help message and exit.
  -n      Dry run. Print the command that would be executed.
  -s SIZE size of the disk file to create, in a format accepted by truncate(1)
          Default: 8G
          Ignored if DISK_FILE is given.
"

main() {
  local iso disk
  local size=8G
  local dry_run=0
  while getopts hns: opt; do
    case "${opt}" in
      h)
        echo "${help_msg}"
        exit 0 ;;
      s)
        size="${OPTARG}" ;;
      n)
        dry_run=1 ;;
      *)
        exit 1 ;;
    esac
  done

  shift $((OPTIND - 1))
  iso="${1:-}"
  disk="${2:-}"

  if [[ -z "${iso:-}" ]] || [[ -z "${disk:-}" ]]; then
    echo "ERROR: Provide ISO_FILE and DISK_FILE arguments"
    exit 1
  fi

  if ! [[ -f "${disk}" ]]; then
    echo "INFO: Creating disk ${disk} of size ${size}..."
    ! (( dry_run)) && truncate -s "${size}" "${disk}"
  fi

  declare -a cmd args
  if ((dry_run)); then
    cmd=(echo)
  fi
  cmd+=(qemu-system-x86_64)

  args=(
    -cpu host
    -accel kvm
    -smp 4
    -m 8G
    -k sv
    -cdrom "${iso}"
    -boot d
    -nic "user,model=virtio"
    -drive file="${disk},if=virtio"
  )

  echo "INFO: Starting installation virtual machine..."
  "${cmd[@]}" "${args[@]}"
}

main "$@"
