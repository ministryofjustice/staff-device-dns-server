#!/bin/bash

set -euo pipefail

expected_noerror_status=9
expected_nxdomain_status=1

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


test_dig_requests() {
  echo -e "**********************************************\n"
  echo -e "Running Dig Requests with Protocol = $1\n" 
  
  if [[ $1 == "tcp" ]]; then
    dig @dns -f test_queryfile +tcp +identify >test_result
  else
    dig @dns -f test_queryfile +identify >test_result
  fi

  status_no_error=`cat test_result | grep "status: NOERROR" | wc -l`
  status_nxdomain=`cat test_result | grep "status: NXDOMAIN" | wc -l`

  # Test expected NOERROR success scenario
  if (( $status_no_error == $expected_noerror_status )); then
    echo -e "${GREEN}**********************************************\n${NC}"
    echo -e "${GREEN} NOERROR TEST SUCCESSFUL${NC}"
    echo -e "${GREEN}**********************************************\n${NC}"
  else
    cat ./test_result
    echo -e "${RED}**********************************************\n${NC}"
    echo -e "${RED} NOERROR TEST UNSUCCESSFUL, expected $expected_noerror_status got $status_no_error!${NC}"
    echo -e "${RED}**********************************************\n${NC}"
    exit 1
  fi

  # Test expected NXDOMAIN failure scenario
  if (( $status_nxdomain == $expected_nxdomain_status )); then
    echo -e "${GREEN}**********************************************\n${NC}"
    echo -e "${GREEN} NXDOMAIN TEST SUCCESSFUL${NC}"
    echo -e "${GREEN}**********************************************\n${NC}"
  else
    cat ./test_result
    echo -e "${RED}**********************************************\n${NC}"
    echo -e "${RED} NXDOMAIN TEST UNSUCCESSFUL, expected $expected_nxdomain_status got $status_nxdomain!${NC}"
    echo -e "${RED}**********************************************\n${NC}"
    exit 1
  fi
}

main() {
  echo "Starting main ..."
  test_dig_requests "udp"
  test_dig_requests "tcp"
}
main