#!/bin/bash


# set -x
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
source "${SCRIPT_DIR}/helpers.sh"
source "${SCRIPT_DIR}/shared.sh"


function cleanup() {
  $duplicity cleanup -v 9 \
    --force \
    --cf-backend swift \
    "swift://$1"
}

function removeOld() {
  $duplicity remove-all-but-n-full 2 \
    --force \
    --cf-backend swift \
    "swift://$1"
}

removeOld home
cleanup home
