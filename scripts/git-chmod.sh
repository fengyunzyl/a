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
  local pp
  for oo
  do
    quote oo
    pp+=("$oo")
  done
  warn "${pp[@]}"
  eval "${pp[@]}"
}

[ $1 ] || usage

# Change mode locally
log chmod 755 $1
# --add is needed for mode change
log git update-index --add --chmod=+x $1
log git commit -m "change mode $1"
log git push
