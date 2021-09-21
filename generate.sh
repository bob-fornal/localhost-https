#!/bin/bash

password=PASSWORD

echo "====> CLEARING certificates FOLDER"
mkdir -p certificates
cd certificates
rm -rf *
cd ..

echo ""
echo "====> GENERATING rootCA.key"
openssl genrsa \
  -passout pass:$password \
  -out certificates/rootCA.key \-des3 2048

echo ""
echo "====> GENERATING rootCA.pem"
openssl req \
  -passin pass:$password \
  -key certificates/rootCA.key \
  -out certificates/rootCA.pem \
  -config ./openssl-custom.cnf \
  -x509 \
  -nodes \
  -new \
  -sha256 \
  -days 7300

echo ""
echo "====> GENERATING server.key and server.csr"
openssl req \
  -keyout certificates/server.key \
  -out certificates/server.csr \
  -config ./openssl-custom.cnf \
  -nodes \
  -new \
  -sha256 \
  -newkey rsa:2048

echo ""
echo "====> GENERATING server.crt"
openssl x509 \
  -passin pass:$password \
  -CA certificates/rootCA.pem \
  -CAkey certificates/rootCA.key \
  -in certificates/server.csr \
  -out certificates/server.crt \
  -req \
  -CAcreateserial \
  -days 825 \
  -sha256 \
  -extfile ./v3.ext
