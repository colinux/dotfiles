#!/bin/bash

# https://cuonic.com/posts/duplicity-and-ovhs-object-storage

set -x
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
source "${SCRIPT_DIR}/helpers.sh"
source "${SCRIPT_DIR}/shared.sh"


########## Options
DRY_RUN=0
OPT_DRY_RUN=""
MODE="incremental"
DEST="swift://"
LOCAL_ONLY=0
FULL_IF_OLDER_THAN="30D"

while getopts "afnl" _OPTION; do
  # long option only
  case ${_OPTION} in
    f)
      MODE="full"
      DEST="file://${FULL_BACKUP_DIR}"
    ;;

    n)
      DRY_RUN=1
      OPT_DRY_RUN="--dry-run"
    ;;

    l)
      LOCAL_ONLY=1
    ;;

    a)
      MODE="--full-if-older-than ${FULL_IF_OLDER_THAN}"
    ;;

    *) echo "Usage: $0 [-a or -f] [-n] [-l]" >&2
      exit 1
    ;;
  esac
done
shift $((${OPTIND} - 1))


function duplicity_backup_folder() {
  $duplicity $MODE --progress \
    --verbosity info \
    --name $3 \
    --volsize 20 \
    --log-file ${LOGFILE} \
    --asynchronous-upload \
    --exclude-filelist ${SCRIPT_DIR}/exclude-list-${3}.txt \
    ${OPT_DRY_RUN} \
    "$1" "$2"
}

function backup_folder_old() {
  if [ ! "${MODE}" = "incremental" ]; then
    if [ -r "${FULL_BACKUP_DIR}/$2" ]; then
      echo "Full dir is not empty, resuming upload with swift."
    else
      duplicity_backup_folder "$1" "file://${FULL_BACKUP_DIR}/$2" $2
    fi

    if [ $LOCAL_ONLY -eq 0 ]; then
      swift_cloud_folder "${FULL_BACKUP_DIR}/$2" $2
    fi
  else
    duplicity_backup_folder "$1" "swift://$2" $2
  fi
}

function backup_folder() {
  duplicity_backup_folder "$1" "swift://$2" $2
}


function swift_cloud_folder {
  local source="$1"
  local container="$2"

  cd $source

  local cmd="$swift -V 2 --retries=100 --verbose upload --skip-identical $2 *.gpg"

  if [ $DRY_RUN -eq 0 ]; then
    echo $cmd
    $cmd
  else
    echo "Dry-run, not executing: ${cmd}"
  fi

  cd - >/dev/null

  rm -rf "${source}"
}

function prepare_logs() {
  if [ -r ${LOGFILE} ]; then
    date_suffix=`date "+%Y%m%d-%H%M%S"`
    gzip --best -S ".$date_suffix.gz" ${LOGFILE}
  fi

  touch ${LOGFILE}
  chmod 600 ${LOGFILE}
}

function prepare_backup() {
  mkdir -p "${BACKUP_EXPORTS}"

  brew tap > ${BACKUP_EXPORTS}/brew-tap.txt
  brew leaves > ${BACKUP_EXPORTS}/brew-packages.txt
  brew list --cask > ${BACKUP_EXPORTS}/brew-cask-packages.txt
  find /Applications -maxdepth 2 -type d  -not -path '*/Contents/*' -name '*.app' > ${BACKUP_EXPORTS}/applications-installed.txt
}

msg="Starting Backup at `date '+%Y%m%d-%H%M%S'`"
echo $msg
notify "$msg" 3

lock_or_abort

prepare_logs

prepare_backup

backup_folder ${HOME} home

notify "Sauvegarde terminée !"
