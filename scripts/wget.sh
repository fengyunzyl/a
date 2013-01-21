#!/bin/sh
# My attempt at pure Bash wget

usage ()
{
  echo usage: $0 URL
  exit
}

download()
{
  # parse url
  [[ $1 =~ (http://)?([^/]*)/([^?]*)\?(.*) ]]
  host=${BASH_REMATCH[2]}
  path=${BASH_REMATCH[3]}
  qs=${BASH_REMATCH[4]}
  exec 3<>/dev/tcp/$host/80
  echo GET /$path?$qs HTTP/1.1 >&3
  echo connection: close >&3
  echo host: $host >&3
  echo >&3
  cat > $path <&3 &

  # status
  pid=$!
  read < <(du -b | cut -f1)
  while [ -d /proc/$pid ]
  do
    sleep .3
    du -b |
    cut -f1 |
    xargs -i% expr % - $REPLY |
    xargs printf "%'.3d\r" >&2
  done

  while read
  do
    if [[ $REPLY =~ Location:.(.*) ]]
    then
      # follow redirect
      break
    elif ! [[ $REPLY ]]
    then
      # good download, remove headers
      sed -i -b '1,/^\r/d' $path
      return
    fi
  done < $path
  
  download ${BASH_REMATCH[1]}
}

[ $1 ] || usage

download $1
