#!/bin/sh
# Print Cygwin mirrors

IFS=/ read hh pp <<< "sources.redhat.com/cygwin/mirrors.lst"
exec 3<>/dev/tcp/$hh/80

echo "GET /$pp
Connection:close
Host: $hh" >&3

grep "United States" <&3 |
  grep "ftp" |
  cut -d\; -f1 |
  while read r
  do
    echo "${#r} $r"
  done |
  sort
