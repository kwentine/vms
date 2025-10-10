args=(
  -batch # Non-interactive mode
  -x509  # Output a certificate directly, rather than a request
  -out "${QVM_DIR}/certs/hosts/cp/cert.pem" # The generated certificate file
  -newkey rsa:2048 # Generate the certified keypair
  -keyout "${QVM_DIR}/certs/hosts/cp/priv.pem" # Generated private key
  -noenc # Do not encrypt the private key
  -subj "/CN=cp.qvm0.lan" # The identity bound by the certificate to the keypair
  -addext "subjectAltName = DNS:cp.qvm0" # Some flexibility for the valid domain names
  -addext "extendedKeyUsage=critical,serverAuth"
  -addext "basicConstraints = critical, CA:false"
  -days 365
  # Our QVM certificate authority
  -CA "${QVM_DIR}/certs/ca/cert.pem"
  -CAkey "${QVM_DIR}/certs/ca/priv.pem"
)

openssl req "${args[@]}"
