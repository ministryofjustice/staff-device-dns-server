#!/bin/bash

set -euo pipefail

run_dnsperf_test() {
  port=$1
  protocol=$2
  
  echo "Running dnsperf on: port $port/$protocol ..."
 
  # -s DNS server address
  # -p port listening port
  # -m mode protocol udp/tcp
  # -d query file path
  # -c number of clients
  # -Q nuber of requests per second
  # -t timmeout (seconds)

  dnsperf -s dns \
          -p $port \
          -m $protocol \
          -d test_queryfile \
          -c 1 \
          -Q 10 \
          -t 15 > ./test_result

  has_completed_all_queries=`cat ./test_result | grep "Queries completed:    10 (100.00%)"`

  if [[ -n $has_completed_all_queries ]]; then
    echo "Succeeded querying"
  else
    echo "Failed querying"
    cat ./test_result
    exit 1
  fi

}

run_dnsperf_test 53 udp
run_dnsperf_test 5353 tcp

