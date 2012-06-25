#!/bin/sh
# Launch Jekyll

test ! $1 && echo "Usage: ${0##*/} REPO_NAME" && exit

cd "/c/home/GitHub/$1"

# Run
jekyll --auto --server &
cygstart "."
cygstart "http://localhost:4000"
