#!/bin/bash
# Running rtmpdump --stop can cause this error with live streams
# Received FLV packet before play()!

usage ()
{
  echo "Usage:  $0 STOP COMMAND"
  exit
}

grepkill ()
{
  # search stderr, then kill
  while [ -d /proc/$aa ]
  do
    read < <(tr '\r .' '\n\t' < kk | tac | cut -f5)
    if (( $REPLY + 1 > $z ))
    then
      kill -13 %%
    fi
    sleep 1
  done
}

[ $1 ] || usage
z=$1
shift

exec $@ -o a.flv 2> >(tee kk) &
sleep 1
aa=$!
grepkill $z kk
rm a.flv kk
