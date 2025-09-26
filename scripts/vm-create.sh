# Create an "overlay" VM from a base disk image.
root_dir="$(pwd)"
output_dir="${root_dir}/machines"
template_dir="${root_dir}/templates"

declare -a cmd
declare -a args

run() {
  [ ${#cmd} -gt 0 ] && "${cmd[@]}" "${args[@]}"
}

dry_run=0
if ((dry_run)); then
  cmd=(echo)
fi
cmd+=(qemu-img)

args=(
  create
  -f qcow2
  -b "${template_dir}/"rhel10-server.qcow2
  -F qcow2
  "${output_dir}/"cp1.qcow2
  8G
)

run
