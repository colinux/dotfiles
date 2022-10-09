#!/bin/bash


# set -x
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
source "${SCRIPT_DIR}/helpers.sh"
source "${SCRIPT_DIR}/shared.sh"


function collection_status() {
  $duplicity collection-status \
    "swift://$1"
}

collection_status home
