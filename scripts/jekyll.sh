#!/bin/sh
# Launch Jekyll

usage ()
{
  echo usage: $0 REPO_NAME
  exit
}

open ()
{
  $WINDIR/explorer $1
}

[ $1 ] || usage
cd /opt/$1
jekyll serve -w &
open .
open http://127.0.0.1:4000
