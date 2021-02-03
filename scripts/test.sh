#!/bin/bash

set -euo pipefail

echo "Running dnsperf..."
# -s DNS server address
# -d query file path
# -c number of clients
# -Q nuber of requests per second
# -t timmeout (seconds)
dnsperf -s dns \
        -d test_queryfile \
        -c 1 \
        -Q 10 \
        -t 15 > ./test_result

has_completed_all_queries=`cat ./test_result | grep "Queries completed:    10 (100.00%)"`

if [[ -n $has_completed_all_queries ]]; then
  echo "Succeeded querying"
  exit 0
else
  echo "Failed querying"
  cat ./test_result
  exit 1
fi
