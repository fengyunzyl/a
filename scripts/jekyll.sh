#!/bin/sh
# Launch Jekyll

if [[ $OSTYPE =~ linux ]]
then
  XDG_OPEN=xdg-open
else
  XDG_OPEN="$WINDIR/system32/cmd /c start"
fi

usage ()
{
  echo usage: $0 REPO_NAME
  exit
}

[ $1 ] || usage
cd /opt/$1
jekyll serve -w &
$XDG_OPEN .
$XDG_OPEN http://127.0.0.1:4000
