# Mount freebox server
function mount_fbx() {
  mount_point="/Volumes/Freebox/"
  if [ ! -d $mount_point ]; then
    echo "$mount_point does not exist... we need to create it !"
    sudo mkdir $mount_point && sudo chown colin:wheel $mount_point && chmod 755 $mount_point
  fi
  mount_afp "afp://Freebox%20Server._afpovertcp._tcp.local/FreebExt/" $mount_point
}

alias qrencode-shell="qrencode -t UTF8 -o -"
