#!/usr/bin/env bash

NODE=$1
SVC=$2
SCOPE=$3
STATE=$4
DURATION=$5

# examples

# wait for 60 seconds that prd/svc/oracle avail status is up
# $0 prd/svc/oracle avail up 60

# wait for 300 seconds that prd/svc/oracle averall status is down
# $0 prd/svc/oracle overall down 300


om node wait --filter monitor.nodes."${NODE}".services.status.\'"${SVC}"\'."${SCOPE}"="${STATE}" --duration "${DURATION}" --verbose
