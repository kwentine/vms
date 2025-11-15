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
cp "${ca_dir}/cert.pem" "${cert_dir}/ca.crt"
cp "${ca_dir}/priv.pem" "${cert_dir}/ca.key"

for i in ${certs[*]}; do
  openssl genrsa -out "${cert_dir}/${i}.key" 4096

  openssl req -new -key "${cert_dir}/${i}.key" -sha256 \
    -config "certs.conf" -section ${i} \
    -out "${cert_dir}/${i}.csr"

  openssl x509 -req -days 3653 -in "${cert_dir}/${i}.csr" \
    -copy_extensions copyall \
    -sha256 -CA "${cert_dir}/ca.crt" \
    -CAkey "${cert_dir}/ca.key" \
    -CAcreateserial \
    -out "${cert_dir}/${i}.crt"
done
