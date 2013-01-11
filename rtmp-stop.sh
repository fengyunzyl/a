#!/bin/bash
# Running rtmpdump --stop can cause this error with live streams
# Received FLV packet before play()!

usage ()
{
  echo "Usage:  $0 STOP COMMAND"
  exit
}

watch ()
{
  while [ -d /proc/$2 ]
  do
    sleep 1
    read < <(tr '\r .' '\n\t' < kk | tac | cut -f5)
    if (( $REPLY + 1 > $3 ))
    then
      kill -13 $2
      break
    fi
  done
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

log "$@" 2> >(tee kk) &
watch kk $! $z
rm a.flv kk
