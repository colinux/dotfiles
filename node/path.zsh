function use_node() {
  version=$1

  if [[ -z $version ]]; then
    echo "Usage: use_node <version> or use_node latest" 2>&1
    return
  fi

  if [[ $version -eq "latest" ]]; then
    node_path="/opt/homebrew/opt/node/bin"
  else
    node_path="/opt/homebrew/opt/node@$version/bin"
  fi

  if [[ ! -d $node_path ]]; then
    echo "Node $version is not installed." 2>&1
    return
  fi

  export PATH="$node_path:$PATH"

  echo "Node $version was injected in your PATH"
  node -v
}

# If latest node is installed, fallback to 16
if [[ ! -d "/opt/homebrew/opt/node" ]]; then
  export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
fi

