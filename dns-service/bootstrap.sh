#!/bin/sh

set -e

fetch_bind_config_file() {
  if [ "$LOCAL_DEVELOPMENT" == "true" ]; then
    cp ./named.conf /etc/bind/named.conf

  fi
}

start_dns_server() {
  /usr/sbin/named -f 2>&1
}

start_dns_server_health_check() {
  source /health-check/.health-check/bin/activate \
  && python3 /health-check/health-check.py &
}

boot_metrics_agent() {
  ruby ./metrics/lib/agent.rb &
}

main() {
  fetch_bind_config_file
  boot_metrics_agent
  start_dns_server_health_check
  start_dns_server
}

main
