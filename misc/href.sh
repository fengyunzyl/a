#!/bin/sh
# [href$="27678931"], /* 2014-12-30 sp */
if [ $# != 2 ]
then
  echo href.sh USER URL
  exit
fi
foo=$(awk '$0=$--NF' FS='[/#]' <<< "$2")
bar=$(date -u +%F)
printf '[href*="%s"], /* %s %s */\n' $foo $bar $1
