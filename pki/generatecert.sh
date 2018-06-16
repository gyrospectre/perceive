#!/bin/bash

certname=$1

# Generate Certificate
curl -d '{ "request": {"CN": "'$certname'","hosts":["$certname"],"key": { "algo": "rsa","size": 2048 },
 "names": [{"C":"AU","ST":"New South Wales","L":"Sydney","O":"perceive.internal"}]} }' \
  http://127.0.0.1:8888/api/v1/cfssl/newcert -o tmpcert.json

# Create Private Key
cat tmpcert.json | jq --raw-output '.result.private_key' > $certname.key

# Create Certificate
cat tmpcert.json | jq --raw-output '.result.certificate' > $certname.cer

# Create Certificate Request
cat tmpcert.json | jq --raw-output '.result.certificate_request' > $certname.csr

# Remove JSON Data
rm -Rf tmpcert.json