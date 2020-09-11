#!/bin/sh

set -e

fetch_bind_config_file() {
  if [ "$LOCAL_DEVELOPMENT" == "true" ]; then
    cp ./named.conf /etc/bind/named.conf
  else
    aws s3 cp s3://${BIND_CONFIG_BUCKET_NAME}/named.conf /etc/bind/named.conf
  fi
}

start_dns_server() {
  /usr/sbin/named -f -g
}

main() {
  fetch_bind_config_file
  start_dns_server
}

main
