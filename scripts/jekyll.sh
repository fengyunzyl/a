#!/bin/sh
# Launch Jekyll

usage ()
{
  echo "Usage:  $0 REPO_NAME"
  exit
}

[ $1 ] || usage
cd /opt/$1

# Run
jekyll --auto --server &
open '.'
open 'http://localhost:4000'
