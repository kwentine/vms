args=(
  -out "${QVM_DIR}/certs/ca/priv.pem"
  -outpubkey "${QVM_DIR}/certs/ca/pub.pem"
  -outform PEM
  -algorithm RSA
  -pkeyopt rsa_keygen_bits:2048
)
openssl genpkey "${args[@]}"
