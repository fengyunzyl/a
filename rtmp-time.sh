#!/bin/bash
# See how long command stays alive

warn ()
{
  printf "\e[1;35m%s\e[m\n" "$*"
}

log ()
{
  warn "$@"
  eval "$@"
}

rtmpsuck -et
read f < rtmpsuck.txt

q=1
while read j < <(date)
do
  warn $j
  eval $f -B .1
  [ $? = 1 ] && break
  log sleep $q
  (( q *= 2 ))
done
