#!/bin/sh
# Launch Jekyll

usage ()
{
  echo usage: $0 REPO_NAME
  exit
}

[ $1 ] || usage
cd /opt/$1

# Run
LANG=en_US.UTF-8 jekyll --auto --server &
open '.'
open 'http://localhost:4000'
