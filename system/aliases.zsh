# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -lA --color"
fi

# security aliases
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Finder
alias o='open .'

# Bat is better than cat, but disable line numbers
alias cat="bat"
alias pat="bat -p"

# always prefer nvim, goneovim for code
alias vi="nvim"
alias vim="nvim"
function c() {
  exec /Applications/goneovim${GONEOVIM_VARIANT}.app/Contents/MacOS/goneovim --maximized "${1:-.}" &
}

alias g="git"

# copy with resume support via ssh/scp. Usage : scpresume dir_source host
alias scpresume="rsync --partial --progress --copy-links --rsh='ssh' -z -a --copy-unsafe-links"

# Get External IP / local IPs, network
alias ip="curl ipinfo.io/ip"
alias ip6="curl v6.ipv6-test.com/api/myip.php"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias iplan="ips |grep 'broadcast' |cut -f2 -d' '"
alias port_check="nc -vz localhost $@" # ie. nc -v localhost 3000
alias speedtest="curl -o /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip"

# http
alias curl_headers="curl -s -D - -o /dev/null $@"
alias headers="http --headers $@"

# Quickly serve the current directory as HTTP
alias serve='python3 -m SimpleHTTPServer'

alias tl='tail -0f log/*.log | bat --paging=never -l log'

# no annoying autocorrect
alias h="nocorrect heroku"
alias "heroku"="nocorrect heroku"
alias nb="jupyter notebook notebooks"
alias jest="nocorrect jest"
alias bundle='nocorrect bundle'
alias yarn='nocorrect yarn'


# aliases for DS
alias ds="/Users/colin/code/ds-cli/ds"
