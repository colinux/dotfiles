HOME=/Users/colin
BACKUP_CONFIG=${HOME}/.backup
BACKUP_EXPORTS=${BACKUP_CONFIG}/exports
LOCKFILE=${BACKUP_CONFIG}/run.lock
LOGFILE=${BACKUP_CONFIG}/log/duplicity.log
LOGFILE_RESTORE=${BACKUP_CONFIG}/log/duplicity-restore.log
FULL_BACKUP_DIR=${BACKUP_CONFIG}/full

duplicity=`which duplicity`
swift=`which swift`
notifier=`which terminal-notifier`

$swift -h |grep OpenStack >/dev/null || (echo "Swift OpenStack backend was not found. Reinstall it with pip3 install pip3 install python-swiftclient python-keystoneclient" && exit 1)

function get_credential() {
  cat $BACKUP_CONFIG/credentials/$1
}

export PASSPHRASE=`get_credential duplicity_passphrase`

# used by swift client (full backups)
export OS_AUTH_URL="https://auth.cloud.ovh.net/v3"
export OS_TENANT_ID=`get_credential os_tenant_id`
export OS_TENANT_NAME=`get_credential os_tenant_name`
export OS_USERNAME=`get_credential os_username`
export OS_PASSWORD=`get_credential os_password`
export OS_REGION_NAME="GRA"
#export OS_USER_DOMAIN_ID=default
# export OS_USER_DOMAIN_NAME="Default"
#export OS_IDENTITY_API_VERSION="3"
# export OS_PROJECT_NAME=123456789 ## you can get it with openstack project list

# used by duplicity backend
export SWIFT_AUTHURL=$OS_AUTH_URL
# export SWIFT_AUTHVERSION=$OS_IDENTITY_API_VERSION
export SWIFT_AUTHVERSION="3"
# export SWIFT_PROJECT_DOMAIN_NAME=$OS_USER_DOMAIN_NAME
export SWIFT_TENANTNAME=$OS_TENANT_NAME
export SWIFT_USERNAME=$OS_USERNAME
export SWIFT_PASSWORD=$OS_PASSWORD
export SWIFT_REGIONNAME=$OS_REGION_NAME
#export SWIFT_TENANTID="3f85767fc97741e8ae85df75a91591d1" ## project id in ovh manager (publiccloud)


########### Error and cleanup handling
function cleanup() {
  local exit_status=$1
  unset PASSPHRASE SWIFT_USERNAME SWIFT_PASSWORD SWIFT_AUTHURL SWIFT_AUTHVERSION SWIFT_TENANTNAME SWIFT_REGIONNAME
  unset OS_USERNAME OS_AUTH_URL OS_TENANT_NAME OS_TENANT_ID OS_PASSWORD

  if [ $exit_status -ne 150 ]; then
    rm -rf ${BACKUP_EXPORTS}/*
    rm -f $LOCKFILE
  fi
}

function handle_error() {
  local error=$2

  cleanup $error

  case $error in
    23)
      notify "Duplicity ran with an error. Error occured line $1."
    ;;

    150)
      notify "Backup already in progress. Aborting."
    ;;

    *)
      if [ $error -gt 0 ]; then
        notify "Error code $2 at line $1"
      fi
  esac
}

trap 'handle_error ${LINENO} $?; exit' EXIT INT TERM SIGHUP SIGINT SIGQUIT SIGILL SIGABRT


ulimit -n 1024
