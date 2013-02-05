#!/bin/sh
# Launch Jekyll

usage ()
{
  echo usage: $0 REPO_NAME
  exit
}

open ()
{
  cygstart $*
}

[ $1 ] || usage
cd /opt/$1

# Run
LANG=en_US.UTF-8 jekyll --auto --server &
open .
open http://127.0.0.1:4000
