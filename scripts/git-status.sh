#!/bin/sh

warn ()
{
  printf '\e[1;35m%s\e[m\n' "$*"
}

c ()
{
  printf '\ec'
}

compgen -d /opt/ | while read k
do
  c
  cd $k
  git status
  warn $k
  read </dev/tty
done
