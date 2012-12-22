#!/bin/bash
# See how long command stays alive

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

log ()
{
  warn "$@"
  eval "$@"
}

read -d! f < <(rtmpsrv -i)

q=1
while read j < <(date)
do
  warn $j
  eval $f -B .1
  [ $? = 1 ] && break
  log sleep $q
  (( q *= 2 ))
done
