#!/bin/sh
# Print Cygwin mirrors

IFS=/ read hh pp <<< "sourceware.org/cygwin/mirrors.lst"
exec 3<>/dev/tcp/$hh/80
echo "GET /$pp
Connection: close
Host: $hh" >&3

grep 'United States' <&3 |
  grep http |
  cut -d';' -f1 |
  while read k
  do
    echo "${#k} $k"
  done |
  sort
