#!/bin/bash
# Accept SSM paths and run cert validation

ENV=$1
PRODUCT=$2
SERVICE=$3

if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 environment product service"
  echo "environment: dev,qa,staging,prod"
  echo "product: nest,ingest, etc"
  echo "service: mongo,rds,lambda,etc"
  echo "e.g.: ./certificate-validator.sh staging nest mongo"
  exit 3
fi

CERTS=$(aws ssm get-parameters-by-path --with-decryption --path "/com/warnerbros/contentnow/${ENV}/${PRODUCT}/${SERVICE}/ssl/")

CERT=$(echo $CERTS | jq '.Parameters | .[] | select(.Name | contains("INT") or contains("KEY") | not) | .Value')
PRIVATE_KEY=$(echo $CERTS | jq '.Parameters | .[] | select(.Name | contains("KEY")) | .Value')
INTERMEDIATE_CERT=$(echo $CERTS | jq '.Parameters | .[] | select(.Name | contains("INT")) | .Value')

# Remove the first and last double quote
CERT=$(sed -e 's/^"//' -e 's/"$//' <<<"$CERT")
PRIVATE_KEY=$(sed -e 's/^"//' -e 's/"$//' <<<"$PRIVATE_KEY")
INTERMEDIATE_CERT=$(sed -e 's/^"//' -e 's/"$//' <<<"$INTERMEDIATE_CERT")

# -e to ensure the \n is handled
CERT_MD5=$(echo -e $CERT | openssl x509 -noout -modulus -in /dev/stdin | openssl md5)
PRIVATE_KEY_MD5=$(echo -e $PRIVATE_KEY| openssl rsa -noout -modulus -in /dev/stdin | openssl md5)
IS_INTERMEDIATE_CERT_OK=$(echo -e $INTERMEDIATE_CERT | openssl verify -verbose)

if [ "$CERT_MD5" = "$PRIVATE_KEY_MD5" ]; then
  echo "Cert and private key match!"
else
  echo "ERROR: Cert and private key DO NOT match!" 
fi

if [ "$IS_INTERMEDIATE_CERT_OK" = "stdin: OK" ]; then
  echo "Intermediate looks ok!"
else
  echo "ERROR: Intermediate cert has issues!" 
fi