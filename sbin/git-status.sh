#!/bin/bash

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

while read -u 3
  do
    clear
    cd $REPLY
    git status
    warn $REPLY
    read
  done 3< <(find /opt -maxdepth 1 -mindepth 1 -type d)
