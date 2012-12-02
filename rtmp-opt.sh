#!/bin/sh
# Optimize RTMP string

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

try ()
{
  warn "$@"
  eval "$@"
}

usage ()
{
  warn "Usage:  ${0##*/} COMMAND"
  exit
}

trim ()
{
  read $1 <<< ${!1/\/\/www.///}
  read $1 <<< ${!1/:1935\///}
}

[ $1 ] || usage
shift

aa=-1
while [ "$1" ]
do
  if [ ${1::1} = - ]
    then
      (( aa++ ))
      ab[aa]="$1"
    else
      if [[ "$1" =~ [\ \&] ]]
        then
          ab[aa]+=" \"$1\""
        else
          ab[aa]+=" $1"
      fi
      trim ab[aa]
  fi
shift
done

for ac in ${!ab[@]}
do
  read <<< ${ab[ac]}
  ab[ac]=
  try rtmpdump -o a.flv -B .1 ${ab[@]} || ab[ac]=$REPLY
done

warn rtmpdump -o a.flv ${ab[@]}
