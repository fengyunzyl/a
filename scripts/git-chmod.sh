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

log ()
{
  local gh
  for gg
  do
    [[ "$gg" =~ [\ \&] ]] && gg="\"$gg\""
    gh+=("$gg")
  done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

[ $1 ] || usage

read < <(type -p $1)
log cd ${REPLY%/*}

# Change mode locally
log chmod 755 $1

# Push mode change
log git update-index --add --chmod=+x $1
log git commit -m 'change mode'
log git push
