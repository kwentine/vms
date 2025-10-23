#!/bin/bash
#!/bin/bash
guest="${1:-cp}"
cert_dir=/root/cert
# Ensure target directory exists

ssh -F "${QVM_DIR}/ssh/config" "root@${guest}.qvm0.lan" mkdir -p "${cert_dir}"

args=(
  -F "${QVM_DIR}/ssh/config"
  # Sources
  "${QVM_DIR}/certs/hosts/${guest}/"{server,priv}.pem
  # Dest
  "root@${guest}.qvm0.lan:${cert_dir}"
)

scp "${args[@]}"
