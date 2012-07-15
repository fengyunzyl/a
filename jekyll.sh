#!/bin/sh
# Launch Jekyll

[ ! $1 ] && echo "Usage: ${0##*/} REPO_NAME" && exit

cd /opt/$1

# Run
jekyll --auto --server &
cygstart "."
cygstart "http://localhost:4000"
