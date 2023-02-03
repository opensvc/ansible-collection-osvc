#!/usr/bin/env bash

svcpath=$1
expected=$2
timeout=${3:-60s}

om node wait --filter .monitor.services.\'${svcpath}\'.overall=${expected} --duration ${timeout}
