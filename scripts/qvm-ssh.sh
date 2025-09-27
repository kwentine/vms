set -eu
qvm_dir="${QVM_DIR}"
ssh_private_key="${qvm_dir}/ssh/id_ed25519"
ssh_config="${qvm_dir}/ssh/config"
user="guest"
instance="${1}"

export TERM=xterm-256color
ssh -q -i "${ssh_private_key}" -F "${ssh_config}" "${user}"@localhost -p 220"${instance}"
