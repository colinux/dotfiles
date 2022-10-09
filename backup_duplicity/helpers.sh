function notify() {
  local msg=$1
  local timeout=$2

  local opt_timeout=""
  if [ -n $timeout ]; then
    opt_timeout="-timeout $timeout"
  fi

  $notifier \
    -title "Sauvegardes" \
    -appIcon "${SCRIPT_DIR}/icon.png" \
    ${opt_timeout} \
    -message "$1"
}

function check_path_restore() {
  if [ -r $1 ]; then
    echo "La destination de restauration \"$1\" existe déjà et ne sera pas écrasée."
    exit 1
  fi
}

function lock_or_abort() {
  if [ -r $LOCKFILE ]; then
    echo "Lockfile found. Abort."
    exit 150 # status important in order to not remove current lock file !
  fi

  touch $LOCKFILE
}
