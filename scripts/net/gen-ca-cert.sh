args=(
  -x509
  -key "${QVM_DIR}/certs/ca/priv.pem"
  -subj "/CN=QVM"
  -days 365
  -out "${QVM_DIR}/certs/ca/cert.pem"
)
openssl req "${args[@]}"
