#!/bin/sh

set -e

fetch_bind_config_file() {
  if [ "$LOCAL_DEVELOPMENT" == "true" ]; then
    cp ./named.conf /etc/bind/named.conf
  else
    aws s3 cp s3://${BIND_CONFIG_BUCKET_NAME}/named.conf /etc/bind/named.conf
  fi
}

fetch_bind_zone_files() {
  if ![ "$LOCAL_DEVELOPMENT" == "true" ]; then
    aws s3 cp s3://${BIND_CONFIG_BUCKET_NAME}/zones/* /var/named/zones
  fi
}

start_dns_server() {
  /usr/sbin/named -f -g
}

boot_metrics_agent() {
  ruby ./metrics/lib/agent.rb &
}

main() {
  fetch_bind_config_file
  fetch_bind_zone_files
  boot_metrics_agent
  start_dns_server
}

main
