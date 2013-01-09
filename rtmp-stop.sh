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
  exec "${pp[@]}"
}

grepkill ()
{
  # search stderr, then kill
  while [ -d /proc/$aa ]
  do
    read < <(tr '\r .' '\n\t' < kk | tac | cut -f5)
    if (( $REPLY + 0 > $z ))
    then
      kill -13 %%
    fi
    sleep 1
  done
}

[ $1 ] || usage
z=$1
shift

log $@ -o a.flv 2> >(tee kk) &
aa=$!
grepkill $z kk
rm a.flv kk
