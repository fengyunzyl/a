#!/bin/sh
# See how long command stays alive

read -d! < <(rtmpsrv -i)

while date
do eval $REPLY -B .1
  [ $? = 1 ] && break
  sleep 10
done
