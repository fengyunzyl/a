#!/bin/sh
if [ $# != 1 ]
then
  echo 'noscript.sh [domain]'
  exit
fi
printf '%s %s %s' {,http://,https://}$1 | tee /dev/clipboard
printf '\ncopied to clipboard\n'
