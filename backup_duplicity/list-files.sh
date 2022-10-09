#!/bin/bash


# set -x
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
source "${SCRIPT_DIR}/helpers.sh"
source "${SCRIPT_DIR}/shared.sh"

TIME=$1
if [ -z $TIME ]; then
  TIME="1h"
fi

function list_current_files() {
  $duplicity list-current-files \
    --time $1 "swift://$2"
}

list_current_files $TIME home
