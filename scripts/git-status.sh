#!/bin/sh

warn ()
{
  printf '\e[1;35m%s\e[m\n' "$*"
}

if [[ $OSTYPE =~ linux ]]
then
  CLEAR=clear
else
  CLEAR='printf \ec'
fi

compgen -d /opt/ | while read k
do
  $CLEAR
  cd $k
  git status
  warn $k
  read </dev/tty
done
