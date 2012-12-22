#!/bin/sh
# See how long command stays alive

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

read -d! f < <(rtmpsrv -i)

while read j < <(date)
do
  warn $j
  eval $f -B .1
  [ $? = 1 ] && break
  sleep 10
done
