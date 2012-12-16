#!/bin/bash
# stackoverflow.com/q/9027584/how-to-change-the-file-mode-on-github

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

usage ()
{
  warn "Usage:  ${0##*/} FILE"
  exit
}

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

log ()
{
  local gh
  for gg
  do
    quote gg
    gh+=("$gg")
  done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

[ $1 ] || usage

# Change mode locally
log chmod 755 $1

# Push mode change
log git update-index --chmod=+x $1
log git commit -am "change mode $1"
log git push
