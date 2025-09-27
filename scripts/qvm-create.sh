qvm_dir="${QVM_DIR:-$(pwd)}"
output_dir="${qvm_dir}/machines"
template_dir="../templates"

help_msg="
Create an overlay VM from a base disk image.
Base images are searched in QVM_DIR/templates,
and VM disks created in QVM_DIR/machines.
If not set, QVM_DIR defaults to the current directory.

Usage: $(basename "$0") [-n] -b BASE_DISK [-s SIZE] DISK_NAME
Options:
  -n                 Dry run
  -b    BASE_IMAGE
  -s    SIZE         Default: 8G
"

declare base size dry_run
dry_run=0
size=8G

while getopts b:s:nh opt; do
  case "${opt}" in
    h)
      echo "${help_msg}"
      exit 0 ;;
    n)
      dry_run=1 ;;
    s)
      size="${OPTARG}" ;;
    b)
      base="${OPTARG}" ;;
    *)
      echo "ERROR: Invalid option: ${opt}"
      exit 1 ;;
  esac
done
shift $((OPTIND - 1))

declare overlay="${1}"

if [[ -z "${base:-}" ]] || [[ -z "${overlay:-}" ]]; then
  echo "ERROR: required: -b BASE_IMAGE DISK_NAME"
  exit 1
fi

declare -a cmd args

if ((dry_run)); then
  cmd=(echo)
fi
cmd+=(qemu-img)

args=(
  create
  -f qcow2
  -b "${template_dir}/${base}"
  -F qcow2
  "${output_dir}/${overlay}"
  "${size}"
)

"${cmd[@]}" "${args[@]}"
