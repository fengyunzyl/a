#!/bin/bash

warn ()
{
  printf '\e[1;35m%s\e[m\n' "$*"
}

c ()
{
  printf '\ec'
}

while read -u3 k
do
  c
  cd $k
  git status
  warn $k
  read
done 3< <(compgen -d /opt/)
