brew install coreutils

# Command tools
brew install ack ag
brew install git
brew install ssh-copy-id
brew install tmux
brew install tree

# Utils
brew install bat
brew install git-delta
brew install fd
brew install direnv
brew install git-delete-merged-branches
brew install jq
brew install httpie
brew install htop
brew install imagemagick
brew install pgcli
brew install pdftotext
brew install ffmpeg
brew install sd
brew install yt-dlp/taps/yt-dlp


# GPG
if test ! $(which gpg); then
  brew install gnupg pinentry-mac

  # Then import public & private keys. Set pinentry as gpg agent ;
  # https://stackoverflow.com/questions/39494631/gpg-failed-to-sign-the-data-fatal-failed-to-write-commit-object-git-2-10-0
  echo "Finish GnuPG configuration by importing public & private keys"
  echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
  killall gpg-agent
fi

# OSX tools & casks
brew install insomnia
brew install firefox
brew install imageoptim
brew install rectangle
brew install slack
brew install vlc
brew install homebrew/cask/handbrake

# Vim & deps
brew install fzf
brew install neovim goneovim
brew install gh

# Languages & dev utils
brew install heroku/brew/heroku
brew install overmind
brew install rbenv
brew install ruby-build
brew install shared-mime-info # for mimemagic gem

# React-Native & debuggers
brew install --cask flipper react-native-debugger
brew install watchman
brew tap facebook/fb
brew install idb-companion

brew install node@14
brew install node@16

brew install android-studio
brew install geckodriver
brew install sequel-ace

brew install postgresql@13 libpq
brew install redis
brew install elasticsearch-oss


brew cleanup
