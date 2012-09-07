#!/bin/sh
# Launch Jekyll

die(){
  echo -e "\e[1;31m$1\e[m"
  exit
}

[ $1 ] || die "Usage: $0 REPO_NAME"

cd /opt/$1

# Run
jekyll --auto --server &
cygstart "."
cygstart "http://localhost:4000"
