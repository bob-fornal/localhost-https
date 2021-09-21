#!/bin/bash

mkdir -p certificates
cd certificates
rm -rf *
cd ..

openssl genrsa \
  -passout pass:PASSWORD \
  -out certificates/rootCA.key \-des3 2048

openssl req \
  -passin pass:PASSWORD \
  -key certificates/rootCA.key \
  -out certificates/rootCA.pem \
  -config ./openssl-custom.cnf \
  -x509 \
  -nodes \
  -new \
  -sha256 \
  -days 7300

openssl req \
  -keyout certificates/server.key \
  -out certificates/server.csr \
  -config ./openssl-custom.cnf \
  -nodes \
  -new \
  -sha256 \
  -newkey rsa:2048

openssl x509 \
  -passin pass:PASSWORD \
  -CA certificates/rootCA.pem \
  -CAkey certificates/rootCA.key \
  -in certificates/server.csr \
  -out certificates/server.crt \
  -req \
  -CAcreateserial \
  -days 825 \
  -sha256 \
  -extfile ./v3.ext
