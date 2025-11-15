#!/bin/bash
set -eu

certs=(
  "admin" "wk1" "wk2"
  "kube-proxy" "kube-scheduler"
  "kube-controller-manager"
  "kube-api-server"
  "service-accounts"
)
ca_dir="${QVM_DIR}/certs/ca"
cert_dir="${QVM_DIR}/certs/k8s"
mkdir -p "${cert_dir}"

for i in ${certs[*]}; do
  args=(
    -batch # Non-interactive mode
    -x509  # Output a certificate directly, rather than a request.
           # Implied by -CA, but kept for clarity.
    -out "${cert_dir}/${i}.crt" # The generated certificate file
    -newkey rsa:4096 # Generate the certified keypair
    -keyout "${cert_dir}/${i}.key" # Generated private key
    -noenc # Do not encrypt the private key
    -config "certs.conf" -section "${i}"
    # Our QVM certificate authority
    -CA "${ca_dir}/cert.pem"
    -CAkey "${ca_dir}/priv.pem"
  )
  openssl req "${args[@]}"
done
