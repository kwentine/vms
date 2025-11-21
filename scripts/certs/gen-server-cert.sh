#!/bin/bash
set -eu
hostname="${1}"
ca_dir="${QVM_DIR}/certs/ca"
cert_dir="${QVM_DIR}/certs/hosts/${hostname}"
mkdir -p "${cert_dir}"
args=(
  -batch                                                                    # Non-interactive mode
  -x509                                                                     # Output a certificate directly, rather than a request
  -out "${cert_dir}/server.pem"                                             # The generated certificate file
  -newkey rsa:2048                                                          # Generate the certified keypair
  -keyout "${cert_dir}/priv.pem"                                            # Generated private key
  -noenc                                                                    # Do not encrypt the private key
  -subj "/CN=${hostname}.qvm0.lan"                                          # The identity bound by the certificate to the keypair
  -addext "subjectAltName = DNS:${hostname}.qvm0, DNS:${hostname}.qvm0.lan" # Some flexibility for the valid domain names
  -addext "extendedKeyUsage=critical,serverAuth"
  -addext "basicConstraints = critical, CA:false"
  -days 365
  # Our QVM certificate authority
  -CA "${ca_dir}/cert.pem"
  -CAkey "${ca_dir}/priv.pem"
)
openssl req "${args[@]}"
