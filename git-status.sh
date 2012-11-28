#!/bin/sh

warn ()
{
  echo -e "\e[1;35m$@\e[m"
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
