#!/bin/sh

warn()
{
  printf "\e[1;35m%s\e[m" "$1"
}

# need trailing slash to filter out files
for i in /opt/*/
  do
    clear
    cd $i
    git status
    warn $i
    read
  done
