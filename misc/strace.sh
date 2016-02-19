#!/bin/dash
if [ $# != 1 ]
then
  echo 'strace.sh [dash script]'
  exit
fi

strace dash "$1" | wc --lines
