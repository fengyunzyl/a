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

try ()
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
try cd ${REPLY%/*}

# Change mode locally
try chmod 755 $1

# Push mode change
try git update-index --add --chmod=+x $1
try git commit -m 'change mode'
try git push
