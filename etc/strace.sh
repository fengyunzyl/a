#!/bin/dash
if [ $# = 0 ]
then
  echo 'strace.sh [dash script] [args]'
  exit
fi

strace dash "$@" | wc --lines
