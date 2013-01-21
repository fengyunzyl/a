#!/bin/bash
# Running rtmpdump --stop can cause this error with live streams
# Received FLV packet before play()!

usage ()
{
  echo "Usage:  $0 STOP COMMAND"
  exit
}

warn ()
{
  printf "\e[36m%s\e[m\n" "$*"
}

quote ()
{
  [[ ${!1} =~ [\ \#\&\;] ]] && read $1 <<< \"${!1}\"
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
  eval exec "${pp[@]}"
}

[ $1 ] || usage
z=$1
shift

while read -d $'\r'
do
  [[ $REPLY =~ /\ ([0-9]*) ]]
  if (( ${BASH_REMATCH[1]} + 1 > $z ))
  then
    kill $!
  fi
done < <(log "$@" &> >(tee /dev/tty))
