#!/bin/bash

warn ()
{
  printf "\e[1;35m%s\e[m\n" "$*"
}

while read -u 3
do
  clear
  cd $REPLY
  git status
  warn $REPLY
  read
done 3< <(compgen -d /opt/)
