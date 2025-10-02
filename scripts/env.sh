# Adjust depending on your setup
qvm_dir=var/vms
# Toolbox container
if [[ -f /run/.containerenv ]] && [[ -d /run/host ]]; then
  root_dir=/run/host
fi
export QVM_DIR="${root_dir:-}/${qvm_dir}"
export PATH="$(realpath ${BASH_SOURCE[0]%/*}):${PATH}"
