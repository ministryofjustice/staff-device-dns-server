#!/bin/sh

set -e


dnsperf -s dns \
        -d 1k_queryfile \
        -c 10000 \
        -Q 1000000 \
        -t 2 \
        -l 300
