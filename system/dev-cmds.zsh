# Connect or reconnect to a tmux session. IE t <server> <user>
function t(){
  remote=${1}
  session=${2:-`whoami`}
  ssh ${remote} -t "tmux attach -t ${session} || tmux  new -s ${session}"
}

# Start dev processes depending on current directory, by tring to read executables or proc files.
function s(){
  if [ -f './Procfile.dev' ]; then
    command overmind start -f ./Procfile.dev -x worker $*
  elif [ -f './Procfile' ]; then
    command overmind start --port `(printenv PORT || echo "3000")`
  elif [ -f "bin/rails" ]; then
    command bin/rails s
  elif [ -d ".expo" ]; then
    command expo start --dev-client
  fi
}


# Mount freebox server
function mount_fbx() {
  mount_point="/Volumes/Freebox/"
  if [ ! -d $mount_point ]; then
    echo "$mount_point does not exist... we need to create it !"
    sudo mkdir $mount_point && sudo chown colin:wheel $mount_point && chmod 755 $mount_point
  fi
  mount_afp "afp://Freebox%20Server._afpovertcp._tcp.local/FreebExt/" $mount_point
}

# Start guard
function guard() {
  echo "Run guard with notifications disabled"
  DISABLE_SPRING=true GUARD_NOTIFY=false bundle exec guard "$@"
}

# Kill all ruby processes
function kill_ruby() {
    kill $(ps aux | grep -E 'sidekiq|unicorn|puma|thin|foreman|overmind|ruby|guard|spring' | grep -v grep | awk '{print $2}')
}


# Add a reload launchtl cmd
function launchctl() {
    launchctl_path="/bin/launchctl"
    command=$1

    if  [ $command = "reload" ]; then
        $launchctl_path unload $2
        $launchctl_path load $2
        return
    fi

    $launchctl_path $command $2
}

# Jest in debug mode with instructions
function jest_debug() {
  echo "Open Chrome at chrome://inspect/ , deicated devTools and choose the matching port url"

  node --inspect-brk node_modules/.bin/jest --runInBand $@
}

# Regenerate gcloud token
function gcloud_token() {
    export GCLOUD_AUTH_TOKEN=$(ssh imparato@imp 'gcloud auth application-default print-access-token')
    echo $GCLOUD_AUTH_TOKEN;
}

# Extract dev@imparato.io account token
function dev_imp_token() {
  query="select authentication_token from users where email = '$IMPARATO_EMAIL' limit 1;"
  # no argument = dev
  if [ $# -eq 0 ]; then
    psql -d api_imparato_io_development -c "${query}"
  else
    heroku psql $IMPARATO_PG_RO_DB -c "${query}" "$@"
  fi
}

